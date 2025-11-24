
# ATTRIBUTION-AI: ChatGPT 5.1 (etc), GPT 5.1 Codex , Gemini 3 Pro


_tokens_analysis-sequence() {
    true

    #if ! ollama ls Llama-3-augment-null 2>/dev/null | grep 'Llama-3-augment-null' 2>&1
    #then
        #_start
        #cd "$safeTmp"
        #rm -f Modelfile

        #echo 'FROM Llama-3-augment:latest' > Modelfile
        #echo 'PARAMETER num_predict 2' >> Modelfile
        #echo 'PARAMETER num_keep 131072' >> Modelfile
        #echo 'PARAMETER num_ctx 131072' >> Modelfile

        #ollama create Llama-3-augment-null -f Modelfile > /dev/null 2>&1

        #_stop
    #fi


}

_tokens_analysis() {
    #"$scriptAbsoluteLocation" _tokens_analysis-sequence "$@"

    #cat "$1" | ollama run Llama-3-augment-null --verbose > /dev/null

FILE="$1"

if [ -z "$FILE" ]; then
  echo "Usage: $0 <filename>"
  exit 1
fi

# 1. Count alphanumeric word-chunks (Roughly 1 token, but long words split)
#    We assume average word splitting adds ~20% overhead for complex words/acronyms.
WORD_CHUNKS=$(grep -oE "[a-zA-Z0-9]+" "$FILE" | wc -l)

# 2. Count punctuation/symbols (Almost always 1 token each, rarely merged)
PUNCTUATION=$(grep -oE "[[:punct:]]" "$FILE" | wc -l)

# 3. Count Newlines (LLMs tokenize structural whitespace)
NEWLINES=$(wc -l < "$FILE")

#COMPRESSED=$(gzip -c1 < "$FILE" | wc -c | awk '{print $1 - 18}')
COMPRESSED=$(cat "$FILE" | xz -9ec | wc -c | awk '{print $1 - 18}')

# 4. Calculation
# Formula: (Words * 1.2) + Punctuation + Newlines + Compressed
TOKEN_ESTIMATE=$(awk -v w="$WORD_CHUNKS" -v p="$PUNCTUATION" -v nl="$NEWLINES" -v c="$COMPRESSED" \
  'BEGIN { printf "%.0f", (w * 1.2) + p + nl + c }')

echo "---------------------------------"
echo "File: $FILE"
echo "Alphanumeric Chunks:  $WORD_CHUNKS"
echo "Symbols/Punctuation:  $PUNCTUATION"
echo "Compressed:           $COMPRESSED"
echo "Estimated Tokens:     $TOKEN_ESTIMATE"
echo "---------------------------------"

}

