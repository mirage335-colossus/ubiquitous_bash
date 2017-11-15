_buildHello() {
	local helloSourceCode
	helloSourceCode=$(find "$scriptAbsoluteFolder" -type f -name "hello.c" | head -n 1)
	
	mkdir -p "$scriptBin"
	gcc -o "$scriptBin"/hello -static -nostartfiles "$helloSourceCode"
}
