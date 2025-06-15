
`virtualization/python/override_nix_python.sh`

Functions used to virtualize/contain Python running under UNIX/Linux in the "ubiquitous_bash" framework.

Prepares a UNIX/Linux specific Python environment, configures PYTHONSTARTUP hooks, manages a local virtual environment, and (re)installs packages or "morsels" (pre-downloaded pip wheels) if necessary (ie. if absolute path has changed). If a selected or desired Python version is not installed, '_getDep', '_wantGetDep', etc, or a '_messagePlain_request' to the user can be called .

Script provides helper functions for interactive shells (_nix_python, _nix_python_bash, _nix_python_bin), environment preparation (_prepare_nix_python, _set_msw_python_procedure), package installation, and (optionally) can be extended to detect alternative UNIX/Linux Python paths. As these example functions show, this approach stabilizes consistent interaction using UNIX/Linux Python, portably, inside a broader cross-platform ecosystem.



# Files

```
./virtualization/python/override_nix_python.sh
```



# Call Graph

- `_nix_python`
    - `_prepare_nix_python`
        - `_prepare_nix_python_3`
            - `_set_nix_python_3`
                - `_set_nix_python_procedure`
            - `_write_python_hook_local`
                - `_setupUbiquitous_accessories_here-python_hook`
            - `_lock_prepare_python_nix`
            - `_prepare_nix_python_procedure`
                - `_install_dependencies_nix_python_procedure-specific`
                    - `_discover-nix_python`
                        - `_discover_procedure-nix_python`
                    - `_pip_upgrade`
                    - `_pip_download`
                    - `_pip_install_nonet`
                        - `_special_nix_pip_install_nonet_sequence`
                    - `_pip_install`
            - `_morsels_nix_pip_python_3`
    - `python lean.py -> _bin -> _demo_nix_python`
        - `_bash`
        
- `_test_nix_python`
    - `_prepare_nix_python` -> `_prepare_nix_python_3` ...

- `_install_dependencies_nix_python`
  - `_install_dependencies_nix_python_sequence-specific`
    - `_set_nix_python_3`
      - `_set_nix_python_procedure`
    - `_install_dependencies_nix_python_procedure-specific` (see above)

- `_set_nix_python`
  - `_set_nix_python_3`
    - `_set_nix_python_procedure`

- `_demo_nix_python`
  - (`call given command`)
  - `_bash`



# Pseudocode Summary 

Pseudocode summary for the comparable MSW case is available. Please see:

```
./virtualization/python/_doc-override_msw_python.md
```











