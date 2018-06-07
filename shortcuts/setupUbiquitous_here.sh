_setupUbiquitous_here() {
	cat << CZXWXcRMTo8EmM8i4d
export profileScriptLocation="$ubcoreUBdir"/ubiquitous_bash.sh
export profileScriptFolder="$ubcoreUBdir"
[[ "$scriptAbsoluteLocation" == "" ]] && . "$ubcoreUBdir"/ubiquitous_bash.sh --profile _importShortcuts
[[ "$scriptAbsoluteLocation" != "" ]] && . "$scriptAbsoluteLocation" --parent _importShortcuts
CZXWXcRMTo8EmM8i4d
}
