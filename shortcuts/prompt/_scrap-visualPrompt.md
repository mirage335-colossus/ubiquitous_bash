

```bash
	#
	# Convert desired RGB values to 8-bit using AI LLM per a table .
	# https://en.wikipedia.org/wiki/ANSI_escape_code#8-bit
	#
	# Consider the neutral, white, and most obnoxious color (usually the error color red).
	# Set Luma/Chroma, to match usual stock neutral color, white slightly brighter.
	# Then set obnoxious color Luma/Chroma at slightly lower than sufficient darkness/saturation to clearly distinguish the color.
	# Rotate a color wheel (eg. GIMP) to get the other colors.
	# Rotate color wheel slightly towards the direction of preferred approximation.
	#
	# Neutral - Luma 77, Chroma 0, R75 G75 B75 - bfbfbf
	# White (path) - Luma <83, Chroma 0, R81, G81, B81 - cfcfcf
	#
	# Blue (punctuation) - 7c7fb7
	#
	# *Red (exit status, chroot) - Luma 58, Chroma 25 - b77c7d
	#
	# Orange (user) - b7977c
	#
	# Green (hostname, wsl) - 7cb77d
	#
	# Magenta (date, venv) - b77cb6
	#
	# Cyan (punctuation) - 7cb4b7
```







```
	# Neutral - Luma 77, Chroma 0, R75 G75 B75 - bfbfbf
	# White (path) - Luma <83, Chroma 0, R81, G81, B81 - cfcfcf
	#
	# Blue (punctuation) - 7c7fb7
	#
	# *Red (exit status, chroot) - Luma 58, Chroma 25 - b77c7d
	#
	# Orange (user) - b7977c
	#
	# Green (hostname, wsl) - 7cb77d
	#
	# Magenta (date, venv) - b77cb6
	#
	# Cyan (punctuation) - 7cb4b7
```

```bash
clear ; echo -e "\
\033[1;48;5;16m\033[38;5;103m|\033[38;5;138m0:(exampleChroot)\
\033[38;5;137muser\033[38;5;108m@exampleHost\
\033[38;5;103m)\033[38;5;250m-cloudNet(\
\033[38;5;139mvenv\033[38;5;103m)|\033[0mINFO\n\
\033[1;48;5;16m\033[38;5;252m/home/user\033[0m\n\
\033[38;5;103m|1 \033[38;5;109m> \033[0m" ; sleep infinity
```








	# White (path)
	# 37m
	# 253m
	#--- find: \[\033[37m\]
	#+++ replace: \[\033[37m\033[38;5;253m\]
	#
	# Blue (punctuation)
	# 34m
	# 103m
	#
	# *Red (exit status, chroot)
	# 31m
	# 138m
	#
	# Green (hostname, wsl)
	# 32m
	# 108m
	#
	# Magenta (date, venv)
	# 35m
	# 141m
	#
	# Cyan (punctuation)
	# 36m
	# 109m




