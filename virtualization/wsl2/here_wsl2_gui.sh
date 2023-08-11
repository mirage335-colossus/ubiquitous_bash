
_here_wsl_qt5ct_conf() {
    cat << 'CZXWXcRMTo8EmM8i4d'

[Appearance]
color_scheme_path=/usr/share/qt5ct/colors/airy.conf
custom_palette=false
icon_theme=breeze-dark
standard_dialogs=default
style=Breeze

[Interface]
activate_item_on_single_click=1
buttonbox_layout=0
cursor_flash_time=1000
dialog_buttons_have_icons=1
double_click_interval=400
gui_effects=@Invalid()
keyboard_scheme=2
menus_have_icons=true
show_shortcuts_in_context_menus=true
stylesheets=@Invalid()
toolbutton_style=4
underline_shortcut=1
wheel_scroll_lines=3

[Troubleshooting]
force_raster_widgets=1
ignored_applications=@Invalid()

CZXWXcRMTo8EmM8i4d
}

_write_wsl_qt5ct_conf() {
    if [[ "$HOME" == "/root" ]] || [[ $(id -u) == 0 ]]
    then
        return 1
    fi

    local currentHome
    currentHome="$HOME"
    [[ "$currentHome" == "/root" ]] && currentHome="/home/user"
    [[ "$1" != "" ]] && currentHome="$1"

    [[ -e "$currentHome"/.config/qt5ct/qt5ct.conf ]] && return 0
    
    mkdir -p "$currentHome"/.config/qt5ct
    mkdir -p "$currentHome"/.config/qt5ct/colors
    mkdir -p "$currentHome"/.config/qt5ct/qss
    
    _here_wsl_qt5ct_conf > "$currentHome"/.config/qt5ct/qt5ct.conf

    [[ -e "$currentHome"/.config/qt5ct/qt5ct.conf ]] && return 0

    return 1
}

# WARNING: Experimental. Installer use only. May cause issues with applications running natively from the MSW side. Fortunately, it seems QT_QPA_PLATFORMTHEME is ignored if qt5ct is not present, as expected in the case of 'native' QT MSW applications.
_write_msw_qt5ct() {
    _messagePlain_request 'request: If the value of system variable WSLENV is important to you, the previous value is noted here.'
    _messagePlain_probe_var WSLENV
    
    setx QT_QPA_PLATFORMTHEME qt5ct /m
    setx WSLENV QT_QPA_PLATFORMTHEME /m
}
