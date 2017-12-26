FROM ubvrt/debian:jessie

RUN DEBIAN_FRONTEND=noninteractive apt-get update && apt-get -y --no-install-recommends install \
ca-certificates \
curl \
x11-apps \
libgl1-mesa-glx libgl1-mesa-dri mesa-utils \
wget \
gnupg2 \
file \
build-essential \
fuse \
hicolor-icon-theme \
nano \
vim

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install default-jre

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install grub2 makedev linux-image-amd64

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install cifs-utils nmap smbclient

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install lxde-core lxde task-lxde-desktop

RUN DEBIAN_FRONTEND=noninteractive apt-get -y install kde-plasma-desktop kde-standard kde-full task-kde-desktop
