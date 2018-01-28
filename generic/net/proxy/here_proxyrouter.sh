_here_proxyrouter_sshconfig_header() {
	cat << 'CZXWXcRMTo8EmM8i4d'
CanonicalizeHostname yes

Host *.onion
	VerifyHostKeyDNS no
	ProxyCommand nc -x localhost:9050 -X 5 %h %p

CZXWXcRMTo8EmM8i4d
}
