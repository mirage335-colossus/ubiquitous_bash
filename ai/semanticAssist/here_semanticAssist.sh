
# Cheap way to salvage generated keywords. The alternative is to separate the 'gibberish' from 'keywords' nuisance detection, and subsequently filter only outputs that have 'keywords' nuisance but not 'gibberish' .
_filter_semanticAssist_nuisance() {
    grep -v -i 'Here are the relevant keywords for the code' | \
grep -v -i 'Here are the keywords extracted from the code' | \
grep -v -i 'Here are the relevant keywords for the features implemented in this code' | \
grep -v -i 'Here are the keywords for the code' | \
grep -v -i 'Here are the relevant keywords for each feature' | \
grep -v -i 'Here are the suggested keywords for each feature implemented in this blockquoted code' | \
grep -v -i 'Here are the relevant keywords for the given code' | \
grep -v -i 'Here are the relevant keywords for each functionblock of code' | \
grep -v -i 'Here are the keywords for features implemented in the code' | \
grep -v -i 'Here are the keywords for the provided code' | \
grep -v -i 'Here are the keywords Ive extracted from this code block' | \
grep -v -i 'Here are the keywords I suggest' | \
grep -v -i 'Here are the keywords for the features implemented in this code' | \
grep -v -i 'Here are the keywords that can be added as comments to the code for automated search' | \
grep -v -i 'Here are the keywords that I suggest' | \
grep -v -i 'Here are the keywords for the features implemented in this blockquoted code' | \
grep -v -i 'Here are the keywords for this block of code' | \
grep -v -i 'Here are the keywords for this code' | \
grep -v -i 'Here is a suggested list of keywords that can be used to describe this code' | \
grep -v -i 'Here are the suggested keywords for the provided block of code' | \
grep -v -i 'Here are the suggested keywords' | \
grep -v -i 'Here are the relevant keywords' | \
grep -v -i 'Here are the keywords' | \
grep -v -i 'Here are the keyword' | \
grep -v -i 'Keywords'
}

_here_semanticAssist-askKeywords-ONLY() {
    cat << 'CZXWXcRMTo8EmM8i4d'

Output only the keywords. Do not output any other text. Since these keywords will be added as comments to code for an automated search to detect relevant files, only the keywords will be helpful, any other output will be unhelpful.

CZXWXcRMTo8EmM8i4d
}






_here_semanticAssist-askDescription() {
    _here_convert_bash_promptResponse-askDescription "$@"
}


# Effective, but too verbose, generating keywords for content only in the description, not in the code.
#_here_semanticAssist-askKeywords() {
    #cat << 'CZXWXcRMTo8EmM8i4d'

#Please invent very creative illustrative relevant keywords vaguely reminiscent of the plausibly intended goals and features of these following several lines of code in the context of the previously described codebase. Prefer technical terminology, search terms, etc, keywords. Add plausible synonyms. These keywords will be matched by user queries doing a relevance percentile search for what these lines of code exemplify.

#In this case, you may ignore logical inconsistencies or other errors in the description and code.

#Details of the description are more guidelines or mere suggestions created without adequate planning, and thus may need to change significantly. Sloppy incorrect pseudocode may have been the basis for an incompetent technical writer creating the description by stating mere guesses about what the code does not do as if fact. Occasionally the description may be incomprehensible gibberish.

#You may treat this as an exercise and generate an essentially academic example.

#Only output keywords. Since these keywords will be added as comments to code for an automated search to detect relevant files, only the keywords will be helpful, any other output will be unhelpful.

#CZXWXcRMTo8EmM8i4d
#}

# DANGER: May generate AI LLM gibberish.
# ATTENTION: Although 'add synonyms' may be a useful instruction to ensure more reliable keyword matches, semantic search may be a better approach to avoid raising the 'noise floor' on the search with equivalent concepts. Also, 'add synonyms' may cause phrases instead of single-words, with the same disadvantages.
#  Ideally, the keywords should be rather technical, to convey as much conceptually disparate information as possible to a semantic search.
_here_semanticAssist-askKeywords() {
    cat << 'CZXWXcRMTo8EmM8i4d'

For features implemented in the following blockquoted code please suggest relevant keywords. Prefer single-word technical terms, search terms, etc, keywords. These keywords will be matched by user queries doing a relevance percentile search for what these lines of code exemplify.

Preceding description is provided only for context.

Do not discuss incorrectness of the description or incompleteness of the code.

Do not generate keywords for the description, only keywords for features implemented in the code. If the code has few features, provide appropriately fewer keywords. If the code has only a few comments, provide appropriately fewer keywords, including such appropriate keywords as 'comments'.

Only output keywords. Since these keywords will be added as comments to code for an automated search to detect relevant files, only the keywords will be helpful, any other output will be unhelpful. Do not state 'here are the keywords' or similar.

CZXWXcRMTo8EmM8i4d
}

# CAUTION: DANGER: NOT reliable for all AI LLM models.
# correct (at least as far as tested)
#  Llama 3.1 405b INSTRUCT
#  DeepSeek-R1
# broken
#  Llama-4 Scout (unusually often recognizes valid output as gibberish)
#  Llama 3.1 70b INSTRUCT
#  Llama-augment
#  Llama-4 Maverick
#  DeepSeek-R1 14b
#  DeepSeek-R1 32b
#  DeepSeek-R1 Distill Llama 70b
#  DeepSeek-R1 Distill Llama 8b
# DANGER: Yes, you read that list correctly. Llama-4 Maverick , Llama 3.1 70b INSTRUCT , have incorrectly failed to recognize gibberish, whereas Llama-4 Scout and Llama 3.1 405b INSTRUCT have recognized gibberish correctly.
#  Full DeepSeek-R1 is on the list for producing correct gibberish detection, but this relies on REASONING working around the inherent unpredictability of the input generating many extra tokens, which is much slower and much more expensive for a one-word answer with a very short input prompt.
_here_semanticAssist-askGibberish() {
    cat << 'CZXWXcRMTo8EmM8i4d'

Should be AI autogenerated keywords here, intended to summarize concept from code for keyword search. Are these valid keywords, or did the AI LLM model apparently begin outputting gibberish?

Keywords 'empty', 'blank', etc, for situations not applicable to search terms, may be valid.

Contradictory keywords such as 'empty', 'blank', 'lack', etc, with 'terminal' and 'codeblock' are gibberish.

Always err on the side of assuming the output is gibberish. Typos and misspellings are gibberish.

If there is a phrase 'here are the keywords for the code', or similar, that is gibberish.

If there is anything a reasonable person might be at least slightly offended by, that is gibberish.

Please only output one word gibberish or valid. Do not output any other statements. Response will be processed automatically, so the one word answer either gibberish or valid will be helpful, any other output will be unhelpful.

CZXWXcRMTo8EmM8i4d
}

_here_semanticAssist-askPolite() {
    cat << 'CZXWXcRMTo8EmM8i4d'

Might a reasonable person be at least slightly offended by this preceding text? Output only offended or safe, one word answer is needed for automation, one word offended or safe will be helpful, any other output will be unhelpful.

CZXWXcRMTo8EmM8i4d
}






