
# Very unusual.
_factory_ops() {
    #if [[ "$ub_ops_disable" != 'true' ]]
    #then
        #if [[ "$objectName" == "ubiquitous_bash" ]] #&& false
        #then
            if [[ -e "$scriptAbsoluteFolder"/shortcuts/factory/factory.sh ]] && [[ -e "$scriptAbsoluteFolder"/shortcuts/factory/factoryCreate.sh ]] && [[ -e "$scriptAbsoluteFolder"/shortcuts/factory/factoryCreate_here.sh ]]
            then
                . "$scriptAbsoluteFolder"/shortcuts/factory/factory.sh
                . "$scriptAbsoluteFolder"/shortcuts/factory/factoryCreate.sh
                . "$scriptAbsoluteFolder"/shortcuts/factory/factoryCreate_here.sh
            fi
        #fi
    #fi
    true
}
if [[ "$ub_ops_disable" != 'true' ]]
then
    if [[ "$objectName" == "ubiquitous_bash" ]] #&& false
    then
        _factory_ops
    fi
fi
true


# Before calling function, get latest function version .
#if [[ "$recursionGuard_factory_ops" == "" ]]
#then
    #_factory_ops_recursion "$@"
    #return
#fi
_factory_ops_recursion() {
    local currentExitStatus_recursion=""
    _factory_ops
    if [[ "$recursionGuard_factory_ops" == "" ]]
    then
        export recursionGuard_factory_ops="true"
        "${FUNCNAME[1]}" "$@"
        currentExitStatus_recursion="$?"
        export recursionGuard_factory_ops=""
        unset recursionGuard_factory_ops
        return "$currentExitStatus_recursion"
    fi
    true
}


