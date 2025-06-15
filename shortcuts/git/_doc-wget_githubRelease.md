
`wget_githubRelease_internal.sh`

Functions used to fetch files from GitHub releases. Chooses any of several backends (wget/curl, axel/aria2c, gh), retries, prebuffers, ratelimits, parallelizes, as needed.

Reliably selects any of several backends (using curl, gh, wget, or aria2c/axel) and contains extensive retry logic and options.


`wget_githubRelease_tag.sh`

Functions to fetch files from the most recent of GitHub releases matching a tag/label (eg. fetching the latest GitHub release which has been tagged/labeled 'internal' and thus certified as sufficiently reviewed, tested, etc, for integration with other software). Also fetches and analyzes report files from GitHub releases (eg. to diff the list of files between builds as is necessary for 'ubcp' Cygwin).



# Files

```
./shortcuts/git/_doc-wget_githubRelease.md
```

```
./shortcuts/git/wget_githubRelease_internal.sh
./shortcuts/git/wget_githubRelease_tag.sh
```


# Functions

## ./shortcuts/git/wget_githubRelease_internal.sh

```
_wget_githubRelease
_wget_githubRelease-stdout
_wget_githubRelease_internal

_wget_githubRelease_join
_wget_githubRelease_join-stdout
```

| Function | Purpose / Role |
| --- | --- |
| `_wget_githubRelease` | Primary entry for downloading a release asset. It logs basic info and delegates to `_wget_githubRelease_procedure`. |
| `_wget_githubRelease-stdout` | Downloads an asset and ensures the final content is written to standard output, using a temporary file if needed. |
| `_wget_githubRelease_internal` | Convenience wrapper calling `_wget_githubRelease` with the release tag "internal." |
| `_wget_githubRelease_join` | Downloads multiple numbered parts of a large file and concatenates them into an output file. |
| `_wget_githubRelease_join-stdout` | Runs the join process and streams the combined data directly to stdout. |

## ./shortcuts/git/wget_githubRelease_tag.sh

```
_wget_githubRelease-fromTag-analysisReport-fetch
_wget_githubRelease-fromTag-analysisReport-select
_wget_githubRelease-fromTag-analysisReport-analysis
_wget_githubRelease-fromTag-analysisReport

_wget_githubRelease-fromTag-fetchReport

_wget_githubRelease-fromTag
_wget_githubRelease-fromTag-stdout

_wget_githubRelease-fromTag_join
_wget_githubRelease-fromTag_join-stdout
```

| Function | Purpose / Role |
| --- | --- |
| `_wget_githubRelease-fromTag-analysisReport-fetch` | Fetches one or more log/report files for a list of release tags into a temporary analysis directory. |
| `_wget_githubRelease-fromTag-analysisReport-select` | Selects the fetched report corresponding to `currentReleaseTag` for further processing. |
| `_wget_githubRelease-fromTag-analysisReport-analysis` | Compares report files across tags, generating "missing" output for differences. |
| `_wget_githubRelease-fromTag-analysisReport` | Orchestrates the above fetch, select and analysis steps, then removes the temporary directory. |
| `_wget_githubRelease-fromTag-fetchReport` | Downloads a single asset (report file) from a specific tag using the GitHub API. |
| `_curl_githubAPI_releases_fromTag_join-skip` | Quickly checks the GitHub API for multipart files, skipping missing parts to save API calls. |
| `_curl_githubAPI_releases_fromTag_join_procedure-skip` | Internal helper for the above skip logic; loops through release pages. |
| `_wget_githubRelease-address_fromTag` | Dispatches to `_wget_githubRelease-address_fromTag-curl` to retrieve the download URL from the API. |
| `_wget_githubRelease-URL_fromTag-curl` | Retrieves the user-facing URL for an asset at a given tag via curl. |
| `_wget_githubRelease-API_URL_fromTag-curl` | Retrieves the GitHub API download URL for an asset at a given tag. |
| `_wget_githubRelease-fromTag-stdout` | Streams an asset from a tag directly to stdout, managing temp files to detect errors. |
| `_wget_githubRelease-fromTag` | Main wrapper for downloading an asset by tag to a file; delegates to `_wget_githubRelease-fromTag_procedure`. |
| `_wget_githubRelease-fromTag_join` | Handles multi-part assets (e.g., `.part00`, `.part01`...) by invoking the join-sequence functions. |
| `_wget_githubRelease-fromTag_join-stdout` | Same as above but streaming to stdout. |
| `_wget_githubRelease-fromTag_join_sequence-stdout` | Sequentially outputs downloaded parts while coordinating with background workers. |
| `_wget_githubRelease-fromTag_join_sequence-parallel` | Launches parallel chunk downloads and manages inter-process coordination. |
| `_wget_githubRelease-fromTag_procedure-join` | Downloads a single part (`wget` call), marks success/failure, and cleans temporary markers. |
| `_wget_githubRelease_procedure-releasesTags-curl` | Retrieves a sorted list of recent tag names via GitHub's API. |
| `_wget_githubRelease-releasesTags-curl` / `_wget_githubRelease-releasesTags-gh` | Public-facing functions to fetch tag names via curl or the GitHub CLI. |
| `_wget_githubRelease-releasesTags` | Wrapper choosing between curl and gh implementations depending on environment. |



# Call Graph

## ./shortcuts/git/wget_githubRelease_internal.sh

### Simplified Call Graph
            
- `_wget_githubRelease_internal`
    - _`_wget_githubRelease`_

- `_wget_githubRelease`
    - _`_wget_githubRelease_procedure`_
        - `_wget_githubRelease_loop-curl`
            - `_wget_githubRelease_procedure-curl`
        - `_wget_githubRelease_loop-axel`
            - `_wget_githubRelease_procedure-axel`
        - `_gh_download`
        - `_wget_githubRelease_loop-curl` _(fallback)_
        
- `_wget_githubRelease-stdout`
    - `_wget_githubRelease_procedure-stdout`
        - _`_wget_githubRelease_procedure`_
            
- `_wget_githubRelease_join`
    - `_wget_githubRelease_join-stdout`
        - `_wget_githubRelease_join_sequence-stdout`
            - `_wget_githubRelease_join_sequence-parallel`
                - `_wget_githubRelease_procedure-join`
                    - _`_wget_githubRelease_procedure`_



# MultiThreading

## ./shortcuts/git/wget_githubRelease_internal.sh

All of the IPC in this script is accomplished by file-based markers (.busy, .PASS, .FAIL, .pid) combined with background subprocesses and simple sleep-polling loops, plus occasional process-substitution for stderr filtering.  No named FIFOs or kernel-level locks are used; instead the script relies on carefully ordered creation/removal of marker files and fixed delays ("latency margins") to avoid races.  This design trades off a bit of wall-time sleep for simpler, portable shell logic.

This script builds a mini asynchronous pipeline:
1. Producer: many background _procedure-join workers download sub-chunks to .busy files, then mark them PASS/FAIL.
2. Coordinator: the downloadLOOP in join_sequence-parallel staggers and monitors producer slots.
3. Consumer: the outputLOOP in _wget_githubRelease_procedure waits for chunks, dd-streams them to stdout, then signals the next chunk.
4. Cleanup: each producer and the coordinator spin-wait for the consumer to finish, then remove all markers.

Everything is glued together by the presence/absence of files (.busy, .PASS, .FAIL, .pid) and timed sleeps to ensure safe hand-off under varying OS/disk/network latencies.

### Function Naming

As the 'function-compatibility' hyphen vs 'function_capability' underscore naming convention implies.

| Function Name | Activity |
| --- | --- |
| `_wget_githubRelease_procedure-join` | `wget` `-` compatible with subsequent join |
| `_wget_githubRelease_join` | `wget` `_` joined multi-part file |

### Inter-Process-Communication Flow

| Loop/Activity | Function | Command
| --- | --- | --- |
| `outputLOOP` | `_wget_githubRelease-stdout` | `dd` |
| `downloadLOOP` | `_wget_githubRelease_join_sequence-parallel` | `_wget_githubRelease_procedure-join` |
| `wget` | `_wget_githubRelease_procedure-join` | `wget` |

| Function | Role/Description |
| --- | --- |
| `_wget_githubRelease-stdout` | Stream download to stdout, marking `PASS`/`FAIL` |
| `_wget_githubRelease_join_sequence-parallel` / `_wget_githubRelease_procedure-join` | Parallel producer/consumer logic to stitch chunks |

| Function/Section | IPC Mechanism | Files/Pipes | Conditions/Loops | Latency/Delay |
| --- | --- | --- | --- | --- |
| `_wget_githubRelease_join` -> `_wget_githubRelease_join_sequence-stdout` | Initializes download loop | Creates `.m_axelTmp_<stream>_<uid>` via `_axelTmp` | Loops over part numbers using `seq`; conditional skip/download decisions | None |
| Output loop in `_wget_githubRelease_join_sequence-stdout` | Waits for part completion | Checks `.busy`, `.PASS`, `.FAIL` files before reading part | `while` loop waiting until `.busy` cleared and PASS/FAIL present | `sleep 1` in loop; diagnostic wait after 15 iterations |
| Clean-up after each part | Removes temporary files | `_destroy_lock` on `.m_axelTmp*` artifacts | Sequential after file output | none |
| Parallel download start | Starts process, records PID | `.pid` file holds background process ID | Wait loops check `.busy` before reuse | `sleep 1` per iteration |
| Final wait & cleanup | Waits on all PIDs | `_pauseForProcess` invoked for each `.pid` file | `for` loop over streams | none |
| `_wget_githubRelease_procedure-join` | Creates `.busy` then downloads | Writes `.PASS` or `.FAIL` after completion; cleans when files disappear | `while` loop waiting for files to vanish before cleanup | `sleep 7` minimum delay after download |
| `_wget_githubRelease_loop-curl` | Retry logic for network fetch | No new files; depends on existing output path | `while` until success or max retries | `sleep $githubRelease_retriesWait` between retries |
| `_destroy_lock` utility | Repeated file deletion attempts | Handles `.busy`, `.PASS`, `.FAIL`, output files | `for` loop up to `currentLockWait` iterations | `sleep 1` between attempts, extra `sleep 7` after timeout |

### IPC Mechanisms

| Mechanism | Purpose |
|---|---|
| Background subprocesses (`&`)          | Launch chunk producers in parallel (producer/consumer split)                                                       |
| File-based locks (`_destroy_lock`)     | Ensure stale temp/lock files are removed before new operations                                                     |
| PASS/FAIL marker files (`.PASS` / `.FAIL`) | Signal chunk-write success or failure                                                                               |
| Busy marker files (`.busy`)            | Indicate in-progress chunk writes to coordinate reader loops                                                       |
| PID files (`.pid`)                     | Track producer PIDs so that consumers can wait or `_pauseForProcess`                                               |
| Process substitution (`2> >(tail...)`)   | Non-blocking filtering/truncating of stderr output                                                                 |
| Intermediate temp files (`.m_axelTmp_*`) | Buffer raw chunk data between producer and consumer loops                                                          |
| Sleep-based polling                    | Poll on marker files / PIDs at controlled intervals to avoid busy-loops                                            |

### IPC Files & Their Roles

| File / Pattern                               | Created by                                                       | Consumed by                       | Role                                                   |
|-----------------------------------------------|------------------------------------------------------------------|-----------------------------------|--------------------------------------------------------|
| `.m_axelTmp_<stream>_<uid>`                   | `_wget_githubRelease_procedure-...`, `_wget_githubRelease_procedure-join` | `dd`/`cat` in output/download loops | Staging area for raw chunk data                        |
| `.m_axelTmp_*.PASS`                           | Download procedure branches                                      | Output/download loops             | Signal: chunk completed successfully                   |
| `.m_axelTmp_*.FAIL`                           | Download procedure branches                                      | Output/download loops             | Signal: chunk encountered an error                     |
| `.m_axelTmp_*.busy`                           | `_wget_githubRelease_procedure-join`                             | Output/download loops             | Signal: chunk is actively being written                |
| `.m_axelTmp_*.pid`                            | Background launch in `join-sequence`                              | `_pauseForProcess` / `wait` loops | Communicate producer PID for proper synchronization    |
| `<currentOutFile>` lock (via `_destroy_lock`)  | Pre-download cleanup                                              | -                                 | Prevents collisions from stale output file             |

### IPC Conditions & Polling Loops

All coordination is done via spin-sleep loops that watch for the presence or absence of these files:

- `downloadLOOP` (join_sequence-parallel)
  - Wait for a free slot (`while file or file.busy exists; do sleep 1; done`)
  - Launch chunk
  - Wait for chunk to have begun (`while ! ls chunk*; do sleep 0.6; done`)
- `outputLOOP` (in _procedure)
  - Wait for `.busy` + (`.PASS` or .`FAIL`) to appear before streaming (`sleep 1` per iteration)
  - `dd if=...` to stdout
  - Delete the chunk files & markers
- procedure-join
  - Write `.busy`, do the download, write `.PASS`/`.FAIL`
  - Sleep a fixed 7 sec (minimum download time)
  - Wait until consumer has picked it up (sleep 1 per iteration)

| Loop Context                   | Condition(s)                                  | Sleep / Retry Interval | Purpose                                                 |
|--------------------------------|------------------------------------------------|------------------------|---------------------------------------------------------|
| Pre-buffer (join sequence)     | Until any chunk's `.PASS` or `.FAIL` exists    | 3 s                    | Ensure each stream has primed its temp file before output |
| OutputLOOP (join sequence)     | Wait for `.busy` AND (`.PASS` OR `.FAIL`)      | 1 s                    | Safely read complete chunk before `dd`/`cat`            |
| DownloadLOOP slot wait         | While temp file OR `.busy` exists              | 1 s                    | Avoid simultaneous writes into same slot                |
| DownloadLOOP stagger           | First chunk sleep 2 s; subsequent 6 s           | -                      | Stagger producers to reduce I/O bursts                  |
| DownloadLOOP IPC delay         | Fixed 7 s                                      | -                      | Minimum time for cleanup/marker files to propagate      |
| Procedure-join termination     | While any of temp/`.busy`/`.PASS`/`.FAIL` files exist | 1 s             | Wait for consumer to finish reading before cleanup      |

### Staggering

Staggering prevents both IPC, cleanup, etc, issues, as stated in comments, and also reduces simultaneous bandwidth/disk spikes.

Preventing such external reliability issues avoids retries, thus improving margins for any (eg. external) connection limits, time limits, etc.

### Operating-System Latency Margins

| Sleep call              | Length              | Reason                                               |
|-------------------------|---------------------|------------------------------------------------------|
| `In _procedure-join`    | `sleep 7`           | "minimum download time" handshake delay              |
| `In downloadLOOP`       | `sleep 6`/`2`/`sleep 7` | Stagger start and IPC delay so cleanup has finished  |
| `In prebuffer loop`     | `sleep 3`           | Polling interval for first-chunk readiness           |
| `In outputLOOP`         | `sleep 1`           | Polling interval for `PASS/FAIL` + `.busy` availability |
| `In downloadLOOP`       | `sleep 1`           | Polling interval before freeing up a stream slot     |
| `In downloadLOOP`       | `sleep 0.6`         | Polling interval for chunk-file creation post-launch |

### Resource-Locking and Collision Avoidance

- Unique chunk filenames (`.m_axelTmp_<stream>_<UID>`) avoid collisions between parallel streams.
- Stream indexing rotates between `currentStream_min...currentStream_max` to spread out parallel jobs.

| Aspect                   | Notes                                                                                  | Risk / Comment                                          |
|--------------------------|----------------------------------------------------------------------------------------|---------------------------------------------------------|
| Use of `_destroy_lock`   | Proactively removes stale lock/`busy`/`PASS`/`FAIL` files before starting a new download | Good hygiene, but relies on correct invocation timing   |
| File-based locks only    | No advisory `flock(1)` or kernel lock; simply removes marker files                    | Race if two processes launch at the same instant        |
| `PASS`/`FAIL` cleanup    | Explicit `_destroy_lock` after consumption                                             | If cleanup lags, consumer may spin waiting longer       |
| Partial `.aria2*` cleanup| Commented out in `axel-backend` code                                                   | Could leave behind partial part files under error paths |

### Potential Concurrency Collision Hazards

| Scenario                                           | Collision Risk                                 | Mitigation in Script                                    |
| -------------------------------------------------- | ---------------------------------------------- | -------------------------------------------------------- |
| Two streams attempting same temp slot concurrently | Overwrite or dropped chunks                    | `busy-marker loop` blocks slot until clear               |
| Producer cleanup racing with next download slot    | Consumer reads stale or missing file           | Fixed IPC delays (`sleep 7 s`) before slot reuse         |
| Stale PID file blocking new wait calls             | Consumer loop hangs waiting on nonexistent PID | Marker-based loops (`PASS`/`FAIL`/`busy`) as primary sync |
| Leftover `.aria2*` artifacts                       | Stale partial files blocking new runs          | (Commented) but not enforced in current code             |

| Hazard                            | Mitigation                                                               |
|-----------------------------------|--------------------------------------------------------------------------|
| Overlapping streams colliding     | Unique `fileUID` + stream index `mod N`                                  |
| Busy-wait hog CPU                 | Sleeps in loops reduce busy-spin                                         |
| Background jobs cluttering stdout | All diagnostic output redirected to `>/dev/null` / `>&2` tails            |


# Pseudocode Summary - (MultiThreaded)

## ./shortcuts/git/wget_githubRelease_internal.sh

```bash
( set -o pipefail ; aria2c --disable-ipv6=false "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL" 2> >(tail -n 40 >&2) )
currentExitStatus_ipv6="$?"
( set -o pipefail ; aria2c --disable-ipv6=true "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL" 2> >(tail -n 40 >&2) )
currentExitStatus_ipv4="$?"

outputLOOP:
	for currentPart in $(seq -f "%02g" 0 "$currentSkipPart" | sort -r)
		while WAIT && ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).busy ]] || ( ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]] && ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] )
		dd if="$scriptAbsoluteFolder"/$(_axelTmp) bs=1M
		[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]] && currentSkip="download"
		[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] && [[ "$currentSkip" != "skip" ]] && ( _messageError 'FAIL' >&2 ) > /dev/null && return 1
		_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp)
		_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).busy

downloadLOOP:
	while WAIT && ! ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp)* > /dev/null 2>&1 )
		_wget_githubRelease_procedure-join ... "$currentFile".part'##' &
	while WAIT && ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp) > /dev/null 2>&1 ) || ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp).busy > /dev/null 2>&1 )
		_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).PASS
		_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).FAIL

_wget_githubRelease_procedure-join:
	echo -n > "$currentAxelTmpFile".busy
	_wget_githubRelease_procedure "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" -O "$currentAxelTmpFile" "$@"
	[[ "$currentExitStatus" == "0" ]] && echo "$currentExitStatus" > "$currentAxelTmpFile".PASS
	if [[ "$currentExitStatus" != "0" ]]
	then
		echo -n > "$currentAxelTmpFile"
		echo "$currentExitStatus" > "$currentAxelTmpFile".FAIL
	fi
	while WAIT && [[ -e "$currentAxelTmpFile" ]] || [[ -e "$currentAxelTmpFile".busy ]] || [[ -e "$currentAxelTmpFile".PASS ]] || [[ -e "$currentAxelTmpFile".FAIL ]]
		[[ "$currentAxelTmpFile" != "" ]] && _destroy_lock "$currentAxelTmpFile".*

```




# Scrap

export FORCE_AXEL="3"
export FORCE_PARALLEL="5"

./ubiquitous_bash.sh _get_ingredientVM "spring"

./ubiquitous_bash.sh _wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "spring" "package_image.tar.flx" > _local/temp




# WARNING: NOT certified !

WARNING: This maintenance documentation has NOT been proven by sufficient use in practice. Incidents successfully using part or all of this documentation may be noted here until sufficient track record is established.

After sufficient track record has been established, this WARNING heading may be deleted, and a CERTIFICATION statement may be added.

