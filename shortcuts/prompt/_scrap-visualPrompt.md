
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




