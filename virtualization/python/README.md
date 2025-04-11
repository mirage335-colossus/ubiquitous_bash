
Python specific application virtualization. At least preserves reinstallation independent of any unreliable upstream repositories.  

Platforms (ie. Cygwin/MSW, UNIX/Linux) normally use completely separate code paths for Python application virtualization, with separate directories (_lib/programName/venv_python_msw, _lib/programName/venv_python_nix, etc), backends, underlying directories.

Download, preservation, and reinstall of pacakges, should be kept available, if only as a fallback.

Python-only cases without 'compiled extension modules' may be simple enough to override the Python binary and otherwise re-use code and contained dependency files, however, this is unusual and should still include appropriate fallbacks if reasonable.




# Scrap


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









