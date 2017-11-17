_here_dockerfile_entrypoint() {
	cat << 'CZXWXcRMTo8EmM8i4d'
ENTRYPOINT ["/usr/local/bin/entrypoint.sh" "_docker_drop"]
CZXWXcRMTo8EmM8i4d
}

_here_dockerfile_special() {
	cat << 'CZXWXcRMTo8EmM8i4d'
COPY gosu-armel /usr/local/bin/gosu-armel
COPY gosu-amd64 /usr/local/bin/gosu-amd64
COPY gosu-i386 /usr/local/bin/gosu-i386

RUN mkdir -p /etc/skel/Downloads

RUN mkdir -p /opt/exec

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
CZXWXcRMTo8EmM8i4d

_here_dockerfile_entrypoint
}

_here_dockerfile_lite_scratch() {
	cat << 'CZXWXcRMTo8EmM8i4d'
FROM scratch
COPY hello /
CMD ["/hello"]
CZXWXcRMTo8EmM8i4d
}

_here_dockerfile_lite_debianjessie() {
	cat << 'CZXWXcRMTo8EmM8i4d'
FROM ubvrt/debian:jessie
CZXWXcRMTo8EmM8i4d
}

_here_dockerfile_debianjessie() {
	cat << 'CZXWXcRMTo8EmM8i4d'
FROM ubvrt/debian:jessie

RUN apt-get update && apt-get -y --no-install-recommends install \
ca-certificates \
curl \
x11-apps \
libgl1-mesa-glx libgl1-mesa-dri mesa-utils \
wget \
gnupg2 \
file \
build-essential \
fuse \
hicolor-icon-theme

RUN apt-get -y install \
default-jre
CZXWXcRMTo8EmM8i4d
	
	_here_dockerfile_special
}

_here_dockerfile() {
	[[ -e "$scriptLocal"/Dockerfile ]] && cat "$scriptLocal"/Dockerfile && _here_dockerfile_special && return 0
	
	[[ "$dockerBaseObjectName" == "ubvrt/debian:jessie" ]] && _here_dockerfile_debianjessie "$@" && return 0
	
	[[ "$dockerBaseObjectName" == "scratch:latest" ]] && _here_dockerfile_lite_scratch "$@" && return 0
	
	return 1
}
