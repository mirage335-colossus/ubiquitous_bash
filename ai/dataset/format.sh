
#./ubiquitous_bash.sh _format_bash ubiquitous_bash ./_local/dataset/ubiquitous_bash

# You are an expert assistant that generates exemplary bash scripts according to best practices.
# Ok, now you should know something about ubiquitous_bash . Please write a bash while loop in the new format .

#response_file="${prompt_file%.prompt.txt}"
#--arg system_content "You are an expert assistant that generates exemplary bash scripts according to best practices."

_format_bash() {
    _format_bash-promptResponse "$@"
    _format_bash-pretraining "$@"
}




# ATTRIBUTION-AI: ChatGPT 4.5-preview  2025-04-01
_format_bash-promptResponse() {
    local current_objectName="$1"
    [[ -z "$current_objectName" ]] && current_objectName="$objectName"

    local current_directory="$2"
    [[ -z "$current_directory" ]] && current_directory="$scriptLocal/dataset/$current_objectName"

    local dataset="$current_directory"
    local output_file="${current_directory}_finetuning-promptResponse.jsonl"

    rm -f "$output_file" >/dev/null 2>&1

    local prompt_file response_file prompt completion json_line

    while IFS= read -r -d '' prompt_file; do
        response_file="${prompt_file%.prompt.txt}"
        
        if [[ ! -f "$response_file" ]]; then
            echo "FAIL: missing response file: $response_file" >&2
            return 1
        fi

        prompt=$(<"$prompt_file")
        completion=$(<"$response_file")

        # Now construct the correct "messages" object as required by OpenAI
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

    done < <(find "$dataset" -maxdepth 1 -type f -name "*.prompt.txt" -print0 | sort -zV)

    echo "JSONL file created successfully: $output_file" >&2
}

_format_bash_sequence-pretraining() {
    _start

    local current_objectName="$1"
    [[ -z "$current_objectName" ]] && current_objectName="$objectName"

    local current_directory="$2"
    [[ -z "$current_directory" ]] && current_directory="$scriptLocal/dataset/$current_objectName"

    local dataset="$current_directory"
    local output_file="${current_directory}_finetuning-pretraining.jsonl"

    rm -f "$output_file" >/dev/null 2>&1

    local prompt_file response_file prompt completion json_line

    prompt_file="SKIP"
    while IFS= read -r -d '' response_file; do
        rm -f "$safeTmp"/prompt_file >/dev/null 2>&1
        rm -f "$safeTmp"/response_file >/dev/null 2>&1

        if [[ "$prompt_file" != "SKIP" ]]
        then
            # WARNING: For essentially continued pre-training, this extra formatting may or may NOT be harmful!
            #  ATTENTION: CAUTION: EXPERIMENT DILIGENTLY!
            echo 'Continue the example bash shellcode.' >> "$safeTmp"/prompt_file
            echo >> "$safeTmp"/prompt_file
            echo '```bash' >> "$safeTmp"/prompt_file
            cat "$prompt_file" >> "$safeTmp"/prompt_file
            echo '```' >> "$safeTmp"/prompt_file
            echo >> "$safeTmp"/prompt_file

            echo 'Here is the continuation of the bash shellcode:' >> "$safeTmp"/response_file
            echo >> "$safeTmp"/response_file
            echo '```bash' >> "$safeTmp"/response_file
            cat "$response_file" >> "$safeTmp"/response_file
            echo '```' >> "$safeTmp"/response_file
            echo >> "$safeTmp"/response_file
            

            #prompt=$(<"$prompt_file")
            #completion=$(<"$response_file")

            prompt=$(<"$safeTmp"/prompt_file)
            completion=$(<"$safeTmp"/response_file)

            # Now construct the correct "messages" object as required by OpenAI
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
        fi

        prompt_file="$response_file"

    done < <(find "$dataset" -maxdepth 1 -type f  ! -iname '*.prompt.txt' ! -iname '*.response.txt' ! -iname '*.continue_prompt.txt' ! -iname '*.continue_response.txt' ! -iname '*.description.txt' -print0 | sort -zV)

    echo "JSONL file created successfully: $output_file" >&2

    _stop
}
_format_bash-pretraining() {
    "$scriptAbsoluteLocation" _format_bash_sequence-pretraining "$@"
}


















