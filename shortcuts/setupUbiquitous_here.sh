_setupUbiquitous_here() {
	cat << CZXWXcRMTo8EmM8i4d
export profileScriptLocation="$ubcoreUBdir"/ubiquitous_bash.sh
export profileScriptFolder="$ubcoreUBdir"
[[ "\$scriptAbsoluteLocation" != "" ]] && . "\$scriptAbsoluteLocation" --parent _importShortcuts
[[ "\$scriptAbsoluteLocation" == "" ]] && . "\$profileScriptLocation" --profile _importShortcuts
true
CZXWXcRMTo8EmM8i4d
}
