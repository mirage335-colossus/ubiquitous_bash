
_github_removeActionsHTTPS-filter() {
    _messagePlain_probe '_github_removeActionsHTTPS-filter: '"$1"
    
    sed -i 's/^\sextraheader.*$//g' "$1"
    sed -i 's/^\sinsteadOf = git@github.com:.*$//g' "$1"
    sed -i 's/^\sinsteadOf = org.*@github.com:.*$//g' "$1"
}

_github_removeActionsHTTPS() {
    if [[ "$1" != *".git"* ]] && [[ "$1" != *".git" ]]
    then
        _messagePlain_bad 'warn: missing: .git: '"$1"
        _messageFAIL
        _stop 1
        return 1
    fi

    find "$1" -type f -name 'config' -exec "$scriptAbsoluteLocation" _github_removeActionsHTTPS-filter {} \;
    

}



