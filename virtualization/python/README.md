
Python specific application virtualization. At least preserves reinstallation independent of any unreliable upstream repositories.  

Platforms (ie. Cygwin/MSW, UNIX/Linux) normally use completely separate code paths for Python application virtualization, with separate directories (_lib/programName/venv_python_msw, _lib/programName/venv_python_nix, etc), backends, underlying directories.

Download, preservation, and reinstall of pacakges, should be kept available, if only as a fallback.

Python-only cases without 'compiled extension modules' may be simple enough to override the Python binary and otherwise re-use code and contained dependency files, however, this is unusual and should still include appropriate fallbacks if reasonable.



NEVER add any functions to these files that will effect any possibly conflicting global python change (eg. not precluding readline, but usually precluding more complicated or version specific dependencies)!



```bash
./ubiquitous_bash.sh _msw_python
```

```bash
pip list | cut -f1 -d\  | grep -v '^Package$' | grep -v '\------------------'
```






# Scrap




```
# ATTENTION: Override with 'return 0' to enable lean.py script generation.
# STRONGLY DISCOURAGED
_generate_lean-python_prog() {
	[[ "$objectName" == "ubiquitous_bash" ]] && return 0
	
	return 1
}
```

```bash
# lean.py ... is a template script from 'ubiquitous_bash' for lightweight manual changes
python "$scriptLib"/lean_custom.py '_bash(["-i"], True, "/cygdrive/c/core/infrastructure/ubiquitous_bash/lean.sh")'
python "$scriptLib"/lean_custom.py '_bin(["echo", "test"], True, "/cygdrive/c/core/infrastructure/ubiquitous_bash/lean.sh")'
```




huggingface-cli

abstractfs venv

pip freeze/download

ensure any portable venv does not...
find ~/.local/hf-env/lib/python3.11/site-packages -name '*.so'



two separate paths... the Cygwin/MSWindows path is totally separate



msi/exe installers

conda create/download-only
pip download

abstractfs conda (or venv)


```bash
# CAUTION: No. Don't do this. Should be better to override 'PATH' .
#_discoverResource-cygwinNative-ProgramFiles 'ykman' 'Yubico/YubiKey Manager' false
#[[ -e '/cygdrive/c/Program Files/Yubico/Yubico PIV Tool/bin/yubico-piv-tool.exe' ]] && _discoverResource-cygwinNative-ProgramFiles 'yubico-piv-tool' 'Yubico/Yubico PIV Tool/bin' false
#_discoverResource-cygwinNative-ProgramFiles 'qalc' 'Qalculate' false
#_discoverResource-cygwinNative-ProgramFiles 'vncviewer' 'TigerVNC' false '_workaround_cygwin_tmux '
#_discoverResource-cygwinNative-ProgramFiles 'kate' 'Kate/bin' false
#_at_userMSW_probeCmd_discoverResource-cygwinNative-ProgramFiles 'kate' 'Kate/bin' false > /dev/null 2>&1
```


```batch
set SKIP_VENV=1
```


# Reference

https://learn.microsoft.com/en-us/windows/ai/windows-ml/tutorials/pytorch-installation
https://pytorch.org/
 'NOTE: Conda packages are no longer available. Please use pip instead.'

https://www.python.org/downloads/windows/


https://pypi.org/project/accelerate/



https://cloudcone.com/docs/article/how-to-install-python-3-10-on-debian-11/
 ie. compile from source...

