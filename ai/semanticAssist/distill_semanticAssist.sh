

#export distill_projectDir=$(_getAbsoluteLocation ./_local/experiment) ; export distill_distillDir=$(_getAbsoluteLocation ./_local/experiment_distill) ; cp -f ./os/override/override_cygwin.sh ./_local/experiment/override_cygwin.sh ; ./ubiquitous_bash.sh _semanticAssist ./_local/experiment

#./ubiquitous_bash.sh _distill_semanticAssist $(_getAbsoluteLocation ./_local/experiment/override_cygwin.sh) .prompt_description.md $(_getAbsoluteLocation ./_local)/experiment $(_getAbsoluteLocation ./_local)/experiment_distill $(_getAbsoluteLocation ./_local/experiment/override_cygwin.sh)
# "$1" == origFile (eg. "$1" )
# "$2" == outputExtension (eg. .special-$(uid).txt )
# "$3" == projectDir (eg. "$scriptLocal"/knowledge/"$objectName" )
# "$4" == distillDir (eg. "$scriptLocal"/knowledge_distill/"$objectName" )
# "$5" == distillFile (eg. "$safeTmp"/"$inputName".special.txt )
_distill_semanticAssist() {
    [[ "$3" == "" ]] && return 0
    [[ "$4" == "" ]] && return 0

    local current_origFile_absoluteLocation=$(_getAbsoluteLocation "$1")
    local current_origFile_absoluteFolder=$(_getAbsoluteFolder "$1")

    local current_origFile_name=$(basename "$1")

    local current_outputExtension="$2"

    # CAUTION: Obviously these file parameters must be given as absolute locations .
    local current_projectDir_absoluteLocation="$3"
    local current_distillDir_absoluteLocation="$4"

    local current_distillFile_absoluteFolder=${current_origFile_absoluteFolder/#$current_projectDir_absoluteLocation/$current_distillDir_absoluteLocation}
    mkdir -p "$current_distillFile_absoluteFolder"

    local current_distillFile_write_absoluteLocation="$current_distillFile_absoluteFolder"/"$current_origFile_name""$current_outputExtension"

    local current_distillFile_read_absoluteLocation=$(_getAbsoluteLocation "$5")


    rm -f "$current_distillFile_write_absoluteLocation" > /dev/null 2>&1
    cp -f "$current_distillFile_read_absoluteLocation" "$current_distillFile_write_absoluteLocation" > /dev/null 2>&1
}


#./ubiquitous_bash.sh _format_distill_bash-promptResponse semanticAssist-ubiquitous_bash ./_local/experiment_distill

_format_distill_bash-promptResponse() {
    local current_objectName="$1"
    [[ -z "$current_objectName" ]] && current_objectName="$objectName"

    local current_directory="$2"
    [[ -z "$current_directory" ]] && current_directory="$scriptLocal/knowledge_distill/$current_objectName"

    local dataset="$current_directory"
    local output_file="${current_directory}_finetuning-promptResponse.jsonl"

    rm -f "$output_file" >/dev/null 2>&1

    local segment_file prompt_file response_file prompt completion json_line

    while IFS= read -r -d '' segment_file; do
        prompt_file="$segment_file"

        if [[ "$prompt_file" == *"prompt.md" ]]
        then
            response_file=$(echo "$prompt_file" | sed 's/\prompt\.md$/response.md/')
            [[ ! -e "$response_file" ]] && response_file=$(echo "$prompt_file" | sed 's/\prompt\.md$/response.txt/')
        fi
        
        if [[ ! -e "$response_file" ]] || [[ ! -e "$prompt_file" ]]
        then
            ( _messagePlain_bad "bad: FAIL: missing: prompt/response files: $segment_file" >&2 ) > /dev/null
            ( _messageError 'FAIL' >&2 ) > /dev/null
            _stop 1
            exit 1
            return 1
        fi

        prompt=$(<"$prompt_file")
        completion=$(<"$response_file")

        # Now construct the correct "messages" object as required by OpenAI
        #--arg system_content "You are an expert assistant that generates exemplary bash scripts according to best practices."
        json_line=$(jq -cn \
            --arg user_content "$prompt" \
            --arg assistant_content "$completion" \
            --arg system_content "" \
            '{messages: [
                {role: "system", content: $system_content},
                {role: "user", content: $user_content},
                {role: "assistant", content: $assistant_content}
            ]}')

        echo "$json_line" >> "$output_file"

    done < <(find "$dataset" -type f -iname '*prompt.md' -print0 | sort -zV)

    echo "JSONL file created successfully: $output_file" >&2
}




