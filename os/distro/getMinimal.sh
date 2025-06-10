
# ATTENTION: NOTICE: Unusual. Installs only dependencies necessary for some purposes (eg. kernel compiling). May be useful for cloud build (aka. 'Continious Integration' services which (eg. due to slow mirrors configured for Ubuntu) are unable to quickly install all of more normal 'desktop' packages.
# ATTENTION: Override with 'core.sh' or similar.


# Unusual. Strongly discouraged.
# CAUTION: Pulls in as much as >1GB (uncompressed) of binaries. May be unaffordable on uncompressed filesystems.
# Unless your CI job is specifically cross compiling for MSW, you almost certainly do NOT want this.
_getMinimal_cloud-msw() {
	#https://askubuntu.com/questions/876240/how-to-automate-setting-up-of-keyboard-configuration-package
	#apt-get install -y debconf-utils
	export DEBIAN_FRONTEND=noninteractive
	
	_set_getMost_backend "$@"
	_test_getMost_backend "$@"
	#_getMost_debian11_aptSources "$@"
	
	_getMost_backend_aptGetInstall mingw-w64
	_getMost_backend_aptGetInstall g++-mingw-w64-x86-64-win32
	_getMost_backend_aptGetInstall binutils-mingw-w64
	_getMost_backend_aptGetInstall mingw-w64-tools
	_getMost_backend_aptGetInstall gdb-mingw-w64
}

# Unusual. Strongly discouraged. Building Linux Kernel with fewer resources is helpful for compatibility and performance with some constrained and repetitive cloud services.
_getMinimal_cloud() {
	"$scriptAbsoluteLocation" _setupUbiquitous
	
	
	
	#https://askubuntu.com/questions/876240/how-to-automate-setting-up-of-keyboard-configuration-package
	#apt-get install -y debconf-utils
	export DEBIAN_FRONTEND=noninteractive
	
	_set_getMost_backend "$@"
	_test_getMost_backend "$@"
	#_getMost_debian11_aptSources "$@"
	
	
	
	_getMost_backend apt-get update
	_getMost_backend_aptGetInstall sudo
	_getMost_backend_aptGetInstall gpg
	_getMost_backend_aptGetInstall --reinstall wget
	
	_getMost_backend_aptGetInstall vim
	
	_getMost_backend_aptGetInstall linux-image-amd64
	
	_getMost_backend_aptGetInstall strace
	
	# WARNING: Rust is not yet (2023-11-12) anywhere near as editable on the fly or pervasively available as bash .
	#  Criteria for such are far more necessarily far more stringent than might be intuitively obvious.
	#  Rust is expected to remain non-competitive with bash for purposes of 'ubiquitous_bash', even for reference implementations, for at least 6years .
	#   6 years
	# https://users.rust-lang.org/t/does-rust-work-in-cygwin-if-so-how-can-i-get-it-working/25735
	# https://stackoverflow.com/questions/31492799/cross-compile-a-rust-application-from-linux-to-windows
	# https://rustup.rs/
	#curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
	# https://packages.debian.org/search?keywords=rustup&searchon=names&suite=all&section=all
	# https://wiki.debian.org/Rust
	#  DANGER: Do NOT regard 'rustup' as available.
	_getMost_backend_aptGetInstall rustc
	_getMost_backend_aptGetInstall cargo
	#_getMost_backend_aptGetInstall rustup
	
	_getMost_backend_aptGetInstall pigz

	_getMost_backend_aptGetInstall dnsutils
	_getMost_backend_aptGetInstall bind9-dnsutils
	
	_getMost_backend_aptGetInstall qalc
	
	_getMost_backend_aptGetInstall octave
	
	_getMost_backend_aptGetInstall curl
	_getMost_backend_aptGetInstall gdisk
	_getMost_backend_aptGetInstall lz4
	_getMost_backend_aptGetInstall mawk
	_getMost_backend_aptGetInstall nano
	
	_getMost_backend_aptGetInstall jq
	
	_getMost_backend_aptGetInstall sloccount
	
	#_getMost_backend_aptGetInstall original-awk
	_getMost_backend_aptGetInstall gawk
	
	_getMost_backend_aptGetInstall build-essential
	_getMost_backend_aptGetInstall bison
	_getMost_backend_aptGetInstall libelf-dev
	_getMost_backend_aptGetInstall elfutils
	_getMost_backend_aptGetInstall flex
	_getMost_backend_aptGetInstall libncurses-dev
	_getMost_backend_aptGetInstall autoconf
	_getMost_backend_aptGetInstall libudev-dev

	_getMost_backend_aptGetInstall dwarves
	_getMost_backend_aptGetInstall pahole

	_getMost_backend_aptGetInstall cmake
	
	_getMost_backend_aptGetInstall pkg-config
	
	_getMost_backend_aptGetInstall bsdutils
	_getMost_backend_aptGetInstall findutils
	
	_getMost_backend_aptGetInstall patch
	
	_getMost_backend_aptGetInstall tar
	_getMost_backend_aptGetInstall xz
	_getMost_backend_aptGetInstall gzip
	_getMost_backend_aptGetInstall bzip2
	
	_getMost_backend_aptGetInstall flex

	_getMost_backend_aptGetInstall imagemagick
	_getMost_backend_aptGetInstall graphicsmagick-imagemagick-compat
	
	_getMost_backend_aptGetInstall librecode0
	_getMost_backend_aptGetInstall wkhtmltopdf
	
	_getMost_backend_aptGetInstall sed
	
	
	_getMost_backend_aptGetInstall curl
	
	_messagePlain_probe 'install: rclone'
	#_getMost_backend curl https://rclone.org/install.sh | _getMost_backend bash -s beta
	_getMost_backend curl https://rclone.org/install.sh | _getMost_backend bash
	
	# Apparently Github Actions does not have IPv6.
	# https://github.com/actions/virtual-environments/issues/668#issuecomment-624080758
	[[ "$CI" != "" ]] && _getMost_backend curl -4 https://rclone.org/install.sh | _getMost_backend bash
	
	if ! _getMost_backend type rclone > /dev/null 2>&1
	then
		_getMost_backend_aptGetInstall rclone
	fi
	
	
	_getMost_backend_aptGetInstall sockstat
	_getMost_backend_aptGetInstall liblinear4 liblua5.3-0 lua-lpeg nmap nmap-common
	
	_getMost_backend_aptGetInstall socat
	
	#_getMost_backend_aptGetInstall octave
	#_getMost_backend_aptGetInstall octave-arduino
	#_getMost_backend_aptGetInstall octave-bart
	#_getMost_backend_aptGetInstall octave-bim
	#_getMost_backend_aptGetInstall octave-biosig
	#_getMost_backend_aptGetInstall octave-bsltl
	#_getMost_backend_aptGetInstall octave-cgi
	#_getMost_backend_aptGetInstall octave-communications
	#_getMost_backend_aptGetInstall octave-control
	#_getMost_backend_aptGetInstall octave-data-smoothing
	#_getMost_backend_aptGetInstall octave-dataframe
	#_getMost_backend_aptGetInstall octave-dicom
	#_getMost_backend_aptGetInstall octave-divand
	#_getMost_backend_aptGetInstall octave-econometrics
	#_getMost_backend_aptGetInstall octave-financial
	#_getMost_backend_aptGetInstall octave-fits
	#_getMost_backend_aptGetInstall octave-fuzzy-logic-toolkit
	#_getMost_backend_aptGetInstall octave-ga
	#_getMost_backend_aptGetInstall octave-gdf
	#_getMost_backend_aptGetInstall octave-geometry
	#_getMost_backend_aptGetInstall octave-gsl
	#_getMost_backend_aptGetInstall octave-image
	#_getMost_backend_aptGetInstall octave-image-acquisition
	#_getMost_backend_aptGetInstall octave-instrument-control
	#_getMost_backend_aptGetInstall octave-interval
	#_getMost_backend_aptGetInstall octave-io
	#_getMost_backend_aptGetInstall octave-level-set
	#_getMost_backend_aptGetInstall octave-linear-algebra
	#_getMost_backend_aptGetInstall octave-lssa
	#_getMost_backend_aptGetInstall octave-ltfat
	#_getMost_backend_aptGetInstall octave-mapping
	#_getMost_backend_aptGetInstall octave-miscellaneous
	#_getMost_backend_aptGetInstall octave-missing-functions
	#_getMost_backend_aptGetInstall octave-mpi
	#_getMost_backend_aptGetInstall octave-msh
	#_getMost_backend_aptGetInstall octave-mvn
	#_getMost_backend_aptGetInstall octave-nan
	#_getMost_backend_aptGetInstall octave-ncarry
	#_getMost_backend_aptGetInstall octave-netcdf
	#_getMost_backend_aptGetInstall octave-nlopt
	#_getMost_backend_aptGetInstall octave-nurbs
	#_getMost_backend_aptGetInstall octave-octclip
	#_getMost_backend_aptGetInstall octave-octproj
	#_getMost_backend_aptGetInstall octave-openems
	#_getMost_backend_aptGetInstall octave-optics
	#_getMost_backend_aptGetInstall octave-optim
	#_getMost_backend_aptGetInstall octave-optiminterp
	#_getMost_backend_aptGetInstall octave-parallel
	#_getMost_backend_aptGetInstall octave-pfstools
	#_getMost_backend_aptGetInstall octave-plplot
	#_getMost_backend_aptGetInstall octave-psychtoolbox-3
	#_getMost_backend_aptGetInstall octave-quarternion
	#_getMost_backend_aptGetInstall octave-queueing
	#_getMost_backend_aptGetInstall octave-secs1d
	#_getMost_backend_aptGetInstall octave-secs2d
	#_getMost_backend_aptGetInstall octave-secs3d
	#_getMost_backend_aptGetInstall octave-signal
	#_getMost_backend_aptGetInstall octave-sockets
	#_getMost_backend_aptGetInstall octave-sparsersb
	#_getMost_backend_aptGetInstall octave-specfun
	#_getMost_backend_aptGetInstall octave-splines
	#_getMost_backend_aptGetInstall octave-stk
	#_getMost_backend_aptGetInstall octave-strings
	#_getMost_backend_aptGetInstall octave-struct
	#_getMost_backend_aptGetInstall octave-symbolic
	#_getMost_backend_aptGetInstall octave-tsa
	#_getMost_backend_aptGetInstall octave-vibes
	#_getMost_backend_aptGetInstall octave-vlfeat
	#_getMost_backend_aptGetInstall octave-rml
	#_getMost_backend_aptGetInstall octave-zenity
	#_getMost_backend_aptGetInstall octave-zeromq
	#_getMost_backend_aptGetInstall gnuplot-qt libdouble-conversion3 libegl-mesa0 libegl1 libevdev2 libinput-bin libinput10 libmtdev1 libqt5core5a libqt5dbus5 libqt5gui5 libqt5network5 libqt5printsupport5 libqt5svg5 libqt5widgets5 libwacom-bin libwacom-common libwacom2 libxcb-icccm4 libxcb-image0 libxcb-keysyms1 libxcb-randr0 libxcb-render-util0 libxcb-util1 libxcb-xinerama0 libxcb-xinput0 libxcb-xkb1 libxkbcommon-x11-0 qt5-gtk-platformtheme qttranslations5-l10n
	#_getMost_backend_aptGetInstall hdf5-helpers libaec-dev libegl-dev libfftw3-bin libfftw3-dev libfftw3-long3 libfftw3-quad3 libgl-dev libgl1-mesa-dev libgles-dev libgles1 libgles libglvnd-dev libglx-dev libhdf5-cpp-103 libhdf5-dev liboctave-dev libopengl-dev libopengl0
	
	
	_getMost_backend_aptGetInstall axel
	_getMost_backend_aptGetInstall aria2
	
	
	_getMost_backend_aptGetInstall gh
	
	
	_getMost_backend_aptGetInstall dwarves
	_getMost_backend_aptGetInstall pahole
	
	
	_getMost_backend_aptGetInstall rsync
	
	
	_getMost_backend_aptGetInstall libssl-dev
	
	
	_getMost_backend_aptGetInstall cpio
	
	
	_getMost_backend_aptGetInstall pv
	_getMost_backend_aptGetInstall expect
	
	_getMost_backend_aptGetInstall libfuse2
	
	_getMost_backend_aptGetInstall libgtk2.0-0
	
	_getMost_backend_aptGetInstall libwxgtk3.0-gtk3-0v5
	
	_getMost_backend_aptGetInstall wipe
	
	_getMost_backend_aptGetInstall udftools
	
	
	_getMost_backend_aptGetInstall debootstrap
	
	#_getMost_backend_aptGetInstall qemu-user qemu-utils
	_getMost_backend_aptGetInstall qemu-system-x86
	
	_getMost_backend_aptGetInstall cifs-utils
	
	_getMost_backend_aptGetInstall dos2unix


	_getMost_backend_aptGetInstall xxd


	_getMost_backend_aptGetInstall debhelper
	
	_getMost_backend_aptGetInstall p7zip
	_getMost_backend_aptGetInstall nsis

	
	_getMost_backend_aptGetInstall jp2a

	
	_getMost_backend_aptGetInstall iputils-ping
	
	_getMost_backend_aptGetInstall btrfs-tools
	_getMost_backend_aptGetInstall btrfs-progs
	_getMost_backend_aptGetInstall btrfs-compsize
	_getMost_backend_aptGetInstall zstd
	
	_getMost_backend_aptGetInstall zlib1g
	
	_getMost_backend_aptGetInstall nilfs-tools
	
	
	
	# md5sum , sha512sum
	_getMost_backend_aptGetInstall coreutils
	
	_getMost_backend_aptGetInstall python3
	
	# blkdiscard
	_getMost_backend_aptGetInstall util-linux
	
	# sg_format
	_getMost_backend_aptGetInstall sg3-utils
	
	_getMost_backend_aptGetInstall kpartx
	
	_getMost_backend_aptGetInstall openssl
	
	_getMost_backend_aptGetInstall growisofs
	
	_getMost_backend_aptGetInstall udev
	
	_getMost_backend_aptGetInstall gdisk
	
	_getMost_backend_aptGetInstall cryptsetup
	
	_getMost_backend_aptGetInstall util-linux
	
	_getMost_backend_aptGetInstall parted
	
	_getMost_backend_aptGetInstall bc
	
	_getMost_backend_aptGetInstall e2fsprogs
	
	_getMost_backend_aptGetInstall xz-utils
	
	_getMost_backend_aptGetInstall libreadline8
	_getMost_backend_aptGetInstall libreadline-dev
	
	
	_getMost_backend_aptGetInstall mkisofs
	_getMost_backend_aptGetInstall genisoimage
	
	
	
	_getMost_backend_aptGetInstall php
	
	
	
	# purge-old-kernels
	_getMost_backend_aptGetInstall byobu
	
	
	
	
	
	_getMost_backend_aptGetInstall xorriso
	_getMost_backend_aptGetInstall squashfs-tools
	_getMost_backend_aptGetInstall grub-pc-bin
	_getMost_backend_aptGetInstall grub-efi-amd64-bin
	_getMost_backend_aptGetInstall mtools
	_getMost_backend_aptGetInstall mksquashfs
	_getMost_backend_aptGetInstall grub-mkstandalone
	_getMost_backend_aptGetInstall mkfs.vfat
	_getMost_backend_aptGetInstall dosfstools
	_getMost_backend_aptGetInstall mkswap
	_getMost_backend_aptGetInstall mmd
	_getMost_backend_aptGetInstall mcopy
	_getMost_backend_aptGetInstall fdisk
	_getMost_backend_aptGetInstall mkswap
	
	



	# ATTRIBUTION-AI ChatGPT o1 2025-01-03 ... partially. Seems there is some evidence newer dist/OS versions may be more likely to break by default, 'i386', needed for building MSW installers, etc.
	_getMost_backend dpkg --add-architecture i386
	_getMost_backend env DEBIAN_FRONTEND=noninteractive apt-get -y update
	_getMost_backend_aptGetInstall libc6:i386 lib32z1
	#_getMost_backend_aptGetInstall wine wine32 wine64 libwine libwine:i386 fonts-wine


	
	
	
	
	_messagePlain_probe _getMost_backend curl croc
	if ! _getMost_backend type croc > /dev/null 2>&1
	then
		_getMost_backend curl https://getcroc.schollz.com | _getMost_backend bash
		[[ "$CI" != "" ]] && _getMost_backend curl -4 | _getMost_backend bash
	fi
	
	
	
	_getMost_backend_aptGetInstall iotop
	
	
	
	# May not be useful for anything, may cause delay or fail .
	#_getMost_backend apt-get upgrade
	
	
	
	
	type _get_veracrypt > /dev/null 2>&1 && "$scriptAbsoluteLocation" _get_veracrypt
	
	
	
	_getMost_backend apt-get remove --autoremove -y plasma-discover


	
	#_getMost_backend_aptGetInstall tboot

	_getMost_backend_aptGetInstall trousers
	_getMost_backend_aptGetInstall tpm-tools
	_getMost_backend_aptGetInstall trousers-dbg
	
	
	_getMost_backend_aptGetInstall cloud-guest-utils

	
	_getMost_backend apt-get -y clean
	
	
	# ATTENTION: Enable. Disabled by default to avoid testing for all dependencies of *complete* 'ubiquitous_bash' .
	#export devfast="true"
	#"$scriptAbsoluteLocation" _test
	#export devfast=
	#unset devfast


	_messagePlain_probe _custom_splice_opensslConfig
	_here_opensslConfig_legacy | _getMost_backend tee /etc/ssl/openssl_legacy.cnf > /dev/null 2>&1

    if ! _getMost_backend grep 'openssl_legacy' /etc/ssl/openssl.cnf > /dev/null 2>&1
    then
        _getMost_backend cp -f /etc/ssl/openssl.cnf /etc/ssl/openssl.cnf.orig
        echo '


.include = /etc/ssl/openssl_legacy.cnf

' | _getMost_backend cat /etc/ssl/openssl.cnf.orig - | _getMost_backend tee /etc/ssl/openssl.cnf > /dev/null 2>&1
    fi
	
	
	return 0
}


# Minimizes runtime (to avoid timeouts) and conflicts with installed software. Usually used by specialized Docker containers (eg. 'ghcr.io/openai/codex-universal' , 'openai-heavy' , etc) , within environments unable (unlike a usual VPS) to directly use a custom dist/OS (eg. OpenAI ChatGPT Codex WebUI , RunPod , etc).
_getMinimal_special() {
	echo 'APT::AutoRemove::RecommendsImportant "true";
APT::AutoRemove::SuggestsImportant "true";' | tee /etc/apt/apt.conf.d/99autoremove-recommends > /dev/null


	
	unset _aptGetInstall
	unalias _aptGetInstall 2>/dev/null
	_aptGetInstall() {
		env XZ_OPT="-T0" DEBIAN_FRONTEND=noninteractive apt-get -o Dpkg::Options::="--force-confdef" -o Dpkg::Options::="--force-confold" install -q --install-recommends -y "$@"
	}

	# ubiquitous_bash  fast alternative
	#procps strace sudo wget gpg curl pigz pixz bash aria2 git git-lfs bc nmap socat sockstat rsync net-tools uuid-runtime netcat-openbsd axel util-linux gawk libncurses-dev gh crudini bsdutils findutils p7zip p7zip-full unzip zip lbzip2 dnsutils bind9-dnsutils lz4 mawk patch tar gzip bzip2 sed pv expect wipe iputils-ping zstd zlib1g coreutils openssl xz-utils libreadline8 libreadline-dev mkisofs genisoimage dos2unix lsof aptitude jq xxd sloccount dosfstools apt-utils git-filter-repo qalc apt-transport-https tcl tk

	# ubiquitous_bash  basic alternative
	#procps strace sudo wget gpg curl pigz pixz bash aria2 git git-lfs bc nmap socat sockstat rsync net-tools uuid-runtime netcat-openbsd axel unionfs-fuse util-linux screen gawk libelf-dev libncurses-dev gh crudini bsdutils findutils p7zip p7zip-full unzip zip lbzip2 jp2a dnsutils bind9-dnsutils lz4 mawk libelf-dev elfutils patch tar gzip bzip2 librecode0 udftools sed cpio pv expect wipe iputils-ping btrfs-progs btrfs-compsize zstd zlib1g coreutils openssl growisofs e2fsprogs xz-utils libreadline8 libreadline-dev mkisofs genisoimage wodim dos2unix fuse-overlayfs xorriso squashfs-tools mtools lsof aptitude jq xxd sloccount dosfstools apt-utils git-filter-repo qalc apt-transport-https tcl tk

	_aptGetInstall procps strace sudo wget gpg curl pigz pixz bash aria2 git git-lfs bc nmap socat sockstat rsync net-tools uuid-runtime iperf3 vim man-db gnulib libtool libtool-bin intltool libgts-dev netcat-openbsd iperf axel unionfs-fuse debootstrap util-linux screen gawk build-essential flex libelf-dev libncurses-dev autoconf libudev-dev dwarves pahole cmake gh libusb-dev libusb-1.0 setserial libffi-dev libusb-1.0-0 libusb-1.0-0-dev libusb-1.0-doc pkg-config crudini bsdutils findutils v4l-utils libevent-dev libjpeg-dev libbsd-dev libusb-1.0 gdb libbabeltrace1 libc6-dbg libsource-highlight-common libsource-highlight4v5 initramfs-tools dmidecode p7zip p7zip-full unzip zip lbzip2 jp2a dnsutils bind9-dnsutils live-boot mktorrent gdisk lz4 mawk nano bison libelf-dev elfutils patch tar gzip bzip2 librecode0 sed texinfo udftools wondershaper sysbench libssl-dev cpio pv expect libfuse2 wipe iputils-ping btrfs-progs btrfs-compsize zstd zlib1g nilfs-tools coreutils sg3-utils kpartx openssl growisofs udev cryptsetup parted e2fsprogs xz-utils libreadline8 libreadline-dev mkisofs genisoimage wodim eject hdparm sdparm php cifs-utils debhelper nsis dos2unix fuse-overlayfs xorriso squashfs-tools grub-pc-bin grub-efi-amd64-bin mtools squashfs-tools squashfs-tools-ng fdisk lsof usbutils aptitude recode libpotrace0 libwmf-bin w3m par2 yubikey-manager qrencode tasksel jq xxd sloccount dosfstools apt-utils git-filter-repo qalc apt-transport-https tcl tk libgdl-3-5 libgdl-3-common > /quicklog.tmp 2>&1
	tail /quicklog.tmp
	rm -f /quicklog.tmp

	#tcl tk libgdl-3-5 libgdl-3-common

	#avrdude gcc-avr binutils-avr avr-libc stm32flash dfu-util libnewlib-arm-none-eabi gcc-arm-none-eabi binutils-arm-none-eabi

	#mingw-w64 g++-mingw-w64-x86-64-win32 binutils-mingw-w64 mingw-w64-tools gdb-mingw-w64

	#pkg-haskell-tools alex cabal-install happy hscolour ghc

	#kicad electric lepton-eda pcb-rnd gerbv electronics-pcb pstoedit pdftk

	#wkhtmltopdf asciidoc

	#vainfo ffmpeg

	#samba qemu-system-x86 qemu-system-arm qemu-efi-arm qemu-efi-aarch64 qemu-user-static qemu-utils dosbox

	#wireless-tools rfkill cloud-guest-utils

	#recoll

	#zbar-tools



	#rustc cargo

	#openjdk-17-jdk openjdk-17-jre

	#psk31lx

	#emacs

	#python3-serial



	#locales-all

	# ddd

	

	apt-get remove --autoremove -y
	apt-get -y clean



	"$scriptAbsoluteLocation" _here_opensslConfig_legacy | tee /etc/ssl/openssl_legacy.cnf > /dev/null 2>&1
	echo '

	.include = /etc/ssl/openssl_legacy.cnf

	' | cat /etc/ssl/openssl.cnf.orig - 2>/dev/null | tee /etc/ssl/openssl.cnf > /dev/null 2>&1


}

