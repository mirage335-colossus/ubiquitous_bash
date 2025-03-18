
# WARNING: No production use!
# If at all, used ONLY to by:
#  ubDistBuild '_prog'/'core-custom.sh'
#  ubDistBuild '_prog'/'core-upgrade.sh'
#  ubDistBuild '_prog-ops'/'ops-custom.sh'
# Such usage presumes '_create_ubDistBuild-install-ubDistBuild' has been used recently enough to copy 'ubiquitous_bash.sh' to '/home/user/ubDistBuild/' with a sufficiently recent copy of the relevant functions to run within the ChRoot .
# CAUTION: DANGER: Do NOT use 'ubdistchroot' functions during build of ubdist/OS or any other dist/OS . These functions are ONLY intended for customization of a completely built dist/OS. Existence, atomic overwriting, etc, of prerequsite '/home/user/ubDistBuild/ubiquitous_bash.sh' is absolutely NOT feasible to guarantee until underlying dist/OS build has been completed. Such dist/OS build processes are be controlled by 'rotIns' (ie. rotten install script), and must NEVER rely on a copy of 'ubiquitous_bash.sh' from 'ubDistBuild' .

# Better mechanisms of '_userChRoot' , '_dropChRoot' , etc, are NOT used here, due to both lesser requirements of the functions to run (ie. not graphical GUI apps accessing bind mount shared files, etc), and due to the greater emphasis on compatibility (ie. not depending on 'gosu', '_gosuExecVirt', etc).




#_ubdistChRoot _compendium_git-custom-repo-org c/Corporation_ABBREVIATION GitHub_ORGANIZATION
#_ubdistChRoot _compendium_git-custom-repo installations,infrastructure GitHub_ORGANIZATION,USER repositoryName

_drop_ubdistChRoot() {
    if [[ "$ub_dryRun" == "true" ]]
    then
        _stop
        exit
        return
    fi
    
    if ! cd
    then
        _messagePlain_bad 'bad: FAIL: cd'
        _messageFAIL
        _stop 1
    fi
    "$@"
}

_ubdistChRoot() {
    if [[ "$ub_dryRun" == "true" ]]
    then
        _stop
        exit
        return
    fi

    _chroot sudo -n --preserve-env=GH_TOKEN --preserve-env=INPUT_GITHUB_TOKEN -u user /bin/bash /home/user/ubDistBuild/ubiquitous_bash.sh _drop_ubdistChRoot "$@"
}


