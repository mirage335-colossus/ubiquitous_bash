export repoDir="$PWD"

export repoName=$(basename "$repoDir")
export bareRepoDir=../."$repoName".git
export bareRepoAbsoluteDir=$(_getAbsoluteLocation "$bareRepoDir")

#Set $repoHostName in user ".bashrc" or similar. May also set $repoPort including colon prefix.
[[ "$repoHostname" == "" ]] && export repoHostname=$(hostname -f) 
