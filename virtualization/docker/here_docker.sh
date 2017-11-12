_here_dockerfile_lite_scratch() {
	cat << 'CZXWXcRMTo8EmM8i4d'
FROM scratch
ADD hello /
CMD ["/hello"]
CZXWXcRMTo8EmM8i4d
}

_here_dockerfile_lite_debianjessie() {
	cat << 'CZXWXcRMTo8EmM8i4d'
FROM local/debian:jessie
CMD ["/bin/bash"]
CZXWXcRMTo8EmM8i4d
}


_here_dockerfile_debianjessie() {
	cat << 'CZXWXcRMTo8EmM8i4d'
FROM local/debian:jessie

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

COPY gosu-armel /usr/local/bin/gosu-armel
COPY gosu-amd64 /usr/local/bin/gosu-amd64
COPY gosu-i386 /usr/local/bin/gosu-i386

RUN mkdir -p /etc/skel/Downloads

RUN mkdir -p /opt/exec


COPY entrypoint.sh /usr/local/bin/entrypoint.sh

ENTRYPOINT ["/usr/local/bin/entrypoint.sh" "_docker_drop"]
CZXWXcRMTo8EmM8i4d
}

_here_dockerfile() {
	_here_dockerfile_debianjessie "$@"
}
