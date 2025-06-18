

# ATTRIBUTION-AI: ChatGPT o1-preview 2024-11-25 .
# This is a tricky issue, which is not easily reproduced nor solved. Presumably due to '| tee' under the powershell environment used by 'build.yml', or possibly due to standard input somehow being piped as well, stdout is redirected while stderr actually does exist but is reported as a non-existent file when written to, and cannot be replaced, with error messages 'No such file or directory' and 'Read-only file system'. Redirections of subshells through other means, such as ' 2>&1 ' does not work.
# ATTENTION: There may not be any real solution other than simply avoiding depending on usable /dev/stderr , such as by using quiet mode with apt-cyg --quiet .
_cygwin_workaround_dev_stderr() {
    # ChatGPT search found this link, which strongly implicates the '| tee' used for logging by build.yml as causing the absence of stderr .
    # https://cygwin.com/pipermail/cygwin/2017-July/233639.html?utm_source=chatgpt.com

    #if [ ! -e /dev/stderr ] || ! echo x | tee /dev/stderr > /dev/null
    #then
        #_messagePlain_warn 'warn: workaround /dev/stderr: exec 2>&1'
        ## ATTRIBUTION-AI: ChatGPT 4o 2024-11-25 .
        #exec 2>&1
    #fi
    
    # DUBIOUS
    #if [ ! -e /dev/stderr ] || ! echo x | tee /dev/stderr > /dev/null
    #then
        #mkdir -p /dev
        #ln -sf /proc/self/fd/1 /dev/stderr
    #fi

    # DUBIOUS
    #if [ ! -e /dev/stderr ] || ! echo x | tee /dev/stderr > /dev/null
    #then
        #mkdir -p /dev
        #ln -sf /proc/self/fd/1 /dev/stderr
    #fi
    #if [ ! -e /dev/stderr ] || ! echo x | tee /dev/stderr > /dev/null
    #then
        #mkdir -p /dev
        #ln -sf /dev/fd/1 /dev/stderr
    #fi
    #if [ ! -e /dev/stderr ] || ! echo x | tee /dev/stderr > /dev/null
    #then
        #mkdir -p /dev
        #ln -sf /proc/$$/fd/1 /dev/stderr
    #fi

    
    # Local experiments with a functional Cygwin/MSW environment show creating /dev/stderr_experiment this way is apparently not usable anyway.
    #if [ ! -e /dev/stderr ] || ! echo x | tee /dev/stderr > /dev/null
    #then
        #mkdir -p /dev
        #mknod /dev/stderr c 1 3
        #chmod 622 /dev/stderr
    #fi

    #if [ ! -e /dev/stderr ] || ! echo x | tee /dev/stderr > /dev/null
    #then
        #_messagePlain_bad 'fail: missing: /dev/stderr'
        #_messageFAIL
    #fi

    return 0
}




_getMost_cygwin_sequence-priority() {
    _cygwin_workaround_dev_stderr

    _start

    _messageNormal "_getMost_cygwin_priority: apt-cyg --quiet install"
    
    #nc,

cat << 'CZXWXcRMTo8EmM8i4d' | grep -v '^#' | tee "$safeTmp"/cygwin_package_list_priority_01
bash-completion
bc
bzip
coreutils
curl
dos2unix
expect
git
git-svn
gnupg
inetutils
jq
lz4
mc
nc
openssh
openssl
perl
psmisc
python37
pv
rsync
ssh-pageant
screen
subversion
unzip
vim
wget
zip
zstd
tigervnc-server
flex
bison
libncurses-devel
par2
python3-pip
gnupg2
CZXWXcRMTo8EmM8i4d



cat << 'CZXWXcRMTo8EmM8i4d' | grep -v '^#' | tee "$safeTmp"/cygwin_package_list_priority_02
bash-completion
bc
bzip
coreutils
curl
dos2unix
expect
git
git-svn
gnupg
inetutils
jq
lz4
mc
nc
openssh
openssl
perl
psmisc
python37
pv
rsync
ssh-pageant
screen
subversion
unzip
vim
wget
zip
zstd
procps-ng
awk
socat
aria2
jq
gnupg2
php
php-PEAR
php-devel
gnuplot-base
gnuplot-doc
gnuplot-qt5
gnuplot-wx
gnuplot-X11
libqalculate-common
libqalculate-devel
libqalculate5
cantor-backend-qalculate
octave
octave-devel
octave-parallel
octave-linear-algebra
octave-general
octave-geometry
octave-strings
octave-financial
octave-communications
octave-control
mkisofs
genisoimage
dbus
dbus-x11
tigervnc-server
flex
bison
libncurses-devel
p7zip
par2
python3-pip
gnupg2 2>&1
CZXWXcRMTo8EmM8i4d


    local currentLine

    cat "$safeTmp/cygwin_package_list_priority_01" | while read currentLine
    do
        #echo "$currentLine"
        _messagePlain_probe apt-cyg --quiet install "$currentLine"
        apt-cyg --quiet install "$currentLine" 2>&1
    done

    cat "$safeTmp/cygwin_package_list_priority_02" | while read currentLine
    do
        #echo "$currentLine"
        _messagePlain_probe apt-cyg --quiet install "$currentLine"
        apt-cyg --quiet install "$currentLine" 2>&1
    done

    _stop
}
_getMost_cygwin-priority() {
    "$scriptAbsoluteLocation" _getMost_cygwin_sequence-priority "$@"
}

_getMost_cygwin_sequence() {
    _cygwin_workaround_dev_stderr

    _start

    _messageNormal "_getMost_cygwin: list installed"
    apt-cyg --quiet show | cut -f1 -d\ | tail -n +2 | tee "$safeTmp"/cygwin_package_list_installed

    _messageNormal "_getMost_cygwin: list desired"
    cat << 'CZXWXcRMTo8EmM8i4d' | grep -v '^#' | tee "$safeTmp"/cygwin_package_list_desired
#_autorebase
#adwaita-icon-theme
#alternatives
aria2
#at-spi2-core
autoconf
#autoconf2.1
#autoconf2.5
#autoconf2.7
base-cygwin
base-files
bash
bash-completion
bc
binutils
bison
bsdtar
build-docbook-catalog
bzip2
#ca-certificates
cantor
cantor-backend-qalculate
coreutils
#crypto-policies
#csih
curl
#cygrunsrv
#cygutils
#cygwin
#cygwin-devel
dash
dbus
dbus-x11
dconf-service
#dejavu-fonts
desktop-file-utils
dialog
diffutils
docbook-xml45
docbook-xsl
dos2unix
#dri-drivers
ed
editrights
expect
file
findutils
flex
gamin
gawk
gcc-core
gcr
gdk-pixbuf2.0-svg
genisoimage
#getent
#gettext
ghostscript
ghostscript-fonts-other
git
git-svn
glib2.0-networking
gnome-keyring
gnupg2
gnuplot-X11
gnuplot-base
gnuplot-doc
gnuplot-qt5
gnuplot-wx
grep
groff
gsettings-desktop-schemas
#gtk-update-icon-cache
gzip
#hicolor-icon-theme
hostname
inetutils
#info
ipc-utils
iso-codes
jq
#kf5-kdoctools
less
#libEGL1
libFLAC8
#libGL1
#libGLU1
#libGraphicsMagick++12 # ATTENTION
#libGraphicsMagick3 # ATTENTION
#libICE6
#libKF5Archive5
#libKF5Attica5
#libKF5Auth5
#libKF5Bookmarks5
#libKF5Codecs5
#libKF5Completion5
#libKF5Config5
#libKF5ConfigWidgets5
#libKF5CoreAddons5
#libKF5Crash5
#libKF5DBusAddons5
#libKF5GlobalAccel5
#libKF5GuiAddons5
#libKF5I18n5
#libKF5IconThemes5
#libKF5ItemViews5
#libKF5JobWidgets5
#libKF5KIO5
#libKF5NewStuff5
#libKF5Notifications5
#libKF5Parts5
#libKF5Service5
#libKF5Solid5
#libKF5Sonnet5
#libKF5SyntaxHighlighting5
#libKF5TextEditor5
#libKF5TextWidgets5
#libKF5Wallet5
#libKF5WidgetsAddons5
#libKF5WindowSystem5
#libKF5XmlGui5
#libQt5Core5
#libQt5Gui5
#libQt5Help5
#libQt5Quick5
#libQt5Script5
#libQt5Sql5
#libQt5Svg5
#libQt5TextToSpeech5
#libQt5X11Extras5
#libQt5XmlPatterns5
libSDL2_2.0_0
#libSM6
#libX11-xcb1
#libX11_6
#libXau6
#libXaw7
#libXcomposite1
#libXcursor1
#libXdamage1
#libXdmcp6
#libXext6
#libXfixes3
#libXfont2_2
#libXft2
#libXi6
#libXinerama1
#libXmu6
#libXmuu1
#libXpm4
#libXrandr2
#libXrender1
#libXss1
#libXt6
#libXtst6
#libaec0
#libamd2
#libapr1
#libaprutil1
libarchive13
#libargon2_1
libargp
#libarpack0
#libaspell15
#libassuan0
#libasyncns0
#libatk-bridge2.0_0
#libatk1.0_0
#libatomic1
#libatspi0
libattr1
libblkid1
#libbrotlicommon1
#libbrotlidec1
#libbsd0
#libbtf1
#libbz2_1
libcairo2
#libcamd2
#libcares2
#libccolamd2
#libcerf1
#libcharset1
#libcholmod3
#libcln-devel
#libcln6
#libcolamd2
#libcom_err2
#libcroco0.6_3
libcrypt0
libcrypt2
libcurl4
#libcxsparse3
#libdatrie1
#libdb5.3
libdbus-glib_1_2
libdbus1_3
libdbusmenu-qt5_2
#libde265_0
libdeflate0
libdialog15
libdotconf0
libe2p2
#libedit0
#libenchant1
#libepoxy0
#libespeak1
libexpat1
libext2fs2
libfam0
libfdisk1
libffi-devel
libffi6
libffi8
#libfftw3_3
libfido2
libflite1
libfltk1.3
#libfontconfig-common
#libfontconfig1
#libfontenc1
#libfreetype6
#libfribidi0
#libgailutil3_0
#libgc1
libgcc1
libgck1_0
libgcr-base3_1
libgcr-ui3-common
libgcr-ui3_1
libgcrypt20
libgd3
#libgdbm4
#libgdbm6
#libgdbm_compat4
libgdk_pixbuf2.0_0
#libgeoclue0
#libgfortran5
#libgit2_25
libgl2ps1
#libglapi0
#libglib2.0-devel
#libglib2.0_0
#libglpk40
#libgmp-devel
#libgmp10
#libgmpxx4
libgnutls30
#libgomp1
#libgpg-error0
#libgpgme11
#libgpgmepp6
#libgraphite2_3
libgs10
libgs9
#libgsasl-common
#libgsasl18
#libgssapi_krb5_2
#libgstinterfaces1.0_0
#libgstreamer1.0_0
#libgtk3_0
#libguile3.0_1
#libharfbuzz-icu0
#libharfbuzz0
#libhdf5_200
#libheif1
libhogweed4
libhogweed6
#libhunspell1.6_0
#libiconv
#libiconv-devel
#libiconv2
#libicu56
#libicu61
#libicu74
#libidn12
#libidn2_0
#libimagequant0
#libintl-devel
#libintl8
#libiodbc2
#libisl23
#libjasper4
#libjavascriptcoregtk3.0_0
#libjbig2
#libjpeg8
#libjq1
#libk5crypto3
libklu1
#libkpathsea6
#libkrb5_3
#libkrb5support0
#libksba8
#liblapack0
#liblcms2_2
libllvm8
libltdl7
liblua5.3
#liblz4_1
#liblzma5
#liblzo2_2
libmd0
libmetalink3
#libmetis0
#libmp3lame0
#libmpc3
#libmpfr6
#libmpg123_0
#libmspack0
#libmysqlclient18
#libncurses++w10
libncurses-devel
#libncursesw10
libnettle6
libnettle8
#libnghttp2_14
#libnotify4
#libnpth0
#libntlm0
#libogg0
#libonig5
#libopenblas
#libopenldap2
#libopenldap2_4_2
#libopus0
#liborc0.4_0
libp11-kit0
#libpango1.0_0
#libpaper-common
#libpaper1
#libpcre-devel
#libpcre1
#libpcre16_0
#libpcre2_16_0
#libpcre2_8_0
#libpcre32_0
#libpcrecpp0
#libpcreposix0
#libphonon4qt5_4
#libpipeline1
libpixman1_0
libpkgconf5
libpng16
libpopt-common
libpopt0
#libportaudio2
libpotrace0
#libpq5
#libproc2_0
#libproxy1
#libpsl5
libptexenc1
#libpulse-simple0
#libpulse0
libqalculate-common
libqalculate-devel
libqalculate5
#libqhull_8
#libqrupdate0
#libqscintilla2_qt5-common
#libqscintilla2_qt5_13
#libquadmath0
libraqm0
libreadline7
libretls26
librsvg2_2
#libsamplerate0
#libsasl2_3
libsecret1_0
#libserf1_0
#libslang2
#libsmartcols1
#libsndfile1
#libsodium-common
#libsodium23
#libsoup2.4_1
libspectre1
#libspeechd2
#libspqr2
#libsqlite3_0
#libssh2_1
#libssl1.0
#libssl1.1
#libssl3
#libstdc++6
#libsuitesparseconfig5
#libsundials_ida5
#libsundials_sunlinsol3
#libsundials_sunmatrix3
#libsybdb5
#libsynctex2
#libsz2
#libtasn1_6
#libteckit0
#libtexlua53_5
#libtexluajit2
#libthai0
#libtiff6
#libtiff7
#libuchardet0
#libumfpack5
#libunistring5
#libusb1.0
libuuid1
#libvoikko1
#libvorbis
#libvorbis0
#libvorbisenc2
#libwebkitgtk3.0_0
#libwebp5
#libwebp7
#libwebpdemux2
#libwebpmux3
libwrap0
libwx_baseu3.0_0
libwx_gtk3u3.0_0
#libxcb-dri2_0
#libxcb-glx0
#libxcb-icccm4
#libxcb-image0
#libxcb-keysyms1
#libxcb-randr0
#libxcb-render-util0
#libxcb-render0
#libxcb-shape0
#libxcb-shm0
#libxcb-sync1
#libxcb-util1
#libxcb-xfixes0
#libxcb-xinerama0
#libxcb-xkb1
#libxcb1
#libxkbcommon0
#libxkbfile1
#libxml2
libxml2-devel
#libxslt
libxxhash0
#libzstd1
#libzzip0.13
#login
lz4
m4
make
#man-db
#mariadb-common
mc
#mintty
mkisofs
#mysql-common
#ncurses
netcat
octave
octave-communications
octave-control
octave-devel
octave-financial
octave-general
octave-geometry
octave-io
octave-linear-algebra
octave-parallel
octave-signal
octave-strings
octave-struct
openssh
openssl
p11-kit
p11-kit-trust
p7zip
par2
patch
perl
#perl-Clone
#perl-Encode-Locale
#perl-Error
#perl-File-Listing
#perl-HTML-Parser
#perl-HTML-Tagset
#perl-HTTP-Cookies
#perl-HTTP-Date
#perl-HTTP-Message
#perl-HTTP-Negotiate
#perl-IO-HTML
#perl-IO-String
#perl-JSON-PP
#perl-LWP-MediaTypes
#perl-Net-HTTP
#perl-TermReadKey
#perl-TimeDate
#perl-Tk
#perl-Try-Tiny
#perl-URI
#perl-WWW-RobotRules
#perl-XML-Parser
#perl-YAML
#perl-libwww-perl
#perl_autorebase
perl_base
php
php-PEAR
php-bz2
php-devel
php-zlib
pinentry
pkg-config
pkgconf
poppler-data
procps-ng
psmisc
#publicsuffix-list-dafsa
pv
python3
python3-pip
#python37
#python37-pip
#python37-setuptools
#python39
#python39-babel
#python39-chardet
#python39-docutils
#python39-idna
#python39-imagesize
#python39-imaging
#python39-iniconfig
#python39-jinja2
#python39-markupsafe
#python39-olefile
#python39-packaging
#python39-pip
#python39-platformdirs
#python39-pluggy
#python39-pygments
#python39-pyparsing
#python39-pytest
#python39-railroad-diagrams
#python39-requests
#python39-setuptools
#python39-six
#python39-snowballstemmer
#python39-sphinx
#python39-sphinxcontrib-serializinghtml
#python39-toml
#python39-urllib3
rebase
rsync
run
screen
sed
#sgml-common
#shared-mime-info
socat
#speech-dispatcher
#ssh-pageant
subversion
#subversion-perl
#suomi-malaga
tar
tcl
tcl-tk
terminfo
texlive
texlive-collection-basic
texlive-collection-latex
tigervnc-server
tzcode
tzdata
unzip
#urw-base35-fonts
util-linux
vim
vim-common
vim-minimal
w32api-headers
w32api-runtime
wget
which
windows-default-manifest
#xauth
#xcursor-themes
#xkbcomp
#xkeyboard-config
#xorg-server-common
xxd
xz
zip
zlib-devel
zlib0
zstd
CZXWXcRMTo8EmM8i4d

    _messageNormal "_getMost_cygwin: todo"
    # ATTRIBUTION-AI: ChatGPT o1-preview 2024-11-25 .
    grep -F -x -v -f "$safeTmp/cygwin_package_list_installed" "$safeTmp/cygwin_package_list_desired" | tee "$safeTmp/cygwin_package_list_todo"


    local currentLine
    cat "$safeTmp/cygwin_package_list_todo" | while read currentLine
    do
        #echo "$currentLine"
        _messagePlain_probe apt-cyg --quiet install "$currentLine"
        apt-cyg --quiet install "$currentLine" 2>&1
    done


    _stop
}
_getMost_cygwin() {
    "$scriptAbsoluteLocation" _getMost_cygwin_sequence "$@" 2>&1
}



_custom_ubcp_prog() {
	true
}
_custom_ubcp_sequence() {
	_cygwin_workaround_dev_stderr

    local functionEntryPWD
    functionEntryPWD="$PWD"
    
    _messageNormal '_custom_ubcp: apt-cyg --quiet'
	_messagePlain_probe apt-cyg --quiet install ImageMagick
    apt-cyg --quiet install ImageMagick 2>&1
	#_messagePlain_probe_cmd apt-cyg --quiet install ffmpeg
	
	_messageNormal '_custom_ubcp: pip3'
	_messagePlain_probe pip3 install piexif
    pip3 install piexif 2>&1



    _messageNormal '_custom_ubcp: runpodctl'

    #wget -qO- 'https://cli.runpod.net' | sed 's/\[ "\$EUID" -ne 0 \]/false/' | bash

    mkdir -p "$HOME"/core/installations
    cd "$HOME"/core/installations
    _gitBest clone --recursive --depth 1 git@github.com:runpod/runpodctl.git
    
    cd "$HOME"/bin/
    rm -f runpodctl.exe
    #wget 'https://github.com/runpod/runpodctl/releases/download/v1.14.3/runpodctl-windows-amd64.exe' -O runpodctl.exe
    wget 'https://github.com/runpod/runpodctl/releases/download/v1.14.4/runpodctl-windows-amd64.exe' -O runpodctl.exe
    chmod ugoa+rx runpodctl.exe

    cd "$functionEntryPWD"



    # https://github.com/asciinema/asciinema/issues/467
    # wsl asciinema rec -c cmd.exe
    # https://github.com/Watfaq/PowerSession-rs
    _messageNormal '_custom_ubcp: PowerSession - asciinema alternative for MSWindows'

    mkdir -p "$HOME"/core/installations
    cd "$HOME"/core/installations
    _gitBest clone --recursive --depth 1 git@github.com:Watfaq/PowerSession-rs.git
    
    cd "$HOME"/bin/
    rm -f PowerSession.exe
    wget 'https://github.com/Watfaq/PowerSession-rs/releases/latest/download/PowerSession.exe' -O PowerSession.exe
    chmod ugoa+rx PowerSession.exe


    cd "$functionEntryPWD"



    # https://gitlab.com/saalen/ansifilter/-/releases
    # http://andre-simon.de/zip/ansifilter-2.21-x64.zip
    # https://web.archive.org/web/20250618063648/http://andre-simon.de/zip/ansifilter-2.21-x64.zip
    _messageNormal '_custom_ubcp: ansifilter'

    mkdir -p "$HOME"/core/installations
    cd "$HOME"/core/installations
    wget 'https://web.archive.org/web/20250618063648/http://andre-simon.de/zip/ansifilter-2.21-x64.zip'
    if [[ $(sha256sum ansifilter-2.21-x64.zip | cut -f1 -d' ' | tr -dc 'a-fA-F0-9') != '57624ae40be4c9173937d15c97f68413daa271a0ec2248ec83394f220b88adb9' ]]
    then
        rm -f ansifilter-2.21-x64.zip
    else
        unzip -o ansifilter-2.21-x64.zip
        rm -f ansifilter-2.21-x64.zip
        cd ansifilter-2.21-x64
        chmod ugoa+rx ansifilter.exe
        chmod ugoa+rx ansifilter-gui.exe
        #cp -a ansifilter.exe "$HOME"/bin/ansifilter.exe
        #cp -a ansifilter-gui.exe "$HOME"/bin/ansifilter-gui.exe
        mv -f ansifilter.exe "$HOME"/bin/ansifilter.exe
        mv -f ansifilter-gui.exe "$HOME"/bin/ansifilter-gui.exe
    fi

    cd "$functionEntryPWD"



    cd "$functionEntryPWD"

    _cygwin_workaround_dev_stderr
	_custom_ubcp_prog "$@"
}
_custom_ubcp() {
    "$scriptAbsoluteLocation" _custom_ubcp_sequence "$@" 2>&1
}

