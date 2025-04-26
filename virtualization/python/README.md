
Python specific application virtualization. At least preserves reinstallation independent of any unreliable upstream repositories.  

Platforms (ie. Cygwin/MSW, UNIX/Linux) normally use completely separate code paths for Python application virtualization, with separate directories (_lib/programName/venv_python_msw, _lib/programName/venv_python_nix, etc), backends, underlying directories.

Download, preservation, and reinstall of pacakges, are kept available, if only as a fallback.


Should NEVER cause global python changes that cause dependency conflicts, etc. Usually adding 'readline', 'colorama', globally, to improve the python interactive prompt, etc, does not cause such issues.




All of the shellcode here is essentially proof that Python venv, Anaconda, etc, do NOT count as portable nor deployable nor convenient nor robust. Fragility and manual deployment are absolutely UNACCEPTABLE for keeping one of many tools in a toolchain working. No enterprise nor academic course should be comfortable with such fragility creep throughout entire toolchains as has been introduced by Python.






# Usage

```bash
export dependencies_nix_python=( "readline" )
export packages_nix_python=( "huggingface_hub[cli]" )

export dependencies_msw_python=( "pyreadline3" )
export packages_msw_python=( "huggingface_hub[cli]" )

export dependencies_cyg_python=( "readline" )
export packages_cyg_python=( "huggingface_hub[cli]" )

./ubiquitous_bash.sh _special_python

# NOT tested by '_test' by default due to only novel dependencies being possibly manual dependencies.
# Override with 'core.sh' or similar, and call with '_test_prog' or similar.
./ubiquitous_bash.sh _test_special_python
```




# Design

```bash
export dependencies_nix_python=( "readline" )
export packages_nix_python=( "huggingface_hub[cli]" )
./ubiquitous_bash.sh _nix_python

# NOT tested by '_test' by default due to only novel dependencies being possibly manual dependencies.
# Override with 'core.sh' or similar, and call with '_test_prog' or similar.
export dependencies_nix_python=( "readline" )
export packages_nix_python=( "huggingface_hub[cli]" )
./ubiquitous_bash.sh _test_nix_python
```

```bash
export dependencies_msw_python=( "pyreadline3" )
export packages_msw_python=( "huggingface_hub[cli]" )
./ubiquitous_bash.sh _msw_python

# NOT tested by '_test' by default due to only novel dependencies being possibly manual dependencies.
# Override with 'core.sh' or similar, and call with '_test_prog' or similar.
export dependencies_msw_python=( "pyreadline3" )
export packages_msw_python=( "huggingface_hub[cli]" )
./ubiquitous_bash.sh _test_msw_python
```

```bash
# Discouraged. May not be implemented. May be untested.
export dependencies_cyg_python=( "readline" )
export packages_cyg_python=( "huggingface_hub[cli]" )
./ubiquitous_bash.sh _cygwin_python

# NOT tested by '_test' by default due to only novel dependencies being possibly manual dependencies.
# Override with 'core.sh' or similar, and call with '_test_prog' or similar.
export dependencies_cyg_python=( "readline" )
export packages_cyg_python=( "huggingface_hub[cli]" )
./ubiquitous_bash.sh _test_cyg_python
```


MSW native Python will show errors with a request to install the appropriate Python installer if needed.
```bash
( _messagePlain_request 'request: install: https://www.python.org/ftp/python/3.10.11/python-3.10.11-amd64.exe' >&2 ) > /dev/null
```








# Scratch

```bash
sudo -n pip cache purge ; pip cache purge ; rm -r ./_local/python_nix ./_local/dumbpath.var ; ./ubiquitous_bash.sh _nix_python
```


# Listing venv Packages 

Usually best.
```bash
pip list | cut -f1 -d\  | grep -v '^Package$' | grep -v '\------------------'
```

Discouraged. If possible, newer package versions should be accepted automatically.
```bash
pip freeze
```


# Python-only Dependencies

Python-only dependencies, etc, without 'compiled extension modules' may be simple enough to override the Python binary and use the same Python script as-is, without this 'Python-specific application virtualization' 'wrapper scripting'.

If there are any '.so' files (or presumably, DLL, etc), etc, such an approach to portability with Python will fail.

```bash
find ~/.local/hf-env/lib/python3.11/site-packages -name '*.so'
```


# abstractfs

Discouraged - abstractfs can keep Python absolute paths consistent, but simply making Python installations, venv, etc, actually portable in this way at least requires that all dependencies are Python-only.

```bash
# Rough example from  'mirage335/quickWriter' '_prog/hardware/escpos.sh'  , created before availability of better 'Python-specific application virtualization' 'wrapper scripting'.
source "$scriptLib"/escpos-python/venv_python/bin/activate
#...
cd "$scriptLib"/escpos-python
#...
"$scriptAbsoluteLocation" _abstractfs "$scriptLib"/escpos-python/print.py '_interact_escpos("'"$current_LinePrinter_devfile"'", '"$current_LinePrinter_baud"')'
```


# batch file Python portability

VERY STRONGLY DISCOURAGED! Sometimes batch files have apparently been used to contain Python installations portably. However, this is NOT PORTABLE, and will break as soon as upstream availability breaks for any reason - anything transfer of the files through a non-NTFS filesystem, possibly also any outside of a native MSW environment - will require re-download of all Python packages. There are other pitfalls as well, such as "%~dp0" batch syntax being much less resilient in less usual situations, limitations in batch file parameter count, other batch issues, a very reasonable expectation of extra nuances copying non-embeddable Python installations this way, and the possiibility of Python changing slightly enough to break this trick.

Such a trick is only convenient to the extent its fragility has not permantently broken the application yet.

UNACCEPTABLE for keeping one of many tools in a toolchain working.


```batch
set SKIP_VENV=1
```






# Scrap


```bash
# ATTENTION: Override with 'return 0' to enable lean.py script generation.
# STRONGLY DISCOURAGED
_generate_lean-python_prog() {
	[[ "$objectName" == "ubiquitous_bash" ]] && return 0
	
	return 1
}
```








# Reference

https://learn.microsoft.com/en-us/windows/ai/windows-ml/tutorials/pytorch-installation
https://pytorch.org/
 'NOTE: Conda packages are no longer available. Please use pip instead.'

https://www.python.org/downloads/windows/


https://pypi.org/project/accelerate/



https://cloudcone.com/docs/article/how-to-install-python-3-10-on-debian-11/
 ie. compile from source...

