#terraform

# https://en.wikipedia.org/wiki/Terraform_(software)
# https://www.terraform.io/docs/language/index.html
# https://learn.hashicorp.com/tutorials/terraform/install-cli?in=terraform/aws-get-started




_test_terraform() {
	_wantGetDep gpg
	_wantGetDep python3/dist-packages/softwareproperties/dbus/SoftwarePropertiesDBus.py
	_wantGetDep curl
	
	_wantGetDep terraform
	
	#! _typeDep terraform && echo 'warn: missing: terraform'
	if ! _typeDep terraform || ! terraform -help 2>/dev/null | grep 'terraform' > /dev/null 2>&1
	then
		echo 'warn: missing: terraform'
		return 1
	fi
	
	return 0
}
