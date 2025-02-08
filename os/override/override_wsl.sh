
# Discouraged. Few file paths, some setup, etc, may be different. Otherwise, WSL should not be treated differently.
_if_wsl() {
    uname -a | grep -i 'microsoft' > /dev/null 2>&1 || uname -a | grep -i 'WSL2' > /dev/null 2>&1
}

