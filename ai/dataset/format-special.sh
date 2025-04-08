
_format_trial() {
    local current_objectName="$1"
    [[ -z "$current_objectName" ]] && current_objectName=$(basename "$PWD")

    local current_directory="$2"
    [[ -z "$current_directory" ]] && current_directory="$PWD"

    local dataset="$current_directory"
    local output_file="${current_directory}/"$objectName"_finetuning-promptResponse-instruct.jsonl"

    rm -f "$output_file" >/dev/null 2>&1

    local segment_file prompt_file response_file prompt completion json_line

    while IFS= read -r -d '' segment_file; do
        response_file="$segment_file"

        prompt_file=$(echo "$response_file" | sed 's/response-solution-llama-3.1-405b-instruct\.md$/prompt-problem.md/')
        
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

    done < <(find "$dataset" -type f -iname 'response-solution-llama-3.1-405b-instruct.md' -print0 | sort -zV)

    echo "JSONL file created successfully: $output_file" >&2


    output_file="${current_directory}/"$objectName"_finetuning-promptResponse-reasoning.jsonl"

    while IFS= read -r -d '' segment_file; do
        response_file="$segment_file"

        prompt_file=$(echo "$response_file" | sed 's/response-solution-deepseek-r1-671b-reasoning\.md$/prompt-problem.md/')
        
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

    done < <(find "$dataset" -type f -iname 'response-solution-deepseek-r1-671b-reasoning.md' -print0 | sort -zV)

    echo "JSONL file created successfully: $output_file" >&2
}
