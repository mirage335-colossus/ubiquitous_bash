        if [[ $(echo "$MSWEXTPATH" | grep -o ';' | wc -l | tr -dc '0-9') -le 99 ]] && [[ $(echo "$PATH" | grep -o ':' | wc -l | tr -dc '0-9') -le 99 ]]
        then
                export convertedMSWEXTPATH=$(cygpath -p "$MSWEXTPATH")
                export PATH=/usr/bin:"$convertedMSWEXTPATH":"$PATH"
        fi
