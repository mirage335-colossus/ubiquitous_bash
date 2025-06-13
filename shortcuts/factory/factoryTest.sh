
# ATTENTION
# WebUI Codex explains that if the 'current directory' (ie. "$PWD") is under "$safeTmp", '_getAbsolute_criticalDep' , under 'set -e' and some environments, will  '! readlink -f . > /dev/null 2>&1 && exit 1'  due to '.' as "$safeTmp" not existing. This explanation is consistent and may fit with only recursion causing the failure.
# CLI Codex explains that if the 'current directory' (ie. "$PWD") is under "$safeTmp", '_preserveLog' , under 'set -e' and some environments, fails at  'cp "$logTmp"/* "$permaLog"/ > /dev/null 2>&1'  on non-existent permaLog="$PWD" , logTmp="$safeTmp"/log . This explanation does not fit with only recursion causing the failure.
#
# This may have crept up without any possibility of anticipation: this was not causing issues previously, does not seem related to ongoing changes to "ubiquitous_bash" codebase at the time, may be closely related to ongoing 'inherit_errexit' quirks from different bash versions, indeed affects one the most convoluted bash inherited codepaths, and significant differences in bash versions between some possibly relevant environments do apparently exist.
#
# Changing current directory to "$scriptAbsoluteFolder" is NOT an acceptable workaround, as the "ubiquitous_bash" script may be imported in another bash session not expecting this, and self-deletion of an "ubiquitous_bash" directory is a VERY valid use case (eg. for installers for which cluttering up a filesystem with yet another 'wget ubiquitous_bash.sh' may be undesirable).
#
# In any case, '_stop' with the current directory being the automatically deleted "$safeTmp" , with such recursion as 'factory-ops' is NOT safe.
# TODO: Other "ubiquitous_bash" functions may also be affected, and should be reviewed ASAP for _stop without  ' cd "$functionEntryPWD" '  .
# 
#
#cd "$functionEntryPWD"


___factoryTest_sequence() {
    _messagePlain_nominal '___factoryTest_sequence'
    if [[ "$recursionGuard_factory_ops" == "" ]]
    then
        _messagePlain_probe '_factory_ops_recursion: from ___factoryTest_sequence'
        _factory_ops_recursion "$@"
        return
    fi

    _start
	local functionEntryPWD
	functionEntryPWD="$PWD"


    cd "$safeTmp"
    cp "$scriptAbsoluteFolder"/ubiquitous_bash.sh "$safeTmp"/ubiquitous_bash.sh

    #if [[ "$CI" != "" ]] && [[ "$objectName" == "ubiquitous_bash" ]]
    #then
        _messagePlain_probe 'mkdir -p '"$safeTmp"/repo
        mkdir -p "$safeTmp"/repo
        #( cd "$safeTmp"/repo ; mkdir -p dummyRepo ; cd dummyRepo ; echo dummy > dummy.txt ; mkdir .git ; echo 'dummy' > .git/dummy.txt )
        ##( cd "$safeTmp"/repo ; git config --global checkout.workers -1 ; _gitBest clone --depth 1 git@github.com:mirage335-colossus/"$objectName".git ; cd "$safeTmp"/repo/"$objectName" ; _gitBest submodule update --init --depth 1 --recursive )
        #export safeToDeleteGit="true"
    #fi

    
	cd "$functionEntryPWD"

    #export safeToDeleteGit="true"
    #_messagePlain_probe '_safeRMR "$safeTmp"/repo'
    #_safeRMR "$safeTmp"/repo
    _messagePlain_probe '_stop'
    _stop 0
}
___factoryTest_direct() {
    _messagePlain_nominal '___factoryTest_direct'
    
    if [[ "$recursionGuard_factory_ops" == "" ]]
    then
        _messagePlain_probe '_factory_ops_recursion: from ___factoryTest_direct'
        _factory_ops_recursion "$@"
        return
    fi

    _messagePlain_probe '"$scriptAbsoluteLocation" ___factoryTest_sequence "$@"'
    "$scriptAbsoluteLocation" ___factoryTest_sequence "$@"
}







___factoryTest_skip_recursion1() {
    _messagePlain_nominal '___factoryTest_skip_recursion1'

    _messagePlain_probe '"$scriptAbsoluteLocation" ___factoryTest_sequence "$@"'
    "$scriptAbsoluteLocation" ___factoryTest_sequence "$@"
}








___factoryTest_skip_recursion2_sequence() {
    _messagePlain_nominal '___factoryTest_skip_recursion2_sequence'

    _start
	local functionEntryPWD
	functionEntryPWD="$PWD"

    cd "$safeTmp"
    cp "$scriptAbsoluteFolder"/ubiquitous_bash.sh "$safeTmp"/ubiquitous_bash.sh

    #if [[ "$CI" != "" ]] && [[ "$objectName" == "ubiquitous_bash" ]]
    #then
        _messagePlain_probe 'mkdir -p '"$safeTmp"/repo
        mkdir -p "$safeTmp"/repo
        #( cd "$safeTmp"/repo ; mkdir -p dummyRepo ; cd dummyRepo ; echo dummy > dummy.txt ; mkdir .git ; echo 'dummy' > .git/dummy.txt )
        ##( cd "$safeTmp"/repo ; git config --global checkout.workers -1 ; _gitBest clone --depth 1 git@github.com:mirage335-colossus/"$objectName".git ; cd "$safeTmp"/repo/"$objectName" ; _gitBest submodule update --init --depth 1 --recursive )
        #export safeToDeleteGit="true"
    #fi
    
	cd "$functionEntryPWD"

    #export safeToDeleteGit="true"
    #_messagePlain_probe '_safeRMR "$safeTmp"/repo'
    #_safeRMR "$safeTmp"/repo
    _messagePlain_probe '_stop'
    _stop 0
}
___factoryTest_skip_recursion2() {
    _messagePlain_nominal '___factoryTest_skip_recursion2'

    _messagePlain_probe '"$scriptAbsoluteLocation" ___factoryTest_skip_recursion2_sequence "$@"'
    "$scriptAbsoluteLocation" ___factoryTest_skip_recursion2_sequence "$@"
}


















