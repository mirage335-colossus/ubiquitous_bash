
# ### NOTICE ###
# gitCompendium
# custom/upgrade functions for git repositories and for all git repositories owned by an organization
# Mostly used by ubDistBuild and derivatives to custom/upgrade Operating Systems for organizations with both the tools and development resources to backup (ie. to optical disc), create workstations, create replacement repository servers, etc. Continuous Integration (CI) can keep such a backup/workstation/replacement dist/OS always recent enough to rely on, and small enough to frequently, conveniently, distribute on the coldest of cold storage to vaults, as well as data preservation facilities.
#
# Also sometimes useful to somewhat automatically upgrade an organization's existing workstation, server, etc.



# EXAMPLE
#_ubdistChRoot_backend_begin
#_backend_override _compendium_git-custom-repo installations,infrastructure,c/Corporation_ABBREVIATION GitHub_ORGANIZATION,USER repositoryName --depth 1
#_ubdistChRoot_backend_end

# EXAMPLE
#_repo-GitHub_ORGANIZATION() { _backend_override _compendium_git-custom-repo installations,infrastructure,c/Corporation_ABBREVIATION GitHub_ORGANIZATION,USER repositoryName --depth 1 ; }
#_ubdistChRoot_backend _repo-GitHub_ORGANIZATION



# DANGER: Only use within ephemeral CI, ChRoot, etc.
#_compendium_gitFresh
# |___ _compendium_gitFresh_sequence


#_compendium_git-upgrade-repo
# |___ _compendium_git-custom-repo
#
#     |___ _compendium_git_sequence-custom-repo


#_compendium_git-upgrade-repo-org
# |___ _compendium_git-custom-repo-org
#
#     |___ _compendium_git_sequence_sequence-custom-repo-org *
#         |___ _compendium_git_sequence-custom-repo-org
#
#             |___ _compendium_git-custom-repo


#_compendium_git-upgrade-repo-user
# |___ _compendium_git-custom-repo-user
#
#     |___ _compendium_git_sequence_sequence-custom-repo-user *
#         |___ _compendium_git_sequence-custom-repo-org
#
#             |___ _compendium_git-custom-repo




#_ubdistChRoot _compendium_git-custom-repo installations,infrastructure,c/Corporation_ABBREVIATION GitHub_ORGANIZATION,USER repositoryName --depth 1
_compendium_git_sequence-custom-repo() {
    _messageNormal '\/ \/ \/ _compendium_git-custom-repo: '"$@"

    _start
    local functionEntryPWD
    functionEntryPWD="$PWD"

    local current_coreSubDir="$1"
    local current_GitHubORGANIZATION="$2"
    local current_repositoryName="$3"

    shift ; shift ; shift

    [[ "$GH_TOKEN" == "" ]] && _messagePlain_warn 'warn: missing: GH_TOKEN'

    export INPUT_GITHUB_TOKEN="$GH_TOKEN"

    if [[ -e /home/user/core/"$current_coreSubDir"/"$current_repositoryName" ]]
    then
        [[ "$ub_dryRun" != "true" ]] && mkdir -p /home/user/core/"$current_coreSubDir"/"$current_repositoryName"
        [[ "$ub_dryRun" != "true" ]] && cd /home/user/core/"$current_coreSubDir"/"$current_repositoryName"

        _messagePlain_probe git checkout "HEAD"
        [[ "$ub_dryRun" != "true" ]] && ! git checkout "HEAD" && _messageFAIL
        _messagePlain_probe _gitBest pull
        [[ "$ub_dryRun" != "true" ]] && ! "$scriptAbsoluteLocation" _gitBest pull && _messageFAIL
        _messagePlain_probe _gitBest submodule update --init "$@" --recursive
        [[ "$ub_dryRun" != "true" ]] && ! "$scriptAbsoluteLocation" _gitBest submodule update --init "$@" --recursive && _messageFAIL
    fi

    #else
    if ! [[ -e /home/user/core/"$current_coreSubDir"/"$current_repositoryName" ]]
    then
        [[ "$ub_dryRun" != "true" ]] && mkdir -p /home/user/core/"$current_coreSubDir"
        [[ "$ub_dryRun" != "true" ]] && cd /home/user/core/"$current_coreSubDir"
        
        _messagePlain_probe _gitBest clone --recursive "$@" 'git@github.com:'"$current_GitHubORGANIZATION"'/'"$current_repositoryName"'.git'
        [[ "$ub_dryRun" != "true" ]] && ! "$scriptAbsoluteLocation" _gitBest clone --recursive "$@" 'git@github.com:'"$current_GitHubORGANIZATION"'/'"$current_repositoryName"'.git' && _messageFAIL
    fi
    
    
    [[ "$ub_dryRun" != "true" ]] && ! ls /home/user/core/"$current_coreSubDir"/"$current_repositoryName" && _messageFAIL

    cd "$functionEntryPWD"
    _stop
}
_compendium_git-custom-repo() {
    "$scriptAbsoluteLocation" _compendium_git_sequence-custom-repo "$@"
}
_compendium_git-upgrade-repo() {
    _compendium_git-custom-repo "$@"
}



#_ubdistChRoot _compendium_git-custom-repo-org c/Corporation_ABBREVIATION GitHub_ORGANIZATION --depth 1
_compendium_git_sequence-custom-repo-org() {
    _messageNormal '\/ _compendium_git_sequence-custom-repo-org: '"$@"

    _start
    local functionEntryPWD
    functionEntryPWD="$PWD"

    local current_coreSubDir="$1"
    local current_GitHubORGANIZATION="$2"

    shift ; shift


    export INPUT_GITHUB_TOKEN="$GH_TOKEN"

    [[ "$ub_dryRun" != "true" ]] && mkdir -p /home/user/core/"$current_coreSubDir"
    [[ "$ub_dryRun" != "true" ]] && cd /home/user/core/"$current_coreSubDir"

    local currentPage
    local currentRepository
    local currentRepositoryNumber

    if [[ "$ub_dryRun" == "true" ]]
    then
        currentPage=1
        currentRepository="doNotMatch"
        currentRepositoryNumber=1
        local repositoryCount="99"
        #&& [[ "$repositoryCount" -gt "0" ]]
        while [[ "$currentPage" -le "10" ]] && [[ "$repositoryCount" -gt "0" ]]
        do
            _messagePlain_probe 'repository counts...'
            # get list of repository urls
            repositoryCount=$(curl --no-fail --retry 5 --retry-delay 90 --connect-timeout 45 --max-time 600 -s -H 'Authorization: token '"$GH_TOKEN" 'https://api.github.com/'"$current_API"'/'"$current_GitHubORGANIZATION"'/repos?per_page=30&page='"$currentPage" | grep  "^    \"git_url\"" | awk -F': "' '{print $2}' | sed -e 's/",//g' | wc -w)
            
            echo "$repositoryCount"

            let currentPage="$currentPage"+1

            sleep 1
        done
    fi

    currentPage=1
    currentRepository="doNotMatch"
    currentRepositoryNumber=1
    while [[ "$currentPage" -le "10" ]] && [[ "$currentRepository" != "" ]]
    do
        currentRepository=""
        
        # ATTRIBUTION-AI: ChatGPT ...
        # https://platform.openai.com/playground/p/6it5h1B901jvAblUhdbsPHEN?model=text-davinci-003
        #curl -s https://api.github.com/"$current_API"/$current_GitHubORGANIZATION/repos?per_page=30 | jq -r '.[].git_url'
        #for currentRepository in $(curl -s -H 'Authorization: token '"$GH_TOKEN" 'https://api.github.com/'"$current_API"'/'"$current_GitHubORGANIZATION"'/repos?per_page=30&page='"$currentPage" | grep  "^    \"git_url\"" | awk -F': "' '{print $2}' | sed -e 's/",//g' | sed 's/git:\/\/github.com\/'"$current_GitHubORGANIZATION"'\//git@github.com:'"$current_GitHubORGANIZATION"'\//g')
        # ATTRIBUTION-AI: claude-37.-sonnet:thinking
        for currentRepository in $(curl --no-fail --retry 5 --retry-delay 90 --connect-timeout 45 --max-time 600 -s -H "Authorization: token $GH_TOKEN" 'https://api.github.com/'"$current_API"'/'"$current_GitHubORGANIZATION"'/repos?per_page=30&page='"$currentPage" | jq -r '.[].name' | tr -dc 'a-zA-Z0-9\-_.:\n')
        do
            sleep 1
            
            _messageNormal '\/ \/' _compendium_git-custom-repo "$current_coreSubDir" "$current_GitHubORGANIZATION" "$currentRepository" "$@"
            #_messagePlain_probe _compendium_git-custom-repo "$current_coreSubDir" "$current_GitHubORGANIZATION" "$currentRepository" "$@"
            _messagePlain_probe_var currentRepositoryNumber
            if ! _compendium_git-custom-repo "$current_coreSubDir" "$current_GitHubORGANIZATION" "$currentRepository" "$@"
            then
                _messageFAIL
            fi

            sleep 1
            let currentRepositoryNumber="$currentRepositoryNumber"+1
        done

        #[[ "$currentRepository" == "doNotMatch" ]] && currentRepository=""

        let currentPage="$currentPage"+1
    done

    cd "$functionEntryPWD"
    _stop
}
_compendium_git_sequence_sequence-custom-repo-user() {
    export current_API="users"
    "$scriptAbsoluteLocation" _compendium_git_sequence-custom-repo-org "$@"
}
_compendium_git-custom-repo-user() {
    "$scriptAbsoluteLocation" _compendium_git_sequence_sequence-custom-repo-user "$@"
}
_compendium_git-upgrade-repo-user() {
    _compendium_git-custom-repo-user "$@"
}
_compendium_git_sequence_sequence-custom-repo-org() {
    export current_API="orgs"
    "$scriptAbsoluteLocation" _compendium_git_sequence-custom-repo-org "$@"
}
_compendium_git-custom-repo-org() {
    "$scriptAbsoluteLocation" _compendium_git_sequence_sequence-custom-repo-org "$@"
}
_compendium_git-upgrade-repo-org() {
    _compendium_git-custom-repo-org "$@"
}







# DANGER: Only use within ephemeral CI, ChRoot, etc.
#_ubdistChRoot _compendium_gitFresh installations,infrastructure,c/Corporation_ABBREVIATION repositoryName --depth 1
_compendium_gitFresh() {
    if [[ "$ub_dryRun" == "true" ]]
    then
        _stop
        exit
        return
    fi

    local current_coreSubDir="$1"
    local current_repositoryName="$2"

    mkdir -p /home/user/core/"$current_coreSubDir"/"$current_repositoryName"
    
    if ! cd /home/user/core/"$current_coreSubDir"/"$current_repositoryName" || ! [[ -e /home/user/core/"$current_coreSubDir"/"$current_repositoryName" ]]
    then 
        _messageError 'bad: FAIL: cd '/home/user/core/"$current_coreSubDir"/"$current_repositoryName"
        _messageFAIL
        exit 1
    fi

    "$scriptAbsoluteLocation" _compendium_gitFresh_sequence "$current_coreSubDir" "$current_repositoryName"
}
_compendium_gitFresh_sequence() {
    if [[ "$ub_dryRun" == "true" ]]
    then
        _stop
        exit
        return
    fi

    _start

    local current_coreSubDir="$1"
    local current_repositoryName="$2"

    mkdir -p /home/user/core/"$current_coreSubDir"/"$current_repositoryName"
    
    if ! cd /home/user/core/"$current_coreSubDir"/"$current_repositoryName" || ! [[ -e /home/user/core/"$current_coreSubDir"/"$current_repositoryName" ]]
    then 
        _messageError 'bad: FAIL: cd '/home/user/core/"$current_coreSubDir"/"$current_repositoryName"
        _messageFAIL
        exit 1
    fi

    # DANGER: Only use within ephemeral CI, ChRoot, etc.
    [[ "$ub_dryRun" != "true" ]] && _gitFresh_enable
    [[ "$ub_dryRun" != "true" ]] && _gitFresh
    unset _gitFresh > /dev/null 2>&1
    unset -f _gitFresh > /dev/null 2>&1

    _stop
}





