
_vnchost-setup() {
	
	_getMost_backend_aptGetInstall xserver-xorg-video-dummy
	_getMost_backend_aptGetInstall sddm
	
	_getMost_backend_aptGetInstall tigervnc-viewer
	#_getMost_backend_aptGetInstall x11vnc
	_getMost_backend_aptGetInstall tigervnc-standalone-server
	_getMost_backend_aptGetInstall tigervnc-scraping-server
	
	sudo -n mv /etc/X11/xorg.conf /etc/X11/xorg.conf.bak_$(uid _8)
	cat << 'CZXWXcRMTo8EmM8i4d' | sudo -n tee /etc/X11/xorg.conf
Section "Device"
    Identifier  "Configured Video Device"
    Driver      "dummy"
    # Default is 4MiB, this sets it to 16MiB
    VideoRam    16384
EndSection

Section "Monitor"
    Identifier  "Configured Monitor"
    HorizSync 31.5-48.5
    VertRefresh 50-70
EndSection

Section "Screen"
    Identifier  "Default Screen"
    Monitor     "Configured Monitor"
    Device      "Configured Video Device"
    DefaultDepth 24
    SubSection "Display"
    Depth 24
    Modes "1920x1080"
    EndSubSection
EndSection
CZXWXcRMTo8EmM8i4d

	cat << 'CZXWXcRMTo8EmM8i4d' | sudo -n tee -a /etc/pam.d/sddm

auth        sufficient  pam_succeed_if.so user ingroup nopasswdlogin
auth        include     system-login

CZXWXcRMTo8EmM8i4d
	
	sudo -n usermod -a -G nopasswdlogin user
	sudo -n usermod -a -G nopasswdlogin codespace
	
	sudo -n systemctl restart sddm
	systemctl restart sddm
	sudo -n service sddm restart
	service sddm restart
	service sddm status
}


_vnchost_sequence() {
	_mustBeRoot
	
	sudo -n systemctl start sddm
	systemctl start sddm
	sudo -n service sddm start
	service sddm start
	service sddm status

	_findPort_vnc() {
		currentPort=51001
		echo "$currentPort"
	}

	_start

	_prepare_vnc

	_vncpasswd

	_report_vncpasswd

	_messagePlain_request '____________________________________________________________'
	_messagePlain_request 'echo -n '$(cat "$vncPasswdFile".pln)' | _vncviewer localhost::'$(_findPort_vnc)
	_messagePlain_request '____________________________________________________________'
	sleep 1


	_x11vnc_operations

	_stop
}

_vnchost() {
	_mustGetSudo
	sudo -n "$scriptAbsoluteLocation" _vnchost_sequence
}



