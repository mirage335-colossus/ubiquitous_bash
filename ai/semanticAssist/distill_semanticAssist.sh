

#export distill_projectDir=$(_getAbsoluteLocation ./_local/experiment) ; export distill_distillDir=$(_getAbsoluteLocation ./_local/experiment_distill) ; cp -f ./os/override/override_cygwin.sh ./_local/experiment/override_cygwin.sh ; ./ubiquitous_bash.sh _semanticAssist ./_local/experiment

#./ubiquitous_bash.sh _distill_semanticAssist $(_getAbsoluteLocation ./_local/experiment/override_cygwin.sh) .prompt_description.md $(_getAbsoluteLocation ./_local)/experiment $(_getAbsoluteLocation ./_local)/experiment_distill $(_getAbsoluteLocation ./_local/experiment/override_cygwin.sh)
# "$1" == origFile (eg. "$1" )
# "$2" == outputExtension (eg. .special-$(uid).txt )
# "$3" == projectDir (eg. "$scriptLocal"/knowledge/"$objectName" )
# "$4" == distillDir (eg. "$scriptLocal"/knowledge_distill/"$objectName" )
# "$5" == distillFile (eg. "$safeTmp"/"$inputName".special.txt )
_distill_semanticAssist() {
    [[ "$3" == "" ]] && return 0
    [[ "$4" == "" ]] && return 0

    local current_origFile_absoluteLocation=$(_getAbsoluteLocation "$1")
    local current_origFile_absoluteFolder=$(_getAbsoluteFolder "$1")

    local current_origFile_name=$(basename "$1")

    local current_outputExtension="$2"

    # CAUTION: Obviously these file parameters must be given as absolute locations .
    local current_projectDir_absoluteLocation="$3"
    local current_distillDir_absoluteLocation="$4"

    local current_distillFile_absoluteFolder=${current_origFile_absoluteFolder/#$current_projectDir_absoluteLocation/$current_distillDir_absoluteLocation}
    mkdir -p "$current_distillFile_absoluteFolder"

    local current_distillFile_write_absoluteLocation="$current_distillFile_absoluteFolder"/"$current_origFile_name""$current_outputExtension"

    local current_distillFile_read_absoluteLocation=$(_getAbsoluteLocation "$5")


    rm -f "$current_distillFile_write_absoluteLocation" > /dev/null 2>&1
    cp -f "$current_distillFile_read_absoluteLocation" "$current_distillFile_write_absoluteLocation" > /dev/null 2>&1
}








