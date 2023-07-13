

_vnchost-custom_kde() {
	"$scriptLib"/kit/install/cloud/cloud-init/zRotten/zMinimal/rotten_install.sh _custom_kde
	
}


_vnchost-setup-sddm() {
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
    Modes "1920x1200"
    EndSubSection
EndSection
CZXWXcRMTo8EmM8i4d


	cat << 'CZXWXcRMTo8EmM8i4d' | sudo -n tee -a /etc/pam.conf

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



_vnchost-setup() {
	_set_getMost_backend
	
	_getMost_backend apt-get update
	
	_getMost_backend_aptGetInstall xserver-xorg-video-dummy
	_getMost_backend_aptGetInstall sddm
	
	_getMost_backend_aptGetInstall plasma-desktop
	_getMost_backend_aptGetInstall lxde-core
	
	_getMost_backend_aptGetInstall tigervnc-viewer
	#_getMost_backend_aptGetInstall x11vnc
	_getMost_backend_aptGetInstall tigervnc-standalone-server
	_getMost_backend_aptGetInstall tigervnc-scraping-server
	
	
	_getMost_backend_aptGetInstall novnc
	_getMost_backend_aptGetInstall websockify
	
	
	
	#_vnchost-setup-sddm
	
	
	true
}


_vnchost_sequence() {
	#_mustBeRoot
	
	#sudo -n systemctl start sddm
	#systemctl start sddm
	#sudo -n service sddm start
	#service sddm start
	#service sddm status
	
	_findPort_vnc() {
		currentPort=51001
		echo "$currentPort"
	}
	
	_findPort_novnc() {
		currentPort_novnc=51002
		echo "$currentPort_novnc"
	}
	
	_prepare_vnc() {
		
		echo > "$vncPasswdFile".pln
		chmod 600 "$vncPasswdFile".pln
		_uid 8 > "$vncPasswdFile".pln
		
		export vncPort=$(_findPort_vnc)
		export vncPort_novnc=$(_findPort_novnc)
		
		export vncPIDfile="$safeTmp"/.vncpid
		export vncPIDfile_local="$safeTmp"/.vncpid
		
	}
	
	_start
	
	_prepare_vnc
	
	_vncpasswd
	
	_report_vncpasswd
	
	_messagePlain_request '____________________________________________________________'
	_messagePlain_request 'ubcp CLI (fast and convenient)'
	_messagePlain_request 'echo -n '$(cat "$vncPasswdFile".pln)' | _vncviewer localhost::'"$vncPort"
	_messagePlain_request '____________________________________________________________'
	_messagePlain_request 'Through Browser Port Forward (may be slow)'
	_messagePlain_request 'http://127.0.0.1:'"$vncPort_novnc"'/vnc.html?password='$(cat "$vncPasswdFile".pln)
	_messagePlain_request '____________________________________________________________'
	_messagePlain_request 'VSCode VNC Extension (fast and convenient)'
	_messagePlain_request 'localhost:'"$vncPort"'   password: '$(cat "$vncPasswdFile".pln)
	_messagePlain_request '____________________________________________________________'
	_messagePlain_request 'Through GitHub WebUI (may be slow)'
	_messagePlain_request 'https://'"$CODESPACE_NAME"'-'"$vncPort_novnc"'.preview.app.github.dev/vnc.html?password='$(cat "$vncPasswdFile".pln)
	_messagePlain_request '____________________________________________________________'
	_messagePlain_request 'KDE: Consider '"'"'_vnchost-custom_kde'"'"' for a preconfigured desktop UI.'
	sleep 1
	
	
	
	
	
	#_x11vnc_operations
	

	websockify -D --web=/usr/share/novnc/ --cert=/home/debian/novnc.pem "$vncPort_novnc" localhost:"$vncPort"
	_vncserver_operations
	#novnc --listen "$vncPort_novnc" --vnc localhost:"$vncPort"
	
	sleep 18000
	
	_stop
}

_vnchost() {
	#_mustGetSudo
	#sudo -n "$scriptAbsoluteLocation" _vnchost_sequence
	
	#export desktopEnvironmentLaunch="startlxde"
	export desktopEnvironmentLaunch="startplasma-x11"
	"$scriptAbsoluteLocation" _vnchost_sequence
}



