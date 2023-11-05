
# Requires "$GH_TOKEN" .
_gh_downloadURL() {
	local current_url
	local current_repo
	local current_tagName
	local current_file
	
	
	# ATTRIBUTION: ChatGPT GPT-4 2023-11-04 .
	
	# The provided URL
	current_url="$1"
	shift
	
	# Use `sed` to extract the parts of the URL
	current_repo=$(echo "$current_url" | sed -n 's|https://github.com/\([^/]*\)/\([^/]*\)/.*|\1/\2|p')
	current_tagName=$(echo "$current_url" | sed -n 's|https://github.com/[^/]*/[^/]*/releases/download/\([^/]*\)/.*|\1|p')
	current_file=$(echo "$current_url" | sed -n 's|https://github.com/[^/]*/[^/]*/releases/download/[^/]*/\(.*\)|\1|p')
	
	# Use variables to construct the gh release download command
	gh release download "$current_tagName" -R "$current_repo" -p "$current_file" "$@"
}



_wget_githubRelease-URL() {
	local currentURL
	if [[ "$2" != "" ]]
	then
		if [[ "$GH_TOKEN" == "" ]]
		then
			currentURL=$(curl -6 -s "https://api.github.com/repos/""$1""/releases" | jq -r ".[] | select(.name == \"""$2""\") | .assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1)
			[[ "$currentURL" == "" ]] && currentURL=$(curl -4 -s "https://api.github.com/repos/""$1""/releases" | jq -r ".[] | select(.name == \"""$2""\") | .assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1)
			echo "$currentURL"
			return
		else
			currentURL=$(curl -6 -H "Authorization: Bearer $GH_TOKEN" -s "https://api.github.com/repos/""$1""/releases" | jq -r ".[] | select(.name == \"""$2""\") | .assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1)
			[[ "$currentURL" == "" ]] && currentURL=$(curl -4 -H "Authorization: Bearer $GH_TOKEN" -s "https://api.github.com/repos/""$1""/releases" | jq -r ".[] | select(.name == \"""$2""\") | .assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1)
			echo "$currentURL"
			return
		fi
	else
		if [[ "$GH_TOKEN" == "" ]]
		then
			currentURL=$(curl -6 -s "https://api.github.com/repos/""$1""/releases/latest" | jq -r ".assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1)
			[[ "$currentURL" == "" ]] && currentURL=$(curl -4 -s "https://api.github.com/repos/""$1""/releases/latest" | jq -r ".assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1)
			echo "$currentURL"
			return
		else
			currentURL=$(curl -6 -H "Authorization: Bearer $GH_TOKEN" -s "https://api.github.com/repos/""$1""/releases/latest" | jq -r ".assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1)
			[[ "$currentURL" == "" ]] && currentURL=$(curl -4 -H "Authorization: Bearer $GH_TOKEN" -s "https://api.github.com/repos/""$1""/releases/latest" | jq -r ".assets[] | select(.name == \"""$3""\") | .browser_download_url" | sort -n -r | head -n 1)
			echo "$currentURL"
			return
		fi
	fi
}

_wget_githubRelease() {
	local currentURL=$(_wget_githubRelease-URL "$@")
	_messagePlain_probe curl -L -o "$3" "$currentURL" >&2
	curl -L -o "$3" "$currentURL"
	[[ ! -e "$3" ]] && _messagePlain_bad 'missing: '"$1"' '"$2"' '"$3" && return 1
	return 0
}

_wget_githubRelease-stdout() {
	local currentURL=$(_wget_githubRelease-URL "$@")
	_messagePlain_probe curl -L -o - "$currentURL" >&2
	curl -L -o - "$currentURL"
}


_wget_githubRelease_join-stdout() {
	local functionEntryPWD
	functionEntryPWD="$PWD"
	cd "$scriptAbsoluteFolder"
	
	local currentURL
	local currentURL_array

	local currentIteration
	currentIteration=0
	for currentIteration in $(seq -f "%02g" 0 32)
	do
		currentURL=$(_wget_githubRelease-URL "$1" "$2" "$3"".part""$currentIteration")
		[[ "$currentURL" == "" ]] && break
		[[ "$currentURL" != "" ]] && currentURL_array+=( "$currentURL" )
	done

	# https://unix.stackexchange.com/questions/412868/bash-reverse-an-array
	local currentValue
	for currentValue in "${currentURL_array[@]}"
	do
		currentURL_array_reversed=("$currentValue" "${currentURL_array_reversed[@]}")
	done
	
	# DANGER: Requires   ' "$MANDATORY_HASH" == true '   to indicate use of a hash obtained more securely to check download integrity. Do NOT set 'MANDATORY_HASH' explicitly, safe functions which already include appropriate checks for integrity will set this safety flag automatically.
	# CAUTION: Do NOT use unless reasonable to degrade network traffic collision backoff algorithms. Unusual defaults, very aggressive, intended for load-balanced multi-WAN with at least 3 WANs .
	if [[ "$FORCE_AXEL" != "" ]] && ( [[ "$MANDATORY_HASH" == "true" ]] )
	then
		#local currentAxelTmpFile
		#currentAxelTmpFile="$scriptAbsoluteFolder"/.m_axelTmp_$(_uid 14)
		export currentAxelTmpFileRelative=.m_axelTmp_$(_uid 14)
		export currentAxelTmpFile="$scriptAbsoluteFolder"/"$currentAxelTmpFileRelative"

		#local currentAxelPID

		local currentForceAxel
		currentForceAxel="$FORCE_AXEL"

		( [[ "$currentForceAxel" == "true" ]] || [[ "$currentForceAxel" == "" ]] ) && currentForceAxel="48"
		[[ "$currentForceAxel" -lt 2 ]] && currentForceAxel="2"

		currentForceAxel=$(bc <<< "$currentForceAxel""*0.5" | cut -f1 -d\. )
		[[ "$currentForceAxel" -lt 2 ]] && currentForceAxel="2"

		#_messagePlain_probe axel -a -n "$FORCE_AXEL" -o "$currentAxelTmpFile" "${currentURL_array_reversed[@]}" >&2
		#axel -a -n "$FORCE_AXEL" -o "$currentAxelTmpFile" "${currentURL_array_reversed[@]}" >&2 &
		#currentAxelPID="$!"


		local current_usable_ipv4
		current_usable_ipv4="false"
		#if _timeout 8 aria2c -o "$currentAxelTmpFile" --disable-ipv6 --allow-overwrite=true --auto-file-renaming=false --file-allocation=none --timeout=6 "${currentURL_array_reversed[0]}" >&2
		#then
			#current_usable_ipv4="true"
		#fi
		if [[ "$GH_TOKEN" == "" ]]
		then
			if _timeout 5 wget -4 -O - "${currentURL_array_reversed[0]}" > /dev/null
			then
				current_usable_ipv4="true"
			fi
		else
			if _timeout 5 wget -4 -O - --header="Authorization: Bearer $GH_TOKEN" "${currentURL_array_reversed[0]}" > /dev/null
			then
				current_usable_ipv4="true"
			fi
		fi

		local current_usable_ipv6
		current_usable_ipv6="false"
		if [[ "$GH_TOKEN" == "" ]]
		then
			if _timeout 5 wget -6 -O - "${currentURL_array_reversed[0]}" > /dev/null
			then
				current_usable_ipv6="true"
			fi
		else
			if _timeout 5 wget -6 -O - --header="Authorization: Bearer $GH_TOKEN" "${currentURL_array_reversed[0]}" > /dev/null
			then
				current_usable_ipv6="true"
			fi
		fi

		local currentPID_1
		local currentPID_2
		currentIteration=0
		local currentIterationNext1
		let currentIterationNext1=currentIteration+1
		rm -f "$currentAxelTmpFile"
		rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
		while [[ "${currentURL_array_reversed[$currentIteration]}" != "" ]] || [[ "${currentURL_array_reversed[$currentIterationNext1]}" != "" ]] || [[ -e "$currentAxelTmpFile".tmp2 ]]
		do
			#rm -f "$currentAxelTmpFile"
			rm -f "$currentAxelTmpFile".aria2
			rm -f "$currentAxelTmpFile".tmp
			rm -f "$currentAxelTmpFile".tmp.st
			rm -f "$currentAxelTmpFile".tmp.aria2
			rm -f "$currentAxelTmpFile".tmp1
			rm -f "$currentAxelTmpFile".tmp1.st
			rm -f "$currentAxelTmpFile".tmp1.aria2
			#rm -f "$currentAxelTmpFile".tmp2
			#rm -f "$currentAxelTmpFile".tmp2.st
			#rm -f "$currentAxelTmpFile".tmp2.aria2
			#rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
			
			#rm -f "$currentAxelTmpFile".* > /dev/null 2>&1

			# https://github.com/aria2/aria2/issues/1108

			if [[ "${currentURL_array_reversed[$currentIteration]}" != "" ]]
			then
				# Download preferring from IPv6 address .
				if [[ "$current_usable_ipv6" == "true" ]]
				then
					if [[ "$GH_TOKEN" == "" ]]
					then
						#--file-allocation=falloc
						_messagePlain_probe aria2c -x "$currentForceAxel" -o "$currentAxelTmpFileRelative".tmp1 --disable-ipv6=false "${currentURL_array_reversed[$currentIteration]}" >&2
						aria2c --log=- --log-level=info -x "$currentForceAxel" -o "$currentAxelTmpFileRelative".tmp1 --disable-ipv6=false "${currentURL_array_reversed[$currentIteration]}" | grep --color -i -E "Name resolution|$" >&2 &
						currentPID_1="$!"
					else
						_messagePlain_probe aria2c -x "$currentForceAxel" -o "$currentAxelTmpFileRelative".tmp1 --disable-ipv6=false --header="Authorization: Bearer "'$GH_TOKEN'"" "${currentURL_array_reversed[$currentIteration]}" >&2
						aria2c --log=- --log-level=info -x "$currentForceAxel" -o "$currentAxelTmpFileRelative".tmp1 --disable-ipv6=false --header="Authorization: Bearer $GH_TOKEN" "${currentURL_array_reversed[$currentIteration]}" | grep --color -i -E "Name resolution|$" >&2 &
						currentPID_1="$!"
					fi
				else
					if [[ "$GH_TOKEN" == "" ]]
					then
						_messagePlain_probe aria2c -x "$currentForceAxel" -o "$currentAxelTmpFileRelative".tmp1 --disable-ipv6=true "${currentURL_array_reversed[$currentIteration]}" >&2
						aria2c --log=- --log-level=info -x "$currentForceAxel" -o "$currentAxelTmpFileRelative".tmp1 --disable-ipv6=true "${currentURL_array_reversed[$currentIteration]}" | grep --color -i -E "Name resolution|$" >&2 &
						currentPID_1="$!"
					else
						_messagePlain_probe aria2c -x "$currentForceAxel" -o "$currentAxelTmpFileRelative".tmp1 --disable-ipv6=true --header="Authorization: Bearer "'$GH_TOKEN'"" "${currentURL_array_reversed[$currentIteration]}" >&2
						aria2c --log=- --log-level=info -x "$currentForceAxel" -o "$currentAxelTmpFileRelative".tmp1 --disable-ipv6=true --header="Authorization: Bearer $GH_TOKEN" "${currentURL_array_reversed[$currentIteration]}" | grep --color -i -E "Name resolution|$" >&2 &
						currentPID_1="$!"
					fi
				fi
			fi
			
			
			# CAUTION: ATTENTION: Very important. Simultaneous reading and writing is *very* important for writing directly to slow media (ie. BD-R) .
			#  NOTICE: Wirting directly to slow BD-R is essential for burning a Live disc from having booted a Live disc.
			#   DANGER: Critical for rapid recovery back to recent upstream 'ubdist/OS' ! Do NOT unnecessarily degrade this capability!
			#  Also theoretically helpful with especially fast network connections.
			#if [[ "$currentIteration" != "0" ]]
			if [[ -e "$currentAxelTmpFile".tmp2 ]]
			then
				# ATTENTION: Staggered.
				#sleep 10 > /dev/null 2>&1
				wait "$currentPID_2" >&2
				#wait >&2

				sleep 0.2 > /dev/null 2>&1
				if [[ -e "$currentAxelTmpFile".tmp2 ]]
				then
					_messagePlain_probe dd if="$currentAxelTmpFile".tmp2 bs=1M status=progress' >> '"$currentAxelTmpFile" >&2
					
					# ### dd if="$currentAxelTmpFile".tmp2 bs=5M status=progress >> "$currentAxelTmpFile"
					dd if="$currentAxelTmpFile".tmp2 bs=1M status=progress
					#cat "$currentAxelTmpFile".tmp2
					
					du -sh "$currentAxelTmpFile".tmp2 >> "$currentAxelTmpFile"
					
					#cat "$currentAxelTmpFile".tmp2 >> "$currentAxelTmpFile"
				fi
			else
				if [[ "$currentIteration" == "0" ]]
				then
					# ATTENTION: Staggered.
					#sleep 6 > /dev/null 2>&1
					true
				fi
			fi
			rm -f "$currentAxelTmpFile".tmp2
			rm -f "$currentAxelTmpFile".tmp2.st
			rm -f "$currentAxelTmpFile".tmp2.aria2
			#rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
			
			


			if [[ "${currentURL_array_reversed[$currentIterationNext1]}" != "" ]]
			then
				# Download preferring from IPv4 address.
				#--disable-ipv6
				if [[ "$current_usable_ipv4" == "true" ]]
				then
					if [[ "$GH_TOKEN" == "" ]]
					then
						_messagePlain_probe aria2c -x "$currentForceAxel" -o "$currentAxelTmpFileRelative".tmp2 --disable-ipv6=true "${currentURL_array_reversed[$currentIterationNext1]}" >&2
						aria2c --log=- --log-level=info -x "$currentForceAxel" -o "$currentAxelTmpFileRelative".tmp2 --disable-ipv6=true "${currentURL_array_reversed[$currentIterationNext1]}" | grep --color -i -E "Name resolution|$" >&2 &
						currentPID_2="$!"
					else
						_messagePlain_probe aria2c -x "$currentForceAxel" -o "$currentAxelTmpFileRelative".tmp2 --disable-ipv6=true --header="Authorization: Bearer "'$GH_TOKEN'"" "${currentURL_array_reversed[$currentIterationNext1]}" >&2
						aria2c --log=- --log-level=info -x "$currentForceAxel" -o "$currentAxelTmpFileRelative".tmp2 --disable-ipv6=true --header="Authorization: Bearer $GH_TOKEN" "${currentURL_array_reversed[$currentIterationNext1]}" | grep --color -i -E "Name resolution|$" >&2 &
						currentPID_2="$!"
					fi
				else
					if [[ "$GH_TOKEN" == "" ]]
					then
						_messagePlain_probe aria2c -x "$currentForceAxel" -o "$currentAxelTmpFileRelative".tmp2 --disable-ipv6=false "${currentURL_array_reversed[$currentIterationNext1]}" >&2
						aria2c --log=- --log-level=info -x "$currentForceAxel" -o "$currentAxelTmpFileRelative".tmp2 --disable-ipv6=false "${currentURL_array_reversed[$currentIterationNext1]}" | grep --color -i -E "Name resolution|$" >&2 &
						currentPID_2="$!"
					else
						_messagePlain_probe aria2c -x "$currentForceAxel" -o "$currentAxelTmpFileRelative".tmp2 --disable-ipv6=false --header="Authorization: Bearer "'$GH_TOKEN'"" "${currentURL_array_reversed[$currentIterationNext1]}" >&2
						aria2c --log=- --log-level=info -x "$currentForceAxel" -o "$currentAxelTmpFileRelative".tmp2 --disable-ipv6=false --header="Authorization: Bearer $GH_TOKEN" "${currentURL_array_reversed[$currentIterationNext1]}" | grep --color -i -E "Name resolution|$" >&2 &
						currentPID_2="$!"
					fi
				fi
			fi
			

			# ATTENTION: NOT staggered.
			#wait "$currentPID_1" >&2
			#wait "$currentPID_2" >&2
			#wait >&2
			
			if [[ "$currentIteration" == "0" ]]
			then
				wait "$currentPID_1" >&2
				sleep 6 > /dev/null 2>&1
				[[ "$currentPID_2" == "" ]] && sleep 35 > /dev/null 2>&1
				[[ "$currentPID_2" != "" ]] && wait "$currentPID_2" >&2
				wait >&2
			fi

			wait "$currentPID_1" >&2
			sleep 0.2 > /dev/null 2>&1
			if [[ -e "$currentAxelTmpFile".tmp1 ]]
			then
				_messagePlain_probe dd if="$currentAxelTmpFile".tmp1 bs=1M status=progress' >> '"$currentAxelTmpFile" >&2
				
				if [[ ! -e "$currentAxelTmpFile" ]]
				then
					# ### mv -f "$currentAxelTmpFile".tmp1 "$currentAxelTmpFile"
					dd if="$currentAxelTmpFile".tmp1 bs=1M status=progress
					
					du -sh "$currentAxelTmpFile".tmp1 >> "$currentAxelTmpFile"
				else
					# ATTENTION: Staggered.
					#dd if="$currentAxelTmpFile".tmp1 bs=1M status=progress >> "$currentAxelTmpFile" &
				
					# ATTENTION: NOT staggered.
					# ### dd if="$currentAxelTmpFile".tmp1 bs=5M status=progress >> "$currentAxelTmpFile"
					dd if="$currentAxelTmpFile".tmp1 bs=1M status=progress
					#cat "$currentAxelTmpFile".tmp1
					
					du -sh "$currentAxelTmpFile".tmp1 >> "$currentAxelTmpFile"
					
					#cat "$currentAxelTmpFile".tmp1 >> "$currentAxelTmpFile"
				fi
			fi

			let currentIteration=currentIteration+2
			let currentIterationNext1=currentIteration+1
		done
		

		#for currentValue in "${currentURL_array_reversed[@]}"
		#do
			#rm -f "$currentAxelTmpFile".tmp
			
			
			##_messagePlain_probe axel -a -n "$currentForceAxel" -o "$currentAxelTmpFile".tmp "$currentValue" >&2
			##axel -a -n "$currentForceAxel" -o "$currentAxelTmpFile".tmp "$currentValue" >&2
			#if [[ "$GH_TOKEN" == "" ]]
			#then
				#_messagePlain_probe axel -a -n "$currentForceAxel" -o "$currentAxelTmpFile".tmp "$currentValue" >&2
				#axel -a -n "$currentForceAxel" -o "$currentAxelTmpFile".tmp "$currentValue" >&2
			#else
				#_messagePlain_probe axel -a -n "$currentForceAxel" -H '"Authorization: Bearer $GH_TOKEN"' -o "$currentAxelTmpFile".tmp "$currentValue" >&2
				#axel -a -n "$currentForceAxel" -H "Authorization: Bearer $GH_TOKEN" -o "$currentAxelTmpFile".tmp "$currentValue" >&2
			#fi
			
			
			#_messagePlain_probe dd if="$currentAxelTmpFile".tmp bs=1M status=progress' >> '"$currentAxelTmpFile" >&2
			#dd if="$currentAxelTmpFile".tmp bs=1M status=progress >> "$currentAxelTmpFile"
			#let currentIteration=currentIteration+1
		#done

		#while [[ "$currentIteration" -le 16 ]] && [[ ! -e "$currentAxelTmpFile" ]]
		#do
			#sleep 2 > /dev/null 2>&1
			#let currentIteration="$currentIteration"+1
		#done

		#if [[ -e "$currentAxelTmpFile" ]]
		#then
			#tail --pid="$currentAxelPID" -c 100000000000 -f "$currentAxelTmpFile"
			#wait "$currentAxelPID"
		#else
			#_messagePlain_bad 'missing: "$currentAxelTmpFile"' >&2
			#kill -TERM "$currentAxelPID" > /dev/null 2>&1
			#kill -TERM "$currentAxelPID" > /dev/null 2>&1
			#sleep 3
			#kill -TERM "$currentAxelPID" > /dev/null 2>&1
			#sleep 3
			#kill -TERM "$currentAxelPID" > /dev/null 2>&1
			#kill -KILL "$currentAxelPID" > /dev/null 2>&1
			#return 1
		#fi

		if ! [[ -e "$currentAxelTmpFile" ]]
		then
			true
			# ### return 1
		fi

		# ### cat "$currentAxelTmpFile"

		rm -f "$currentAxelTmpFile"
		rm -f "$currentAxelTmpFile".aria2
		rm -f "$currentAxelTmpFile".tmp
		rm -f "$currentAxelTmpFile".tmp.st
		rm -f "$currentAxelTmpFile".tmp.aria2
		rm -f "$currentAxelTmpFile".tmp1
		rm -f "$currentAxelTmpFile".tmp1.st
		rm -f "$currentAxelTmpFile".tmp1.aria2
		rm -f "$currentAxelTmpFile".tmp2
		rm -f "$currentAxelTmpFile".tmp2.st
		rm -f "$currentAxelTmpFile".tmp2.aria2
		rm -f "$currentAxelTmpFile".tmp3
		rm -f "$currentAxelTmpFile".tmp3.st
		rm -f "$currentAxelTmpFile".tmp3.aria2
		rm -f "$currentAxelTmpFile".tmp4
		rm -f "$currentAxelTmpFile".tmp4.st
		rm -f "$currentAxelTmpFile".tmp4.aria2
			
		rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
		
		return 0
	else
		if [[ "$GH_TOKEN" == "" ]]
		then
			_messagePlain_probe curl -L "${currentURL_array_reversed[@]}" >&2
			curl -L "${currentURL_array_reversed[@]}"
		elif type -p gh > /dev/null 2>&1 && [[ "$GH_TOKEN" != "" ]] && [[ "$FORCE_WGET" != "true" ]]
		then
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			# ATTENTION: Follows structure based on functionality for 'aria2c' .
			
			#local currentAxelTmpFile
			#currentAxelTmpFile="$scriptAbsoluteFolder"/.m_axelTmp_$(_uid 14)
			export currentAxelTmpFileRelative=.m_axelTmp_$(_uid 14)
			export currentAxelTmpFile="$scriptAbsoluteFolder"/"$currentAxelTmpFileRelative"
			
			local currentPID_1
			local currentPID_2
			local currentPID_3
			local currentPID_4
			local currentIteration
			currentIteration=0
			local currentIterationNext1
			let currentIterationNext1=currentIteration+1
			local currentIterationNext2
			let currentIterationNext2=currentIteration+2
			local currentIterationNext3
			let currentIterationNext3=currentIteration+3
			rm -f "$currentAxelTmpFile"
			rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
			while [[ "${currentURL_array_reversed[$currentIteration]}" != "" ]] || [[ "${currentURL_array_reversed[$currentIterationNext1]}" != "" ]] || [[ -e "$currentAxelTmpFile".tmp2 ]] || [[ "${currentURL_array_reversed[$currentIterationNext2]}" != "" ]] || [[ -e "$currentAxelTmpFile".tmp3 ]] || [[ "${currentURL_array_reversed[$currentIterationNext3]}" != "" ]] || [[ -e "$currentAxelTmpFile".tmp4 ]]
			do
				#rm -f "$currentAxelTmpFile"
				rm -f "$currentAxelTmpFile".aria2 > /dev/null 2>&1
				rm -f "$currentAxelTmpFile".tmp > /dev/null 2>&1
				rm -f "$currentAxelTmpFile".tmp.st > /dev/null 2>&1
				rm -f "$currentAxelTmpFile".tmp.aria2 > /dev/null 2>&1
				rm -f "$currentAxelTmpFile".tmp1 > /dev/null 2>&1
				rm -f "$currentAxelTmpFile".tmp1.st > /dev/null 2>&1
				rm -f "$currentAxelTmpFile".tmp1.aria2 > /dev/null 2>&1
				#rm -f "$currentAxelTmpFile".tmp2 > /dev/null 2>&1
				#rm -f "$currentAxelTmpFile".tmp2.st > /dev/null 2>&1
				#rm -f "$currentAxelTmpFile".tmp2.aria2 > /dev/null 2>&1
				#rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
				
				#rm -f "$currentAxelTmpFile".* > /dev/null 2>&1

				# https://github.com/aria2/aria2/issues/1108

				if [[ "${currentURL_array_reversed[$currentIteration]}" != "" ]]
				then
					_messagePlain_probe _gh_downloadURL "${currentURL_array_reversed[$currentIteration]}" -O "$currentAxelTmpFileRelative".tmp1 >&2
					#"$scriptAbsoluteLocation"
					_gh_downloadURL "${currentURL_array_reversed[$currentIteration]}" -O "$currentAxelTmpFileRelative".tmp1 > /dev/null 2>&1 &
					currentPID_1="$!"
				fi
				
				
				# CAUTION: ATTENTION: Very important. Simultaneous reading and writing is *very* important for writing directly to slow media (ie. BD-R) .
				#  NOTICE: Wirting directly to slow BD-R is essential for burning a Live disc from having booted a Live disc.
				#   DANGER: Critical for rapid recovery back to recent upstream 'ubdist/OS' ! Do NOT unnecessarily degrade this capability!
				#  Also theoretically helpful with especially fast network connections.
				#if [[ "$currentIteration" != "0" ]]
				if [[ -e "$currentAxelTmpFile".tmp2 ]]
				then
					# ATTENTION: Staggered.
					#sleep 10 > /dev/null 2>&1
					wait "$currentPID_2" >&2
					[[ "$currentPID_2" != "" ]] && _pauseForProcess "$currentPID_2" >&2
					#wait >&2

					sleep 0.2 > /dev/null 2>&1
					if [[ -e "$currentAxelTmpFile".tmp2 ]]
					then
						_messagePlain_probe dd if="$currentAxelTmpFile".tmp2 bs=1M status=progress' >> '"$currentAxelTmpFile" >&2
						
						# ### dd if="$currentAxelTmpFile".tmp2 bs=5M status=progress >> "$currentAxelTmpFile"
						dd if="$currentAxelTmpFile".tmp2 bs=1M status=progress
						#cat "$currentAxelTmpFile".tmp2
						
						du -sh "$currentAxelTmpFile".tmp2 >> "$currentAxelTmpFile"
						
						#cat "$currentAxelTmpFile".tmp2 >> "$currentAxelTmpFile"
					fi
				else
					if [[ "$currentIteration" == "0" ]]
					then
						# ATTENTION: Staggered.
						#sleep 6 > /dev/null 2>&1
						true
					fi
				fi
				rm -f "$currentAxelTmpFile".tmp2 > /dev/null 2>&1
				rm -f "$currentAxelTmpFile".tmp2.st > /dev/null 2>&1
				rm -f "$currentAxelTmpFile".tmp2.aria2 > /dev/null 2>&1
				#rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
				
				
				if [[ -e "$currentAxelTmpFile".tmp3 ]]
				then
					# ATTENTION: Staggered.
					#sleep 10 > /dev/null 2>&1
					wait "$currentPID_3" >&2
					[[ "$currentPID_3" != "" ]] && _pauseForProcess "$currentPID_3" >&2
					#wait >&2

					sleep 0.2 > /dev/null 2>&1
					if [[ -e "$currentAxelTmpFile".tmp3 ]]
					then
						_messagePlain_probe dd if="$currentAxelTmpFile".tmp3 bs=1M status=progress' >> '"$currentAxelTmpFile" >&2
						
						# ### dd if="$currentAxelTmpFile".tmp3 bs=5M status=progress >> "$currentAxelTmpFile"
						dd if="$currentAxelTmpFile".tmp3 bs=1M status=progress
						#cat "$currentAxelTmpFile".tmp3
						
						du -sh "$currentAxelTmpFile".tmp3 >> "$currentAxelTmpFile"
						
						#cat "$currentAxelTmpFile".tmp3 >> "$currentAxelTmpFile"
					fi
				else
					if [[ "$currentIteration" == "0" ]]
					then
						# ATTENTION: Staggered.
						#sleep 6 > /dev/null 2>&1
						true
					fi
				fi
				rm -f "$currentAxelTmpFile".tmp3 > /dev/null 2>&1
				rm -f "$currentAxelTmpFile".tmp3.st > /dev/null 2>&1
				rm -f "$currentAxelTmpFile".tmp3.aria2 > /dev/null 2>&1
				#rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
				
				
				if [[ -e "$currentAxelTmpFile".tmp4 ]]
				then
					# ATTENTION: Staggered.
					#sleep 10 > /dev/null 2>&1
					wait "$currentPID_4" >&2
					[[ "$currentPID_4" != "" ]] && _pauseForProcess "$currentPID_4" >&2
					#wait >&2

					sleep 0.2 > /dev/null 2>&1
					if [[ -e "$currentAxelTmpFile".tmp4 ]]
					then
						_messagePlain_probe dd if="$currentAxelTmpFile".tmp4 bs=1M status=progress' >> '"$currentAxelTmpFile" >&2
						
						# ### dd if="$currentAxelTmpFile".tmp4 bs=5M status=progress >> "$currentAxelTmpFile"
						dd if="$currentAxelTmpFile".tmp4 bs=1M status=progress
						#cat "$currentAxelTmpFile".tmp4
						
						du -sh "$currentAxelTmpFile".tmp4 >> "$currentAxelTmpFile"
						
						#cat "$currentAxelTmpFile".tmp4 >> "$currentAxelTmpFile"
					fi
				else
					if [[ "$currentIteration" == "0" ]]
					then
						# ATTENTION: Staggered.
						#sleep 6 > /dev/null 2>&1
						true
					fi
				fi
				rm -f "$currentAxelTmpFile".tmp4 > /dev/null 2>&1
				rm -f "$currentAxelTmpFile".tmp4.st > /dev/null 2>&1
				rm -f "$currentAxelTmpFile".tmp4.aria2 > /dev/null 2>&1
				#rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
				
				
				


				if [[ "${currentURL_array_reversed[$currentIterationNext1]}" != "" ]]
				then
					_messagePlain_probe _gh_downloadURL "${currentURL_array_reversed[$currentIterationNext1]}" -O "$currentAxelTmpFileRelative".tmp2 >&2
					#"$scriptAbsoluteLocation" 
					_gh_downloadURL "${currentURL_array_reversed[$currentIterationNext1]}" -O "$currentAxelTmpFileRelative".tmp2 > /dev/null 2>&1 &
					currentPID_2="$!"
				fi
				
				if [[ "${currentURL_array_reversed[$currentIterationNext2]}" != "" ]]
				then
					_messagePlain_probe _gh_downloadURL "${currentURL_array_reversed[$currentIterationNext2]}" -O "$currentAxelTmpFileRelative".tmp3 >&2
					#"$scriptAbsoluteLocation" 
					_gh_downloadURL "${currentURL_array_reversed[$currentIterationNext2]}" -O "$currentAxelTmpFileRelative".tmp3 > /dev/null 2>&1 &
					currentPID_3="$!"
				fi
				
				if [[ "${currentURL_array_reversed[$currentIterationNext3]}" != "" ]]
				then
					_messagePlain_probe _gh_downloadURL "${currentURL_array_reversed[$currentIterationNext3]}" -O "$currentAxelTmpFileRelative".tmp4 >&2
					#"$scriptAbsoluteLocation" 
					_gh_downloadURL "${currentURL_array_reversed[$currentIterationNext3]}" -O "$currentAxelTmpFileRelative".tmp4 > /dev/null 2>&1 &
					currentPID_4="$!"
				fi
				

				# ATTENTION: NOT staggered.
				#wait "$currentPID_1" >&2
				#[[ "$currentPID_1" != "" ]] && _pauseForProcess "$currentPID_1" >&2
				#wait "$currentPID_2" >&2
				#[[ "$currentPID_2" != "" ]] && _pauseForProcess "$currentPID_2" >&2
				#wait "$currentPID_3" >&2
				#[[ "$currentPID_3" != "" ]] && _pauseForProcess "$currentPID_3" >&2
				#wait "$currentPID_4" >&2
				#[[ "$currentPID_4" != "" ]] && _pauseForProcess "$currentPID_4" >&2
				#wait >&2
				
				if [[ "$currentIteration" == "0" ]]
				then
					wait "$currentPID_1" >&2
					[[ "$currentPID_1" != "" ]] && _pauseForProcess "$currentPID_1" >&2
					sleep 6 > /dev/null 2>&1
					[[ "$currentPID_2" == "" ]] && sleep 35 > /dev/null 2>&1
					[[ "$currentPID_2" != "" ]] && wait "$currentPID_2" >&2
					[[ "$currentPID_2" != "" ]] && _pauseForProcess "$currentPID_2" >&2
					[[ "$currentPID_3" != "" ]] && wait "$currentPID_3" >&2
					[[ "$currentPID_3" != "" ]] && _pauseForProcess "$currentPID_3" >&2
					[[ "$currentPID_4" != "" ]] && wait "$currentPID_4" >&2
					[[ "$currentPID_4" != "" ]] && _pauseForProcess "$currentPID_4" >&2
					wait >&2
				fi

				wait "$currentPID_1" >&2
				[[ "$currentPID_1" != "" ]] && _pauseForProcess "$currentPID_4" >&2
				sleep 0.2 > /dev/null 2>&1
				if [[ -e "$currentAxelTmpFile".tmp1 ]]
				then
					_messagePlain_probe dd if="$currentAxelTmpFile".tmp1 bs=1M status=progress' >> '"$currentAxelTmpFile" >&2
					
					if [[ ! -e "$currentAxelTmpFile" ]]
					then
						# ### mv -f "$currentAxelTmpFile".tmp1 "$currentAxelTmpFile"
						dd if="$currentAxelTmpFile".tmp1 bs=1M status=progress
						
						du -sh "$currentAxelTmpFile".tmp1 >> "$currentAxelTmpFile"
					else
						# ATTENTION: Staggered.
						#dd if="$currentAxelTmpFile".tmp1 bs=1M status=progress >> "$currentAxelTmpFile" &
					
						# ATTENTION: NOT staggered.
						# ### dd if="$currentAxelTmpFile".tmp1 bs=5M status=progress >> "$currentAxelTmpFile"
						dd if="$currentAxelTmpFile".tmp1 bs=1M status=progress
						#cat "$currentAxelTmpFile".tmp1
						
						du -sh "$currentAxelTmpFile".tmp1 >> "$currentAxelTmpFile"
						
						#cat "$currentAxelTmpFile".tmp1 >> "$currentAxelTmpFile"
					fi
				fi

				let currentIteration=currentIteration+4
				let currentIterationNext1=currentIteration+1
				let currentIterationNext2=currentIteration+2
				let currentIterationNext3=currentIteration+3
			done

			if ! [[ -e "$currentAxelTmpFile" ]]
			then
				true
				# ### return 1
			fi

			# ### cat "$currentAxelTmpFile"

			rm -f "$currentAxelTmpFile"
			rm -f "$currentAxelTmpFile".aria2
			rm -f "$currentAxelTmpFile".tmp
			rm -f "$currentAxelTmpFile".tmp.st
			rm -f "$currentAxelTmpFile".tmp.aria2
			rm -f "$currentAxelTmpFile".tmp1
			rm -f "$currentAxelTmpFile".tmp1.st
			rm -f "$currentAxelTmpFile".tmp1.aria2
			rm -f "$currentAxelTmpFile".tmp2
			rm -f "$currentAxelTmpFile".tmp2.st
			rm -f "$currentAxelTmpFile".tmp2.aria2
			rm -f "$currentAxelTmpFile".tmp3
			rm -f "$currentAxelTmpFile".tmp3.st
			rm -f "$currentAxelTmpFile".tmp3.aria2
			rm -f "$currentAxelTmpFile".tmp4
			rm -f "$currentAxelTmpFile".tmp4.st
			rm -f "$currentAxelTmpFile".tmp4.aria2
			
			rm -f "$currentAxelTmpFile".* > /dev/null 2>&1
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		else
			_messagePlain_probe curl -H '"Authorization: Bearer $GH_TOKEN"' -L "${currentURL_array_reversed[@]}" >&2
			curl -H "Authorization: Bearer $GH_TOKEN" -L "${currentURL_array_reversed[@]}"
		fi
		return
	fi


	cd "$functionEntryPWD"
}

_wget_githubRelease_join() {
	local functionEntryPWD
	functionEntryPWD="$PWD"

	_messagePlain_probe _wget_githubRelease_join-stdout "$@" '>' "$3" >&2
	if [[ "$FORCE_AXEL" != "" ]]
	then
		_wget_githubRelease_join-stdout "$@" > "$3"
	else
		_wget_githubRelease_join-stdout "$@" > "$3"
	fi

	cd "$functionEntryPWD"
	[[ ! -e "$3" ]] && _messagePlain_bad 'missing: '"$1"' '"$2"' '"$3" && return 1

	cd "$functionEntryPWD"
	return 0
}


_wget_githubRelease_internal-URL() {
	_wget_githubRelease-URL "$1" "internal" "$2"
}

_wget_githubRelease_internal() {
	_wget_githubRelease "$1" "internal" "$2"
}




