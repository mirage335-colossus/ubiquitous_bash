# Echo highest glibc version needed by the executable files in the current directory
_glibc_needed() {
	find . -name *.so -or -name *.so.* -or -type f -executable  -exec readelf -s '{}' 2>/dev/null \; | sed -n 's/.*@GLIBC_//p'| awk '{print $1}' | sort --version-sort | tail -n 1
}
alias glibc_needed='_glibc_needed'
