_buildHello() {
	local helloSourceCode
	helloSourceCode="$scriptAbsoluteFolder"/generic/hello/hello.c
	! [[ -e "$helloSourceCode" ]] && helloSourceCode="$scriptLib"/ubiquitous_bash/generic/hello/hello.c
	
	mkdir -p "$scriptBin"
	gcc -o "$scriptBin"/hello -static -nostartfiles "$helloSourceCode"
}
