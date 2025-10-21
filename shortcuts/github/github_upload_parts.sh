


# "$1" == build-${{ github.run_id }}-${{ github.run_attempt }}
#shift
# "$@" == ./_local/package_image_beforeBoot.tar.flx.part*
_gh_release_upload_parts-multiple() {
    "$scriptAbsoluteLocation" _gh_release_upload_parts-multiple_sequence "$@"
}

# --- helper: check if an asset name exists on a tag ---
_gh_release_asset_present() {
  local currentTag="$1"
  local assetName="$2"
  "$scriptAbsoluteLocation" _timeout_strict 120 \
    gh release view "$currentTag" --json assets 2>/dev/null \
    | grep -F "\"name\":\"$assetName\"" >/dev/null
}

_gh_release_upload_parts-multiple_sequence() {
  _messagePlain_nominal '==rmh== _gh_release_upload_parts: '"$@"
  local currentTag="$1"; shift

  # keep a copy of the file list for verification later
  local -a __files=( "$@" )

  # parallelism (default 12, can override via UB_GH_UPLOAD_PARALLEL)
  local currentStream_max="${UB_GH_UPLOAD_PARALLEL:-12}"
  local currentStreamNum=0

  # kick off uploads
  local currentFile
  for currentFile in "${__files[@]}"; do
    let currentStreamNum++
    "$scriptAbsoluteLocation" _gh_release_upload_part-single_sequence "$currentTag" "$currentFile" &
    eval local currentStream_${currentStreamNum}_PID="$!"
    _messagePlain_probe_var currentStream_${currentStreamNum}_PID

    while [[ $(jobs | wc -l) -ge "$currentStream_max" ]]; do
      echo; jobs; echo
      sleep 2
      true
    done
  done

  # wait for all background uploads to finish
  local currentStreamPause
  for currentStreamPause in $(seq "1" "$currentStreamNum"); do
    _messagePlain_probe "==rmh==currentStream_${currentStreamPause}_PID= $(eval "echo \$currentStream_${currentStreamPause}_PID")"
    if eval "[[ \$currentStream_${currentStreamPause}_PID != '' ]]"; then
      _messagePlain_probe "==rmh== _pauseForProcess $(eval "echo \$currentStream_${currentStreamPause}_PID")"
      _pauseForProcess        $(eval "echo \$currentStream_${currentStreamPause}_PID")
    fi
  done

  while [[ $(jobs | wc -l) -ge 1 ]]; do
    echo; jobs; echo
    sleep 3
    true
  done
  wait  # reap

  # -------------------------------
  # Settle + verification 
  # -------------------------------

  # expected asset names (basenames only)
  local -a expected_names=()
  local f
  for f in "${__files[@]}"; do
    expected_names+=( "$(basename -- "$f")" )
  done

  # settle: wait until all expected assets become visible on the release
  # tunables: UB_GH_VERIFY_ATTEMPTS (default 15), UB_GH_VERIFY_SLEEP (default 8s)
  local max_attempts="${UB_GH_VERIFY_ATTEMPTS:-15}"
  local sleep_s="${UB_GH_VERIFY_SLEEP:-8}"
  local assets_json attempt=1
  while :; do
    assets_json=$("$scriptAbsoluteLocation" _timeout_strict 180 gh release view "$currentTag" --json assets 2>/dev/null || true)

    # count missing
    local missing_count=0
    local name
    for name in "${expected_names[@]}"; do
      if ! printf '%s' "$assets_json" | grep -F "\"name\":\"$name\"" >/dev/null; then
        missing_count=$((missing_count+1))
      fi
    done

    if [[ $missing_count -eq 0 ]]; then
      _messagePlain_probe "==rmh== all assets visible after attempt $attempt"
      break
    fi
    if [[ $attempt -ge $max_attempts ]]; then
      _messagePlain_probe "==rmh== assets still missing after ${attempt} attempts; proceeding to per-asset retries"
      break
    fi

    _messagePlain_probe "==rmh== waiting for assets to appear (attempt $attempt/${max_attempts}); missing=${missing_count}"
    sleep "$sleep_s"
    attempt=$((attempt+1))
  done

  # per-asset verification with short retries (handles stragglers)
  # tunables: UB_GH_VERIFY_PER_ASSET_ATTEMPTS (default 6), UB_GH_VERIFY_PER_ASSET_SLEEP (default 5s)
  local rc=0
  local per_attempts="${UB_GH_VERIFY_PER_ASSET_ATTEMPTS:-6}"
  local per_sleep="${UB_GH_VERIFY_PER_ASSET_SLEEP:-5}"

  local name ok a
  for name in "${expected_names[@]}"; do
    ok=""
    for a in $(seq 1 "$per_attempts"); do
      assets_json=$("$scriptAbsoluteLocation" _timeout_strict 180 gh release view "$currentTag" --json assets 2>/dev/null || true)
      if printf '%s' "$assets_json" | grep -F "\"name\":\"$name\"" >/dev/null; then
        _messagePlain_probe "==rmh== asset verified: $name"
        ok="true"
        break
      fi
      _messagePlain_probe "==rmh== asset not yet visible ($name), retry ${a}/${per_attempts}"
      sleep "$per_sleep"
    done

    if [[ -z "$ok" ]]; then
      _messageFAIL "==rmh== ** missing asset on release: $name"
      rc=1
    fi
  done

  if [[ $rc -ne 0 ]]; then
    _messageFAIL "==rmh== ** some assets were not uploaded successfully"
  else
    _messagePlain_probe "==rmh== all assets verified successfully"
  fi
  return "$rc"
}

# Single file uploader with real retries and status ---
_gh_release_upload_part-single_sequence() {
  _messagePlain_nominal '==rmh== _gh_release_upload: '"$1"' '"$2"
  local currentTag="$1"
  local currentFile="$2"

  local currentIteration=0
  local maxIterations=30
  local rc=1
  local assetName
  assetName=$(basename -- "$currentFile")

  while [[ "$currentIteration" -le "$maxIterations" ]]; do
    if "$scriptAbsoluteLocation" _stopwatch \
         _timeout_strict 600 \
         gh release upload --clobber "$currentTag" "$currentFile"
    then
      # Verify asset is visible (eventual consistency guard)
      local vtries=0
      while [[ $vtries -lt 5 ]]; do
        if _gh_release_asset_present "$currentTag" "$assetName"; then
          rc=0
          break
        fi
        sleep 2
        let vtries++
      done
      if [[ $rc -eq 0 ]]; then
        _messagePlain_probe "==rmh== uploaded ✓ $assetName"
        break
      else
        _messageWARN "==rmh== ** gh exited 0 but asset not listed yet; retrying: $assetName"
      fi
    else
      _messageWARN "==rmh== ** upload attempt $((currentIteration+1)) of $maxIterations failed: $assetName"
    fi
    sleep 7
    let currentIteration++
  done

  if [[ $rc -ne 0 ]]; then
    _messageFAIL "==rmh== ** upload failed after retries: $assetName → $currentTag"
  fi
  return "$rc"
}


