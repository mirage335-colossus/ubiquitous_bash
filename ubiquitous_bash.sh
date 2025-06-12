export ub_setScriptChecksum_contents='1137062094'
       _extra
       _tryExec "_prepare_prog" || true
       _tryExec "_start_prog" || true
       if [[ "$ubDEBUG" == "true" ]] ; then set +x ; set +E ; set +o functrace ; set +o errtrace ; export -n SHELLOPTS 2>/dev/null || true ; trap '' RETURN ; trap - RETURN ; fi

       local ub_stop_errexit_was_on=""
       case $- in
               *e*) ub_stop_errexit_was_on="true" ; set +e ;;
       esac
       _tryExec "_stop_prog" || true

       _tryExec "_stop_queue_page" || true
       _tryExec "_stop_queue_aggregatorStatic" || true
       _stop_stty_echo
       if [[ "$ub_stop_errexit_was_on" == "true" ]]; then set -e; fi
       if [[ "$1" != "" ]]
       then
               exit "$1"
       else
               exit 0
       fi
                        return "$internalFunctionExitStatus" > /dev/null 2>&1 || true
                        exit "$internalFunctionExitStatus"
                ub_import=""
                return "$internalFunctionExitStatus" > /dev/null 2>&1 || true
                exit "$internalFunctionExitStatus"
       return "$internalFunctionExitStatus" > /dev/null 2>&1 || true
