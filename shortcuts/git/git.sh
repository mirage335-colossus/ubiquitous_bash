_gitNew() {
	git init
	git add .
	git commit -a -m "first commit"
}

_gitCheck() {
	find . -name .git -type d -exec bash -c 'echo ----- $(basename $(dirname $(realpath {}))) ; cd $(dirname $(realpath {})) ; git status' \;
}

_gitImport() {
	cd "$scriptFolder"
	
	mkdir -p "$1"
	cd "$1"
	shift
	git clone "$@"
	
	cd "$scriptFolder"
}

# DANGER
#Removes all but the .git folder from the working directory.
#_gitFresh() {
#	find . -not -path '\.\/\.git*' -delete
#}

