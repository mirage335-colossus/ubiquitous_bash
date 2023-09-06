
# echo -n | openssl dgst -whirlpool -binary - | xxd -p -c 256

# https://github.com/openssl/openssl/issues/10145#issuecomment-1054074144
# https://github.com/openssl/openssl/issues/5118#issuecomment-1707860097
# https://gist.github.com/rdh27785/97210d439a280063bd768006450c435d#file-openssl-cnf-diff
# https://gist.githubusercontent.com/rdh27785/97210d439a280063bd768006450c435d/raw/3789f079442d35c2ae2dc0ff06c314e7169adf7b/openssl.cnf.diff
# https://help.heroku.com/88GYDTB2/how-do-i-configure-openssl-to-allow-the-use-of-legacy-cryptographic-algorithms
# https://wiki.openssl.org/index.php/OpenSSL_3.0
_here_opensslConfig_legacy() {
	cat << 'CZXWXcRMTo8EmM8i4d'

openssl_conf = openssl_init

[openssl_init]
providers = provider_sect

[provider_sect]
default = default_sect
legacy = legacy_sect

[default_sect]
activate = 1

[legacy_sect]
activate = 1

CZXWXcRMTo8EmM8i4d
}
_custom_splice_opensslConfig() {
	#local functionEntryPWD
	#functionEntryPWD="$PWD"

	#cd /
	_here_opensslConfig_legacy | sudo -n tee /etc/ssl/openssl_legacy.cnf > /dev/null 2>&1

    if ! sudo -n grep 'openssl_legacy' /etc/ssl/openssl.cnf > /dev/null 2>&1
    then
        sudo -n cp -f /etc/ssl/openssl.cnf /etc/ssl/openssl.cnf.orig
        echo '


.include = /etc/ssl/openssl_legacy.cnf

' | sudo -n cat /etc/ssl/openssl.cnf.orig - | sudo -n tee /etc/ssl/openssl.cnf > /dev/null 2>&1
    fi

	#cd "$functionEntryPWD"
}



