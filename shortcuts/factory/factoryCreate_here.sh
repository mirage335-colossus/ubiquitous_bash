
_here_dockerfile-ubiquitous() {
cat << 'CZXWXcRMTo8EmM8i4d'

# https://www.docker.com/blog/introduction-to-heredocs-in-dockerfiles/
COPY <<EOFSPECIAL /ubInstall.sh

#!/usr/bin/env bash

# ###
# PASTE
# ###

if [[ -e /workspace/ubiquitous_bash/ubiquitous_bash.sh ]]
then
/workspace/ubiquitous_bash/ubiquitous_bash.sh _setupUbiquitous_nonet
export profileScriptLocation="/workspace/ubiquitous_bash/ubiquitous_bash.sh"
export profileScriptFolder="/workspace/ubiquitous_bash"
. "/workspace/ubiquitous_bash/ubiquitous_bash.sh" --profile _importShortcuts
else
mkdir -p /workspace
! [[ -e /workspace/ubiquitous_bash.sh ]] && wget 'https://raw.githubusercontent.com/mirage335/ubiquitous_bash/master/ubiquitous_bash.sh'
mv -f ./ubiquitous_bash.sh /workspace/ubiquitous_bash.sh
chmod u+x /workspace/ubiquitous_bash.sh
rmdir /workspace/ubiquitous_bash > /dev/null 2>&1
/workspace/ubiquitous_bash.sh _gitBest clone --depth 1 --recursive git@github.com:mirage335-colossus/ubiquitous_bash.git
mv -f ./ubiquitous_bash /workspace/ubiquitous_bash
mkdir -p /workspace/ubiquitous_bash
! [[ -e /workspace/ubiquitous_bash/ubiquitous_bash.sh ]] && wget 'https://raw.githubusercontent.com/mirage335/ubiquitous_bash/master/ubiquitous_bash.sh'
mv -f ./ubiquitous_bash.sh /workspace/ubiquitous_bash/ubiquitous_bash.sh
chmod u+x /workspace/ubiquitous_bash/ubiquitous_bash.sh
/workspace/ubiquitous_bash/ubiquitous_bash.sh _setupUbiquitous_nonet
fi
#clear

# ###
# PASTE
# ###

EOFSPECIAL
RUN chmod u+x /ubInstall.sh
RUN /ubInstall.sh


# ###
# PASTE
# ###

RUN apt-get update
RUN apt upgrade -y
RUN apt-get install sudo -y
RUN apt-get install less -y
RUN apt-get install pv -y
RUN apt-get install socat -y
RUN apt-get install bc -y
RUN apt-get install xxd -y
RUN apt-get install php -y
RUN apt-get install jq -y
RUN apt-get install gh -y
RUN apt-get install aria2 -y
RUN apt-get install curl wget -y
#RUN apt-get install xz -y
RUN apt-get install xz-utils -y
RUN apt-get install tar bzip2 gzip -y
RUN apt-get install sed patch expect -y
RUN apt-get install dos2unix -y


RUN /workspace/ubiquitous_bash/ubiquitous_bash.sh _getMinimal_cloud

# ###
# PASTE
# ###

CZXWXcRMTo8EmM8i4d
}


_here_dockerfile-ubiquitous-documentation() {
    cat << 'CZXWXcRMTo8EmM8i4d'

# Normally expected redundant. Copyleft license files are normally already preserved at several filesystem locations.
#python3 -m site
# /usr/local/lib/python*/dist-packages
#find /usr/local/lib/python*/dist-packages -iname '*.dist-info'
# /usr/lib/python3/dist-packages
# /usr/share/licenses
# /usr/share/doc
#
RUN mkdir -p /licenses
RUN pip install --no-cache-dir --quiet pip-licenses
RUN pip-licenses --with-license-file --format=markdown > /licenses/PYTHON_THIRD_PARTY.md

CZXWXcRMTo8EmM8i4d
}


_here_dockerfile-ubiquitous-licenses() {

    ! mkdir -p "$scriptLocal"/licenses && ( _messageError 'FAIL' >&2 ) > /dev/null && _stop 1

    [[ ! -e "$scriptLocal"/licenses/gpl-2.0.txt ]] && wget -qO "$scriptLocal"/licenses/gpl-2.0.txt 'https://www.gnu.org/licenses/old-licenses/gpl-2.0.txt'
    [[ ! -e "$scriptLocal"/licenses/gpl-3.0.txt ]] && wget -qO "$scriptLocal"/licenses/gpl-3.0.txt 'https://www.gnu.org/licenses/gpl-3.0.txt'
    [[ ! -e "$scriptLocal"/licenses/agpl-3.0.txt ]] && wget -qO "$scriptLocal"/licenses/agpl-3.0.txt 'https://www.gnu.org/licenses/agpl-3.0.txt'



    echo
    echo 'RUN mkdir -p /licenses'
    echo

    echo 'COPY <<EOFSPECIAL /licenses/gpl-2.0.txt'
cat "$scriptLocal"/licenses/gpl-2.0.txt
echo 'EOFSPECIAL'

    echo 'COPY <<EOFSPECIAL /licenses/gpl-3.0.txt'
cat "$scriptLocal"/licenses/gpl-3.0.txt
echo 'EOFSPECIAL'

    echo 'COPY <<EOFSPECIAL /licenses/agpl-3.0.txt'
cat "$scriptLocal"/licenses/agpl-3.0.txt
echo 'EOFSPECIAL'

    echo

}

