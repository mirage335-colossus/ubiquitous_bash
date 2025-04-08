
#export distill_projectDir=$(_getAbsoluteLocation ./_local/experiment) ; export distill_distillDir=$(_getAbsoluteLocation ./_local/experiment_distill) ; mkdir -p ./_local/experiment ; cp -f ./generic/findInfrastructure.sh ./_local/experiment/ ; ./ubiquitous_bash.sh _semanticAssist ./_local/experiment

#export distill_projectDir=$(_getAbsoluteLocation ./_local/experiment) ; export distill_distillDir=$(_getAbsoluteLocation ./_local/experiment_distill) ; mkdir -p ./_local/experiment ; cp -f ./os/override/override_cygwin.sh ./_local/experiment/ ; ./ubiquitous_bash.sh _semanticAssist ./_local/experiment

#export distill_projectDir=$(_getAbsoluteLocation ./_local/experiment) ; export distill_distillDir=$(_getAbsoluteLocation ./_local/experiment_distill) ; mkdir -p ./_local/experiment ; cp -f ./metaengine/typical/typical_metaengine_buffer.sh ./_local/experiment/ ; ./ubiquitous_bash.sh _semanticAssist ./_local/experiment

_semanticAssist_bash_procedure() {
    [[ "$1" == "" ]] && return 0
    [[ ! -e "$1" ]] && return 0
    local inputName=$(basename "$1")
    local currentFileID=$(_uid)

    # Enable during development to re-generate the semanticAssist comments for the same files repeatedly.
    ( _messagePlain_nominal 'filter: '"$1" >&2 ) > /dev/null
    cat "$1" | grep -v '########## semanticAssist:' > "$safeTmp"/"$inputName"-"$currentFileID".filtered.txt
    mv -f "$safeTmp"/"$inputName"-"$currentFileID".filtered.txt "$1" > /dev/null


    if cat "$1" | grep '########## semanticAssist:' > /dev/null 2>&1
    then
        ( _messagePlain_nominal 'skip: '"$1" >&2 ) > /dev/null
        return 0
    fi


    ( _messagePlain_nominal 'boundaries: '"$1" >&2 ) > /dev/null
    export corpus_script=$(_getAbsoluteLocation "$1")
    _dataset_bash_from_lines "$1"


    ( _messagePlain_nominal 'description: '"$1" >&2 ) > /dev/null
    rm -f "$safeTmp"/"$inputName"-"$currentFileID".description.txt > /dev/null 2>&1
    rm -f "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt > /dev/null 2>&1
    rm -f "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt > /dev/null 2>&1
    _here_semanticAssist-askDescription >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
    echo '```bash' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
    cat "$1" >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
    echo '```' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
    echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
    _distill_semanticAssist "$1" .description_prompt.md "$distill_projectDir" "$distill_distillDir" "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
    _semanticAssist_loop "$1"
    cat "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt >> "$safeTmp"/"$inputName"-"$currentFileID".description.txt
    _distill_semanticAssist "$1" .description_response.md "$distill_projectDir" "$distill_distillDir" "$safeTmp"/"$inputName"-"$currentFileID".description.txt


    ( _messagePlain_nominal 'keywords-function-iteration: '"$1" >&2 ) > /dev/null
    rm -f "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh > /dev/null 2>&1
    local currentIteration=-1
    local currentIterationNext=0
    local currentIterationNextNext=1
    local currentLineBegin
    local currentLineEnd
    local currentLineBegin_next
    local currentLineEnd_next
    local currentGibberish
    local currentIteration_gibberish
    if [[ "${current_dataset_functionBounds[0]}" == "1" ]] # Skip iterating over 'currentLineBegin=1' case if the next iteration will also begin at 'currentLineBegin=1'.
    then
        let currentIteration++
        let currentIterationNext++
        let currentIterationNextNext++
    fi
    while ( [[ "$currentIteration" == "-1" ]] ) || ( [[ ${current_dataset_functionBounds[$currentIteration]} -lt "$current_dataset_totalLines" ]] && [[ "$currentIteration" -lt 30000 ]] && [[ ${current_dataset_functionBounds[$currentIteration]} != "" ]] ) # ( [[ "${current_dataset_functionBounds[0]}" == "1" ]] && [[ "$currentIteration" == 0 ]] )
    do
        currentLineBegin=$(( ${current_dataset_functionBounds[$currentIteration]} ))
        [[ "$currentIteration" -lt 0 ]] && currentLineBegin=1

        currentLineEnd=$(( ${current_dataset_functionBounds[$currentIterationNext]} - 1 ))
        ! [[ ${current_dataset_functionBounds[$currentIterationNext]} -lt "$current_dataset_totalLines" ]] && currentLineEnd="$current_dataset_totalLines"
        
        currentGibberish=""
        currentIteration_gibberish=0
        while [[ "$currentGibberish" != "valid" ]]
        do
            currentGibberish=""
            rm -f "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt > /dev/null 2>&1
            rm -f "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt > /dev/null 2>&1
            rm -f "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt > /dev/null 2>&1
            
            #echo '```description' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            cat "$safeTmp"/"$inputName"-"$currentFileID".description.txt >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            #echo '```' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            
            _here_semanticAssist-askKeywords >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            
            echo '```bash' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            sed -n "${currentLineBegin},${currentLineEnd}p" "$1" >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            echo '```' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            _distill_semanticAssist "$1" .keywords"$currentIterationNext"_functionLine"$currentLineBegin"_prompt.md "$distill_projectDir" "$distill_distillDir" "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            _semanticAssist_loop "$1" "_semanticAssist_bash-backend-lowLatency"
            cat "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt | tr ':\n\,;' '\ \ \ \ ' | tr -dc 'a-zA-Z0-9\-_\ ' | _filter_semanticAssist_nuisance | head -c 2500 > "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt

            [[ $(cat "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt | wc -c | tr -dc '0-9') -lt 7 ]] && currentGibberish="deficient"

            if [[ "$currentGibberish" != "deficient" ]]
            then
                if [[ "$ai_safety" != "inherent" ]] || [[ "$ai_safety" == "guard" ]]
                then
                    ( _messagePlain_probe 'guard: '"$1" >&2 ) > /dev/null
                    rm -f "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt > /dev/null 2>&1
                    rm -f "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt > /dev/null 2>&1
                    echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                    #echo '```keywords' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                    cat "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                    echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                    #echo '```' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                    #echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                    _here_semanticAssist-askPolite >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                    _semanticAssist_loop "$1" "_semanticAssist_bash-backend-lowLatency-special"
                    [[ "$currentGibberish" != "offended" ]] && [[ "$currentGibberish" != "gibberish" ]] && cat "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt | tr -dc 'a-zA-Z0-9' | grep -i 'safe' > /dev/null 2>&1 && currentGibberish="valid"
                    cat "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt | tr -dc 'a-zA-Z0-9' | grep -i 'offended' > /dev/null 2>&1 && currentGibberish="offended"
                fi

                rm -f "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt > /dev/null 2>&1
                rm -f "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt > /dev/null 2>&1
                _here_semanticAssist-askGibberish >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                echo '```keywords' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                cat "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                echo '```' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                _semanticAssist_loop "$1" "_semanticAssist_bash-backend-lowLatency-special"
                [[ "$currentGibberish" != "offended" ]] && [[ "$currentGibberish" != "gibberish" ]] && cat "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt | tr -dc 'a-zA-Z0-9' | grep -i 'valid' > /dev/null 2>&1 && currentGibberish="valid"
                cat "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt | tr -dc 'a-zA-Z0-9' | grep -i 'gibberish' > /dev/null 2>&1 && currentGibberish="gibberish"

                if [[ "$currentGibberish" == "gibberish" ]]
                then
                    _distill_semanticAssist "$1" .gibberish"$currentIteration"_functionLine"$currentLineBegin"_gibberishDetect"$currentIteration_gibberish"_prompt.md "$distill_projectDir" "$distill_distillDir" "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                    _distill_semanticAssist "$1" .gibberish"$currentIteration"_functionLine"$currentLineBegin"_gibberishDetect"$currentIteration_gibberish"_response.md "$distill_projectDir" "$distill_distillDir" "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt
                fi
            fi

            if [[ "$currentGibberish" == "deficient" ]]
            then
                ( _messagePlain_warn 'warn: deficient: '"$1"': '"$currentLineBegin"':' | tr -d '\n' | cat - "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt >&2 ; echo >&2 ) > /dev/null
            fi
            if [[ "$currentGibberish" == "offended" ]]
            then
                ( _messagePlain_bad 'bad: offended: '"$1"': '"$currentLineBegin" >&2 ) > /dev/null
                sleep 2
            fi
            if [[ "$currentGibberish" == "gibberish" ]]
            then
                ( _messagePlain_warn 'warn: gibberish: '"$1"': '"$currentLineBegin"':' | tr -d '\n' | cat - "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt >&2 ; echo >&2 ) > /dev/null
            fi

            currentIteration_gibberish=$(( currentIteration_gibberish + 1 ))
            if [[ "$currentIteration_gibberish" -gt 25 ]]
            then
                #( _messageError 'FAIL: gibberish: '"$1": "$currentLineBegin" >&2 ) > /dev/null
                #return 1
                #exit 1
                _messagePlain_bad 'bad: gibberish: '"$1"': '"$currentLineBegin" >&2
                rm -f "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt > /dev/null 2>&1
                echo > "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt
                currentGibberish="valid"
            fi
        done

        [[ "$currentGibberish" == "valid" ]] && _distill_semanticAssist "$1" .keywords"$currentIterationNext"_functionLine"$currentLineBegin"_response.md "$distill_projectDir" "$distill_distillDir" "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt

        if [[ "$currentLineBegin" == "1" ]] && head -n1 "$1" | grep '^#!/' > /dev/null 2>&1
        then
            head -n1 "$1" >> "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh
            currentLineBegin=2
            #currentLineEnd="$currentLineEnd"
            echo -n '########## semanticAssist: ' >> "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh
            cat "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt | tr ':\n\,;' '\ \ \ \ ' | tr -dc 'a-zA-Z0-9\-_\ ' | head -c 2500 >> "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh
            echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh
            sed -n "${currentLineBegin},${currentLineEnd}p" "$1" >> "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh
        else
            echo -n '########## semanticAssist: ' >> "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh
            cat "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt | tr ':\n\,;' '\ \ \ \ ' | tr -dc 'a-zA-Z0-9\-_\ ' | head -c 2500 >> "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh
            echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh
            sed -n "${currentLineBegin},${currentLineEnd}p" "$1" >> "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh
        fi

        let currentIteration++
        let currentIterationNext++
        let currentIterationNextNext++
    done
    mv -f "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh "$1" > /dev/null


    ( _messagePlain_nominal 'keywords-lines-iteration: '"$1" >&2 ) > /dev/null

    rm -f "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh > /dev/null 2>&1
    local currentTotalLines=$(wc -l < "$1")
    # ATTENTION: Suggest advancing ~150lines or ~4000chars before adding next comment.
    local currentRegionLines_advance=150
    local currentRegionLines_overlap=100
    local currentRegionLines=$(( currentRegionLines_advance + currentRegionLines_overlap ))
    currentLineBegin=1
    while [[ "$currentLineBegin" -lt "$currentTotalLines" ]]
    do
        #currentLineBegin
        currentLineEnd=$(( currentLineBegin + currentRegionLines_advance - 1))
        #currentLineEnd=$(( currentLineBegin + currentRegionLines ))
        [[ "$currentLineEnd" -gt "$currentTotalLines" ]] && currentLineEnd="$currentTotalLines"

        currentGibberish=""
        currentIteration_gibberish=0
        while [[ "$currentGibberish" != "valid" ]]
        do
            currentGibberish=""
            rm -f "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt > /dev/null 2>&1
            rm -f "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt > /dev/null 2>&1
            rm -f "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt > /dev/null 2>&1

            #echo '```description' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            cat "$safeTmp"/"$inputName"-"$currentFileID".description.txt >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            #echo '```' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            
            _here_semanticAssist-askKeywords >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            
            echo '```bash' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            #sed -n "${currentLineBegin},${currentLineEnd}p" "$1" | grep -v '########## semanticAssist:' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            sed -n "${currentLineBegin},"$(( currentLineBegin + currentRegionLines ))"p" "$1" | grep -v '########## semanticAssist:' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            echo '```' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            _distill_semanticAssist "$1" .keywords"$currentIterationNext"_line"$currentLineBegin"_prompt.md "$distill_projectDir" "$distill_distillDir" "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
            _semanticAssist_loop "$1" "_semanticAssist_bash-backend-lowLatency"
            cat "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt | tr ':\n\,;' '\ \ \ \ ' | tr -dc 'a-zA-Z0-9\-_\ ' | _filter_semanticAssist_nuisance | head -c 2500 > "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt

            [[ $(cat "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt | wc -c | tr -dc '0-9') -lt 7 ]] && currentGibberish="deficient"

            if [[ "$currentGibberish" != "deficient" ]]
            then
                if [[ "$ai_safety" != "inherent" ]] || [[ "$ai_safety" == "guard" ]]
                then
                    ( _messagePlain_probe 'guard: '"$1" >&2 ) > /dev/null
                    rm -f "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt > /dev/null 2>&1
                    rm -f "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt > /dev/null 2>&1
                    echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                    #echo '```keywords' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                    cat "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                    echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                    #echo '```' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                    #echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                    _here_semanticAssist-askPolite >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                    _semanticAssist_loop "$1" "_semanticAssist_bash-backend-lowLatency-special"
                    [[ "$currentGibberish" != "offended" ]] && [[ "$currentGibberish" != "gibberish" ]] && cat "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt | tr -dc 'a-zA-Z0-9' | grep -i 'safe' > /dev/null 2>&1 && currentGibberish="valid"
                    cat "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt | tr -dc 'a-zA-Z0-9' | grep -i 'offended' > /dev/null 2>&1 && currentGibberish="offended"
                fi

                rm -f "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt > /dev/null 2>&1
                rm -f "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt > /dev/null 2>&1
                _here_semanticAssist-askGibberish >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                echo '```keywords' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                cat "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                echo '```' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                _semanticAssist_loop "$1" "_semanticAssist_bash-backend-lowLatency-special"
                [[ "$currentGibberish" != "offended" ]] && [[ "$currentGibberish" != "gibberish" ]] && cat "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt | tr -dc 'a-zA-Z0-9' | grep -i 'valid' > /dev/null 2>&1 && currentGibberish="valid"
                cat "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt | tr -dc 'a-zA-Z0-9' | grep -i 'gibberish' > /dev/null 2>&1 && currentGibberish="gibberish"

                if [[ "$currentGibberish" == "gibberish" ]]
                then
                    _distill_semanticAssist "$1" .gibberish"$currentIteration"_line"$currentLineBegin"_gibberishDetect"$currentIteration_gibberish"_prompt.md "$distill_projectDir" "$distill_distillDir" "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt
                    _distill_semanticAssist "$1" .gibberish"$currentIteration"_line"$currentLineBegin"_gibberishDetect"$currentIteration_gibberish"_response.md "$distill_projectDir" "$distill_distillDir" "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt
                fi
            fi

            if [[ "$currentGibberish" == "deficient" ]]
            then
                ( _messagePlain_warn 'warn: deficient: '"$1"': '"$currentLineBegin"':' | tr -d '\n' | cat - "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt >&2 ; echo >&2 ) > /dev/null
            fi
            if [[ "$currentGibberish" == "offended" ]]
            then
                ( _messagePlain_bad 'bad: offended: '"$1"': '"$currentLineBegin" >&2 ) > /dev/null
                sleep 2
            fi
            if [[ "$currentGibberish" == "gibberish" ]]
            then
                ( _messagePlain_warn 'warn: gibberish: '"$1"': '"$currentLineBegin"':' | tr -d '\n' | cat - "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt >&2 ; echo >&2 ) > /dev/null
            fi

            currentIteration_gibberish=$(( currentIteration_gibberish + 1 ))
            if [[ "$currentIteration_gibberish" -gt 25 ]]
            then
                #( _messageError 'FAIL: gibberish: '"$1": "$currentLineBegin" >&2 ) > /dev/null
                #return 1
                #exit 1
                rm -f "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt > /dev/null 2>&1
                echo > "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt
                currentGibberish="valid"
            fi
        done

        [[ "$currentGibberish" == "valid" ]] && _distill_semanticAssist "$1" .keywords"$currentIterationNext"_line"$currentLineBegin"_response.md "$distill_projectDir" "$distill_distillDir" "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt

        if [[ "$currentLineBegin" == "1" ]] && head -n1 "$1" | grep '^#!/' > /dev/null 2>&1
        then
            head -n1 "$1" >> "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh
            currentLineBegin=2
            #currentLineEnd="$currentLineEnd"
            echo -n '########## semanticAssist: ' >> "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh
            cat "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt | tr ':\n\,;' '\ \ \ \ ' | tr -dc 'a-zA-Z0-9\-_\ ' | head -c 2500 >> "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh
            echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh
            sed -n "${currentLineBegin},${currentLineEnd}p" "$1" >> "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh
        else
            echo -n '########## semanticAssist: ' >> "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh
            cat "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt | tr ':\n\,;' '\ \ \ \ ' | tr -dc 'a-zA-Z0-9\-_\ ' | head -c 2500 >> "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh
            echo '' >> "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh
            sed -n "${currentLineBegin},${currentLineEnd}p" "$1" >> "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh
        fi


        currentLineBegin=$(( currentLineBegin + currentRegionLines_advance ))
    done
    mv -f "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh "$1" > /dev/null






    rm -f "$safeTmp"/"$inputName"-"$currentFileID".keywords.txt > /dev/null 2>&1
    rm -f "$safeTmp"/"$inputName"-"$currentFileID".replacement.sh > /dev/null 2>&1
    rm -f "$safeTmp"/"$inputName"-"$currentFileID".description.txt > /dev/null 2>&1
    rm -f "$safeTmp"/"$inputName"-"$currentFileID".tmp_input.txt > /dev/null 2>&1
    rm -f "$safeTmp"/"$inputName"-"$currentFileID".tmp_output.txt > /dev/null 2>&1
}

