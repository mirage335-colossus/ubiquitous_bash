_here_systemd_shutdown_action() {

cat << 'CZXWXcRMTo8EmM8i4d'
[Unit]
Description=...

[Service]
Type=oneshot
RemainAfterExit=true
CZXWXcRMTo8EmM8i4d

echo ExecStop="$scriptAbsoluteLocation" "$@"

cat << 'CZXWXcRMTo8EmM8i4d'

[Install]
WantedBy=multi-user.target
CZXWXcRMTo8EmM8i4d

}

_here_systemd_shutdown() {

cat << 'CZXWXcRMTo8EmM8i4d'
[Unit]
Description=...

[Service]
Type=oneshot
RemainAfterExit=true
CZXWXcRMTo8EmM8i4d

echo ExecStop="$scriptAbsoluteLocation" _sigEmergencyStop "$safeTmp"/.pid "$sessionid"

cat << 'CZXWXcRMTo8EmM8i4d'

[Install]
WantedBy=multi-user.target
CZXWXcRMTo8EmM8i4d

}
