
# Ingredients. Debian pacakges mirror, docker images, pre-built dist/OS images, etc.
_set_ingredients() {
    export ub_INGREDIENTS=""

    local currentDriveLetter

    if ! _if_cygwin
    then
        [[ -e /mnt/ingredients/ingredients ]] && mountpoint /mnt/ingredients && export ub_INGREDIENTS=/mnt/ingredients/ingredients && return 0

        # STRONGLY PREFERRED.
        [[ -e /mnt/ingredients ]] && mountpoint /mnt/ingredients && export ub_INGREDIENTS=/mnt/ingredients && return 0

        # STRONGLY DISCOURAGED.
        # Do NOT create "$HOME"/core/ingredients unless for some very unexpected reason it is necessary for a non-root user to use ingredients.
        [[ -e "$HOME"/core/ingredients ]] && export ub_INGREDIENTS="$HOME"/core/ingredients && return 0

        # WSL(2) specific.
        #_if_wsl
        #uname -a | grep -i 'microsoft' > /dev/null 2>&1 || uname -a | grep -i 'WSL2' > /dev/null 2>&1
        if type _if_wsl > /dev/null 2>&1 && _if_wsl
        then
            [[ -e /mnt/host/z/mnt/ingredients ]] && export ub_INGREDIENTS=/mnt/host/z/mnt/ingredients && return 0
            [[ -e /mnt/z/mnt/ingredients ]] && export ub_INGREDIENTS=/mnt/z/mnt/ingredients && return 0
            [[ -e /mnt/c/core/ingredients ]] && export ub_INGREDIENTS=/mnt/c/core/ingredients && return 0
            [[ -e /mnt/host/c/core/ingredients ]] && export ub_INGREDIENTS=/mnt/host/c/core/ingredients && return 0
            #
            for currentDriveLetter in d e f g h i j k l m n o p q r s t u v w D E F G H I J K L M N O P Q R S T U V W
            do
                [[ -e /mnt/"$currentDriveLetter"/ingredients ]] && export ub_INGREDIENTS=/mnt/"$currentDriveLetter"/ingredients && return 0
            done
            if [[ -e /mnt/host ]]
            then
                for currentDriveLetter in d e f g h i j k l m n o p q r s t u v w D E F G H I J K L M N O P Q R S T U V W
                do
                    [[ -e /mnt/host/"$currentDriveLetter"/ingredients ]] && export ub_INGREDIENTS=/mnt/host/"$currentDriveLetter"/ingredients && return 0
                done
            fi
        fi
    fi

    if _if_cygwin
    then
        [[ -e /cygdrive/z/mnt/ingredients ]] && export ub_INGREDIENTS=/cygdrive/z/mnt/ingredients && return 0
        [[ -e /cygdrive/c/core/ingredients ]] && export ub_INGREDIENTS=/cygdrive/c/core/ingredients && return 0
        #
        for currentDriveLetter in d e f g h i j k l m n o p q r s t u v w D E F G H I J K L M N O P Q R S T U V W
        do
            [[ -e /cygdrive/"$currentDriveLetter"/ingredients ]] && export ub_INGREDIENTS=/cygdrive/"$currentDriveLetter"/ingredients && return 0
        done
    fi




    [[ "$ub_INGREDIENTS" == "" ]] && return 1
    return 0
}


