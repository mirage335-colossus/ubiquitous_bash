#Example only.
_here_ssh_config() {
	cat << CZXWXcRMTo8EmM8i4d

Host *-$netName*
	Compression yes
	ExitOnForwardFailure yes
	ConnectTimeout 72
	ConnectionAttempts 1
	ServerAliveInterval 5
	ServerAliveCountMax 5
	#PubkeyAuthentication yes
	#PasswordAuthentication no
	StrictHostKeyChecking no
	UserKnownHostsFile "$sshLocalSSH/known_hosts"
	IdentityFile "$sshLocalSSH/id_rsa"
	
	Cipher aes256-gcm@openssh.com
	Ciphers aes256-gcm@openssh.com,aes128-ctr,aes192-ctr,aes256-ctr,arcfour256,arcfour128,aes128-gcm@openssh.com,chacha20-poly1305@openssh.com,aes128-cbc,3des-cbc,blowfish-cbc,cast128-cbc,aes192-cbc,aes256-cbc,arcfour

Host machine-$netName
	User user
	ProxyCommand "$sshDir/cautossh" _ssh_proxy_machine-$netName


CZXWXcRMTo8EmM8i4d
}
