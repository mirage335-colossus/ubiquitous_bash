


_dataset_bash_from_lines() {
    export current_dataset_totalLines
    current_dataset_totalLines=$(wc -l < "$corpus_script")

    export current_dataset_functionBounds

    current_dataset_functionBounds=()

    ## ATTRIBUTION-AI: ChatGPT o1-pro  2025-03-30
    ##local -a current_dataset_functionBounds
    #mapfile -t current_dataset_functionBounds < <(
        #grep -nE '^[[:space:]]*(function[[:space:]]+[_[:alnum:]]+|[_[:alnum:]]+\(\))' "$corpus_script" \
        #| cut -d: -f1
    #)

    # ATTRIBUTION-AI: ChatGPT 4.5-preview  2025-03-30
    # ATTRIBUTION-AI: ChatGPT 4.5-preview 2025-04-06
    mapfile -t current_dataset_functionBounds < <(
    awk '
        # Function to check if this line marks a function declaration
        function is_func(line) {
            #return line ~ /^[[:space:]]*(function[[:space:]]+[_[:alnum:]]+|[_[:alnum:]]+\(\))/;
            return line ~ /^[[:space:]]*(function[[:space:]]+[_[:alnum:]-]+|[_[:alnum:]-]+\(\))/;
        }

        # Store all lines in array "lines"
        { lines[NR] = $0; }

        # After processing all lines, iterate over them again
        END {
            for (i = 1; i <= NR; i++) {
                if (is_func(lines[i])) {
                    start_line = i;
                    # Move upward to collect preceding comment block, stop at empty or non-comment lines
                    j = i - 1;
                    while (j > 0 && lines[j] ~ /^[[:space:]]*#/) { j--; }
                    # Check if there are no empty lines between comment and function
                    if (j == i-1 || (j < i-1 && lines[j+1] ~ /^[[:space:]]*#/)) {
                        start_line = j + 1;
                    }
                    print start_line;
                }
            }
        }
    ' "$corpus_script"
)

    current_dataset_functionBounds+=( "$(( current_dataset_totalLines + 1 ))" )
}

#./ubiquitous_bash.sh _dataset_bash_from_lines-echo ./metaengine/typical/typical_metaengine_buffer.sh
#./ubiquitous_bash.sh _dataset_bash_from_lines-echo | sed 's/\ /\n/g' | wc -l
_dataset_bash_from_lines-echo() {
    _set_corpus_default "$1"

    _dataset_bash_from_lines
    echo "${current_dataset_functionBounds[@]}"

    #sleep 3
    #( echo >&2 ) > /dev/null
    #( echo "$current_dataset_totalLines" >&2 ) > /dev/null
}

# Helper: find the line on which the *current* function starts (largest boundary <= X).
#current_dataset_functionBounds=( # ... ## ... ##### #####)
# ATTRIBUTION-AI: ChatGPT o1-pro  2025-03-31
_dataset_bash_from_lines_functionBegin() {
    local currentLineWanted="$1"
    local i
    for (( i=${#current_dataset_functionBounds[@]} - 1; i>=0; i-- )); do
        if (( current_dataset_functionBounds[i] <= currentLineWanted )); then
            echo "${current_dataset_functionBounds[i]}"
            return
        fi
    done
    # Fallback to line 1 if none found
    echo 1
}

# Helper: find the last line that belongs to the function containing or just before X
# i.e., we find the next function boundary > X, then subtract 1.
#current_dataset_functionBounds=( # ... ## ... ##### #####)
#current_dataset_totalLines=#####
# ATTRIBUTION-AI: ChatGPT o1-pro  2025-03-31
_dataset_bash_from_lines_functionEnd() {
    local currentLineWanted="$1"
    local i
    for (( i=0; i<${#current_dataset_functionBounds[@]}; i++ )); do
    if (( current_dataset_functionBounds[i] > currentLineWanted )); then
        echo "$(( current_dataset_functionBounds[i] - 1 ))"
        return
    fi
    done
    # If none found, end at current_dataset_totalLines
    echo "$current_dataset_totalLines"
}
















