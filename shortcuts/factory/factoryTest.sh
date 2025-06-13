
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


















