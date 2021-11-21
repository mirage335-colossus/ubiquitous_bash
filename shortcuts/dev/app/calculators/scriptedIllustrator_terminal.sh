
_set_markup_terminal() {
	
	#&& [[ "$flag__NOT_shell" == "" ]] && [[ "$comment_shell_line" == "" ]]
	if [[ "$current_scriptedIllustrator_markup" == "" ]] && [[ "$current_scriptedIllustrator_markup_markdown" == "" ]] && [[ "$workaround_noInterpret_begin" == "" ]] && [[ "$workaround_noInterpret_end" == "" ]] && [[ "$workaround_comment_shell_line" == "" ]]
	then
		
		export flag__NOT_shell='scriptedIllustrator_markup_uk4uPhB663kVcygT0q'
		export comment_shell_line='#'
		
		
		_e() {
			export currentFunctionName="${FUNCNAME[0]}"
			_e-terminal "$@"
		}
		#export -f _e
		
		_e_() {
			export currentFunctionName="${FUNCNAME[0]}"
			_e_-terminal "$@"
		}
		#export -f _e_
		
		_o() {
			export currentFunctionName="${FUNCNAME[0]}"
			_o-terminal "$@"
		}
		#export -f _o
		
		_o_() {
			export currentFunctionName="${FUNCNAME[0]}"
			_o_-terminal "$@"
		}
		#export -f _o_
		
		_i() {
			export currentFunctionName="${FUNCNAME[0]}"
			_i-terminal "$@"
		}
		#export -f _i
		
		_v() {
			export currentFunctionName="${FUNCNAME[0]}"
			_v-terminal "$@"
		}
		#export -f _v
		
		_t() {
			export currentFunctionName="${FUNCNAME[0]}"
			_t-terminal "$@"
		}
		#export -f _t
		
		_r() {
			export currentFunctionName="${FUNCNAME[0]}"
			_r-terminal "$@"
		}
		#export -f _r
		
		_() {
			export currentFunctionName="${FUNCNAME[0]}"
			_h-terminal "$@"
		}
		_h() {
			export currentFunctionName="${FUNCNAME[0]}"
			_h-terminal "$@"
		}
		#export -f _
		#export -f _h
		
		
		
		_heading1() {
			export currentFunctionName="${FUNCNAME[0]}"
			_heading1-terminal "$@"
		}
		#export -f _heading1
		_heading2() {
			export currentFunctionName="${FUNCNAME[0]}"
			_heading2-terminal "$@"
		}
		#export -f _heading2
		_heading3() {
			export currentFunctionName="${FUNCNAME[0]}"
			_heading3-terminal "$@"
		}
		#export -f _heading3
		_heading4() {
			export currentFunctionName="${FUNCNAME[0]}"
			_heading4-terminal "$@"
		}
		#export -f _heading4
		_heading5() {
			export currentFunctionName="${FUNCNAME[0]}"
			_heading5-terminal "$@"
		}
		#export -f _heading5
		_heading6() {
			export currentFunctionName="${FUNCNAME[0]}"
			_heading6-terminal "$@"
		}
		#export -f _heading6
		
		_page() {
			export currentFunctionName="${FUNCNAME[0]}"
			_page-terminal "$@"
		}
		#export -f _page
		
		_paragraph_begin() {
			export currentFunctionName="${FUNCNAME[0]}"
			_paragraph_begin-terminal "$@"
		}
		#export -f _paragraph_begin
		_paragraph_end() {
			export currentFunctionName="${FUNCNAME[0]}"
			_paragraph_end-terminal "$@"
		}
		#export -f _paragraph_end
		
		
		_picture() {
			export currentFunctionName="${FUNCNAME[0]}"
			_picture-terminal "$@"
		}
		#export -f _picture
		_image() {
			export currentFunctionName="${FUNCNAME[0]}"
			_image-terminal "$@"
		}
		#export -f _image
		
		
		_cells_begin() {
			export currentFunctionName="${FUNCNAME[0]}"
			_cells_begin-terminal "$@"
		}
		#export -f _cells_begin
		_cells_end() {
			export currentFunctionName="${FUNCNAME[0]}"
			_cells_end-terminal "$@"
		}
		#export -f _cells_end
		_cells_row_begin() {
			export currentFunctionName="${FUNCNAME[0]}"
			_cells_row_begin-terminal "$@"
		}
		#export -f _cells_row_begin
		_cells_row_end() {
			export currentFunctionName="${FUNCNAME[0]}"
			_cells_row_end-terminal "$@"
		}
		#export -f _cells_row_end
		_cells_speck_begin() {
			export currentFunctionName="${FUNCNAME[0]}"
			_cells_speck_begin-terminal "$@"
		}
		#export -f _cells_speck_begin
		_cells_speck_end() {
			export currentFunctionName="${FUNCNAME[0]}"
			_cells_speck_end-terminal "$@"
		}
		#export -f _cells_speck_end
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
		
		# Echo command with commented (shell prepending '#' ) output.
		_e-terminal() {
			#_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			#_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			#echo "$markup_terminal_cmd_begin"
			
			_messagePlain_probe_quoteAddSingle "$@" | cat
			"$@" | _shellCommentLines | cat
			
			#echo "$markup_terminal_cmd_begin"
			#echo "$interpret__terminal_NOT_shell__end"
		}
		
		_e_-terminal() {
			#_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			#_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			#echo "$markup_terminal_cmd_begin"
			
			local current_miniSessionID=$(_uid 8)
			
			_messagePlain_probe_quoteAddSingle "$@" | cat
			
			eval "$@" > "$bootTmp"/"$current_miniSessionID"."${ubiquitousBashIDnano:0:3}"
			cat "$bootTmp"/"$current_miniSessionID"."${ubiquitousBashIDnano:0:3}" | _shellCommentLines | cat
			rm -f "$bootTmp"/"$current_miniSessionID"."${ubiquitousBashIDnano:0:3}" > /dev/null 2>&1
			
			#echo "$markup_terminal_cmd_begin"
			#echo "$interpret__terminal_NOT_shell__end"
		}
		
		# Output only. Useful for '_messagePlain_probe_var', _messagePlain_request' and similar.
		_o-terminal() {
			#_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			#_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			#echo "$markup_terminal_cmd_begin"
			
			local current_miniSessionID=$(_uid 8)
			
			#_messagePlain_probe_quoteAddSingle "$@" | cat
			
			
			# | _shellCommentLines
			
			"$@" | _workaround_preformattedCharacters-terminal | cat
			
			#echo "$markup_terminal_cmd_begin"
			#echo "$interpret__terminal_NOT_shell__end"
		}
		
		# Output only. Useful for '_messagePlain_probe_var', _messagePlain_request' and similar.
		_o_-terminal() {
			#_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			#_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			#echo "$markup_terminal_cmd_begin"
			
			local current_miniSessionID=$(_uid 8)
			
			#_messagePlain_probe_quoteAddSingle "$@" | cat
			
			
			# | _shellCommentLines
			
			eval "$@" > "$bootTmp"/"$current_miniSessionID"."${ubiquitousBashIDnano:0:3}"
			cat "$bootTmp"/"$current_miniSessionID"."${ubiquitousBashIDnano:0:3}" | _workaround_preformattedCharacters-terminal | cat
			rm -f "$bootTmp"/"$current_miniSessionID"."${ubiquitousBashIDnano:0:3}" > /dev/null 2>&1
			
			#echo "$markup_terminal_cmd_begin"
			#echo "$interpret__terminal_NOT_shell__end"
		}
		
		# Internal. Use for variables, equation solving, etc.
		_i-terminal() {
			#_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			#_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			##echo "$markup_terminal_cmd_begin"
			
			#_messagePlain_probe_quoteAddSingle "$@" | cat
			
			eval "$@" > /dev/null 2>&1
			
			##echo "$markup_terminal_cmd_begin"
			#echo "$interpret__terminal_NOT_shell__end"
		}
		
		# Useful to read out a variable (ie. set from 'COLLECT') as preformatted text.
		# Variable. Roughly equivalent to '_messagePlain_probe_var' , however, without any declaration of the variable name .
		# https://stackoverflow.com/questions/11386586/how-to-show-div-tag-literally-in-code-pre-tag
		# 	'You can't (in modern HTML) write markup and have it be interpreted as text.'
		_v-terminal() {
			#_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			#_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			#echo "$markup_terminal_pre_begin"
			
			local current_miniSessionID=$(_uid 8)
			
			#_messagePlain_probe_quoteAddSingle "$@" | cat
			
			eval echo -e \$"$1" > "$bootTmp"/"$current_miniSessionID"."${ubiquitousBashIDnano:0:3}"
			cat "$bootTmp"/"$current_miniSessionID"."${ubiquitousBashIDnano:0:3}" | _fold-terminal | cat
			rm -f "$bootTmp"/"$current_miniSessionID"."${ubiquitousBashIDnano:0:3}" > /dev/null 2>&1
			
			#echo "$markup_terminal_pre_end"
			#echo "$interpret__terminal_NOT_shell__end"
		}
		
		
		
		
		
		# Show preformatted text.
		_t-terminal() {
			# No parameters (no input) is meaningless and nothing can be done with that.
			[[ "$1" == "" ]] && return 0
			
			#_t-terminal #_safeEcho_newline _t "'"
			_safeEcho _t "'"
			#echo -n "$flag__NOT_shell $comment_terminal_end""$markup_terminal_pre_begin"
			
			
			local currentLine
			local currentLine_previous
			local currentIteration
			currentIteration=0
			while read -r currentLine && [[ "$currentIteration" -lt 2 ]]
			do
				if [[ "$currentIteration" == 1 ]] && _safeEcho_newline "$currentLine" | _filter__scriptedIllustrator_markup > /dev/null 2>&1 && [[ "$currentLine_previous" != "" ]] && [[ "$currentLine" != "" ]]
				then
					_safeEcho_newline
					true
				fi
				
				currentLine_previous="$currentLine"
				let currentIteration=currentIteration+1
			done <<<$(_safeEcho "$@")
			[[ "$currentIteration" == 1 ]] && [[ "$currentLine_previous" != "" ]] && _safeEcho_newline
			
			#sed 's/^mediawiki_noLineBreak --><pre.*>//'
			_safeEcho "$@" | sed 's/^mediawiki_noLineBreak --><nowiki>//' | sed 's/^mediawiki_noLineBreak --><pre style="margin-top: 0px;margin-bottom: 0px;white-space: pre-wrap;">//' | _filter__scriptedIllustrator_markup | _fold-terminal | _workaround_preformattedCharacters-terminal
			
			#echo "$markup_terminal_pre_end""$comment_terminal_begin $flag__NOT_shell"
			_safeEcho_newline "'"
		}
		
		
		# Raw. Experimental. No production use.
		_r-terminal() {
			# No parameters (no input) is meaningless and nothing can be done with that.
			[[ "$1" == "" ]] && return 0
			
			#_t-terminal #_safeEcho_newline _r "'"
			_safeEcho _r "'"
			echo -n "$flag__NOT_shell $comment_terminal_end"
			
			
			local currentLine
			local currentLine_previous
			local currentIteration
			currentIteration=0
			while read -r currentLine && [[ "$currentIteration" -lt 2 ]]
			do
				if [[ "$currentIteration" == 1 ]] && _safeEcho_newline "$currentLine" | _filter__scriptedIllustrator_markup > /dev/null 2>&1 && [[ "$currentLine_previous" != "" ]]
				then
					_safeEcho_newline
				fi
				
				currentLine_previous="$currentLine"
				let currentIteration=currentIteration+1
			done <<<$(_safeEcho "$@")
			[[ "$currentIteration" == 1 ]] && _safeEcho_newline
			
			_safeEcho "$@" | sed 's/^mediawiki_noLineBreak -->//' | _filter__scriptedIllustrator_markup | _workaround_preformattedCharacters-terminal
			
			
			echo "$comment_terminal_begin $flag__NOT_shell"
			_safeEcho_newline "'"
		}
		
		# Hidden. Use for comments and (shell code only) spacing.
		_h-terminal() {
			true
			#_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			#_safeEcho_newline
		}
		
		
		
		
		
		
		
		_heading1-terminal() {
			#_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			#_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			
			_safeEcho_newline '_ '"$@"' _' | cat
			
			#echo "$interpret__terminal_NOT_shell__end"
		}
		_heading2-terminal() {
			#_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			#_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			
			_safeEcho_newline '__ '"$@"' __' | cat
			
			#echo "$interpret__terminal_NOT_shell__end"
		}
		_heading3-terminal() {
			#_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			#_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			
			_safeEcho_newline '___ '"$@"' ___' | cat
			
			#echo "$interpret__terminal_NOT_shell__end"
		}
		_heading4-terminal() {
			#_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			#_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			
			_safeEcho_newline '____ '"$@"' ____' | cat
			
			#echo "$interpret__terminal_NOT_shell__end"
		}
		_heading5-terminal() {
			#_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			#_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			
			_safeEcho_newline '_____ '"$@"' _____' | cat
			
			#echo "$interpret__terminal_NOT_shell__end"
		}
		_heading6-terminal() {
			#_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			#_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			
			_safeEcho_newline '______ '"$@"' ______' | cat
			
			#echo "$interpret__terminal_NOT_shell__end"
		}
		
		# Page break.
		#title page (experiment)
		#<div style="page-break-before: always;"> </div>
		#<p>
		#text page (experiment)
		#</p>
		_page-terminal() {
			_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			
			_safeEcho_newline 'PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak -H-H-H-H- PageBreak
		' | cat
			
			#_safeEcho_newline '<p style="page-break-after: always;">&nbsp;</p>' | cat
			#_safeEcho_newline '<p style="page-break-before: always;">&nbsp;</p>' | cat
			
			#_safeEcho_newline '<p style="page-break-after: always;">&nbsp;</p><p style="page-break-before: always;">&nbsp;</p>' | cat
			
			#_safeEcho_newline '<div style="page-break-after: always;"> </div>' | cat
			#_safeEcho_newline '<div></div>' | cat
			
			#echo "$interpret__terminal_NOT_shell__end"
		}
		
		_paragraph_begin-terminal() {
			#_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			#_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			
			_safeEcho_newline '' | cat
			#_safeEcho_newline '<p style="margin: 0;padding: 0; border-width: 0px;">' | cat
			
			#echo "$interpret__terminal_NOT_shell__end"
		}
		_paragraph_end-terminal() {
			#_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			#_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			
			_safeEcho_newline '' | cat
			
			#echo "$interpret__terminal_NOT_shell__end"
		}
		
		_picture-terminal() {
			local currentWidth
			currentWidth=""
			[[ "$2" != "" ]] && currentWidth="$2"
			
			local currentWidthParameter
			currentWidthParameter=""
			[[ "$currentWidth" != "" ]] && currentWidthParameter='width="'"$currentWidth"'" '
			
			_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			
			#./
			#https://www.hostpapa.com/knowledgebase/align-float-images-website/
			#_safeEcho_newline '<img '"$currentWidthParameter"'src="'"$1"'" style="float: right;margin: 0 0 0 15px;border: 5px solid transparent;">' | cat
			
			#echo "$interpret__terminal_NOT_shell__end"
		}
		_image-terminal() {
			local currentWidth
			currentWidth="96%"
			[[ "$2" != "" ]] && currentWidth="$2"
			
			local currentWidthParameter
			currentWidthParameter=""
			[[ "$currentWidth" != "" ]] && currentWidthParameter='width="'"$currentWidth"'" '
			
			_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			
			#./
			#_safeEcho_newline '<img '"$currentWidthParameter"'src="'"$1"'" style="margin: 0 0 0 15px;border: 5px solid transparent;">' | cat
			
			#echo "$interpret__terminal_NOT_shell__end"
		}
		
		
		
		_cells_begin-terminal() {
			local currentWidth
			currentWidth="0%"
			[[ "$1" != "" ]] && currentWidth="$1"
			
			local currentWidthParameter
			currentWidthParameter=""
			[[ "$currentWidth" != "" ]] && currentWidthParameter='width="'"$currentWidth"'" '
			
			_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			
			#_safeEcho_newline '<table '"$currentWidthParameter"'style="empty-cells: show; border-spacing: 0px; border: 1px solid black; margin-top: 0px; vertical-align: top;">' | cat
			
			#echo "$interpret__terminal_NOT_shell__end"
		}
		_cells_end-terminal() {
			_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			
			#_safeEcho_newline '</table>' | cat
			
			#echo "$interpret__terminal_NOT_shell__end"
		}
		_cells_row_begin-terminal() {
			_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			
			#_safeEcho_newline '<tr>' | cat
			
			#echo "$interpret__terminal_NOT_shell__end"
		}
		_cells_row_end-terminal() {
			_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			
			#_safeEcho_newline '</tr>' | cat
			
			#echo "$interpret__terminal_NOT_shell__end"
		}
		_cells_speck_begin-terminal() {
			local currentWidth
			currentWidth="0%"
			[[ "$1" != "" ]] && currentWidth="$1"
			
			local currentWidthParameter
			currentWidthParameter=""
			[[ "$currentWidth" != "" ]] && currentWidthParameter='width="'"$currentWidth"'" '
			
			
			local currentColspan
			currentColspan="1"
			[[ "$2" != "" ]] && currentColspan="$2"
			
			local currentColspanParameter
			currentColspanParameter=""
			[[ "$currentColspan" != "" ]] && currentColspanParameter='colspan="'"$currentColspan"'" '
			
			
			_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			
			#_safeEcho_newline '<td '"$currentWidthParameter"''"$currentColspanParameter"'style="border-spacing: 0px; border: 1px solid black; margin-top: 0px; vertical-align: top;">' | cat
			
			#echo "$interpret__terminal_NOT_shell__end"
		}
		_cells_speck_end-terminal() {
			_safeEcho_quoteAddSingle "$currentFunctionName" "$@"
			_safeEcho_newline
			
			
			#echo "$interpret__terminal_NOT_shell__begin"
			
			#_safeEcho_newline '</td>' | cat
			
			#echo "$interpret__terminal_NOT_shell__end"
		}
		
		
		
		
		
		_fold-terminal() {
			#if [[ "$markup_terminal_fold" != "" ]]
			#then
				#fold -w "$markup_terminal_fold" -s
				#return
			#fi
			cat
		}
		
		
		
		_workaround_preformattedCharacters-terminal() {
			#sed 's/\&#35;/#/g'
			#sed 's/\&#35;/#/g' | sed "s/\\\x27/\&#39;/g" | sed "s/\\\047/\&#39;/g" | sed "s/%27/\&#39;/g" | sed "s/\&#39;/\&#39;/g"
			
			#sed "s/\\\x27/\&#39;/g" | sed "s/\\\047/\&#39;/g" | sed "s/%27/\&#39;/g" | sed "s/\&#39;/\&#39;/g"
			#sed "s/\\\x3c/\&lt;;/g" | sed "s/\\\060/\&lt;;/g" | sed "s/%3c/\&lt;;/g" | sed "s/\&lt;;/\&lt;;/g"
			
			#sed 's/\&#35;/#/g' | sed "s/\\\x27/\&#39;/g" | sed "s/\\\047/\&#39;/g" | sed "s/%27/\&#39;/g" | sed "s/\&#39;/\&#39;/g" | sed "s/\\\x3c/\&lt;;/g" | sed "s/\\\060/\&lt;;/g" | sed "s/%3c/\&lt;;/g" | sed "s/\&lt;;/\&lt;;/g"
			
			cat
			
			
			#| sed "s/\&#92;/\\\/"
		}
		
		_shellCommentLines() {
			local currentString
			
			while read -r currentString
			do
				[ "$currentString" ] && printf '%b' "$comment_shell_line $currentString"
				echo
			done
			
			#echo -n "$comment_shell_line"' '
			##LANG=C IFS=
			#while LANG=C IFS= read -r -d '' -n 1 currentString
			#do
				#[ "$currentString" ] && printf '%b' "$currentString"
				#[[ "$currentString" == $'\n' ]] && echo -n "$comment_shell_line"' '
			#done
		}
		
		# WARNING: Affects accurate prevention of '_r' and '_t' inaccurately accumulating or removing newlines.
		_filter__scriptedIllustrator_markup() {
			# Inherently add newline if not already present.
			grep -v "$flag__NOT_shell"
			
			# Add newline if already present.
			#grep -v $(_uid) | grep -v "$flag__NOT_shell"
			
			# Do not add newline if not already present.
			#sed 's/^.*'"$flag__NOT_shell"'.*$//g'
		}
		
		
		
		
		_markup_asciidoc_disable_begin() {
			false
		}
		_markup_asciidoc_disable_end() {
			false
		}
		
	fi
	
}
_set_markup_terminal


_set_markup_terminal_exportFunctions() {
	_set_markup_terminal "$@"
	
	export -f _e
	
	export -f _e_
	
	export -f _o
	
	export -f _o_
	
	export -f _i
	
	export -f _v
	
	export -f _t
	
	export -f _r
	
	export -f _
	export -f _h
	
	
	
	export -f _heading1
	export -f _heading2
	export -f _heading3
	export -f _heading4
	export -f _heading5
	export -f _heading6
	
	export -f _page
	
	export -f _paragraph_begin
	export -f _paragraph_end
	
	
	export -f _picture
	export -f _image
	
	
	export -f _cells_begin
	export -f _cells_end
	export -f _cells_row_begin
	export -f _cells_row_end
	export -f _cells_speck_begin
	export -f _cells_speck_end
}


