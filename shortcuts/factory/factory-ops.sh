
# Very unusual.
if [[ "$ub_ops_disable" != 'true' ]]
then
    if [[ "$objectName" == "ubiquitous_bash" ]] #&& false
    then
        if [[ -e "$scriptAbsoluteFolder"/shortcuts/factory/factory.sh ]] && [[ -e "$scriptAbsoluteFolder"/shortcuts/factory/factoryCreate.sh ]]
        then
            . "$scriptAbsoluteFolder"/shortcuts/factory/factory.sh
            . "$scriptAbsoluteFolder"/shortcuts/factory/factoryCreate.sh
            . "$scriptAbsoluteFolder"/shortcuts/factory/factoryCreate_here.sh
        fi
    fi
fi







