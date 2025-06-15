


summary (possbily improved, possibly added to with AI generated content)





# Files

```
./shortcuts/git/_doc-wget_githubRelease.md
```

```
./shortcuts/git/wget_githubRelease_internal.sh
./shortcuts/git/wget_githubRelease_tag.sh
```









# Prompt - Call Graph







# Functions - Internal

```bash
_wget_githubRelease-stdout
_wget_githubRelease
_wget_githubRelease_internal
_wget_githubRelease_join

```



# Functions - Tag







# Explanation

join ... is what does the parallel downloading of multi-part files...
...




# Call Graph

    |___ 




# MultiThreading

## ./shortcuts/git/wget_githubRelease_internal.sh

Please generate a well ordered tabulated report with markdown tables readable at a glance instead of prose, code snippets, code references, etc, enumerating from the intended flow of action functions where processing of this code begins, Inter-Process-Communication:

- Inter-Process-Communication mechanisms.

- Inter-Process-Communication Files, Pipes, etc (existence/absence of produced asset files, PID files, lock files, *.busy , *.PASS , *.FAIL , etc)
- Inter-Process-Communication Conditions and Loops

- Inter-Process-Communication Operating-System latency margins.
- Inter-Process-Communication inappropriate esoteric resource locking (eg. backgrounded process grabbing tty), if any are plausible.

- Inter-Process-Communication concurrency collisions, if any are plausible.

```
./shortcuts/git/wget_githubRelease_internal.sh
```







# Pseudocode Summary - (MultiThreaded)

## ./shortcuts/git/wget_githubRelease_internal.sh

```bash
( set -o pipefail ; aria2c --disable-ipv6=false "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL" 2> >(tail -n 40 >&2) )
currentExitStatus_ipv6="$?"
( set -o pipefail ; aria2c --disable-ipv6=true "${current_axel_args[@]}" -d "$currentOutDir" -o "$currentOutFile_relative" "$currentURL" 2> >(tail -n 40 >&2) )
currentExitStatus_ipv4="$?"

outputLOOP:
while WAIT && ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).busy ]] || ( ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]] && ! [[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] )
dd if="$scriptAbsoluteFolder"/$(_axelTmp) bs=1M
[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).PASS ]] && currentSkip="download"
[[ -e "$scriptAbsoluteFolder"/$(_axelTmp).FAIL ]] && [[ "$currentSkip" != "skip" ]] && ( _messageError 'FAIL' >&2 ) > /dev/null && return 1
_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp)
_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).busy

downloadLOOP:
while WAIT && ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp) > /dev/null 2>&1 ) || ( ls -1 "$scriptAbsoluteFolder"/$(_axelTmp).busy > /dev/null 2>&1 )
_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).PASS
_destroy_lock "$scriptAbsoluteFolder"/$(_axelTmp).FAIL

_wget_githubRelease_procedure-join:
echo -n > "$currentAxelTmpFile".busy
_wget_githubRelease_procedure "$currentAbsoluteRepo" "$currentReleaseLabel" "$currentFile" -O "$currentAxelTmpFile" "$@"
[[ "$currentExitStatus" == "0" ]] && echo "$currentExitStatus" > "$currentAxelTmpFile".PASS
if [[ "$currentExitStatus" != "0" ]]
then
	echo -n > "$currentAxelTmpFile"
	echo "$currentExitStatus" > "$currentAxelTmpFile".FAIL
fi
while WAIT && [[ -e "$currentAxelTmpFile" ]] || [[ -e "$currentAxelTmpFile".busy ]] || [[ -e "$currentAxelTmpFile".PASS ]] || [[ -e "$currentAxelTmpFile".FAIL ]]
[[ "$currentAxelTmpFile" != "" ]] && _destroy_lock "$currentAxelTmpFile".*

```




# Scrap

export FORCE_AXEL="3"
export FORCE_PARALLEL="5"

./ubiquitous_bash.sh _get_ingredientVM "spring"

./ubiquitous_bash.sh _wget_githubRelease_join-stdout "soaringDistributions/ubDistBuild" "spring" "package_image.tar.flx" > _local/temp


