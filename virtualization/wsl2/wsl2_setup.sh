
if false
then

# Experiment - boot .

netsh interface portproxy delete v4tov4 listenport=11434 listenaddress=$(wsl -d ubdist cat /net-hostip)
netsh interface portproxy delete v4tov4 listenport=11434 listenaddress=0.0.0.0
netsh interface portproxy show v4tov4

wsl -d "ubdist" sudo -n systemctl disable hostport-proxy.service
wsl -d "ubdist" sudo -n systemctl disable ollama.service





# Experiment - run .

wsl -d ubdist wget --timeout=1 --tries=3 'http://127.0.0.1:11434' -q -O -
netsh interface portproxy show v4tov4

netsh interface portproxy delete v4tov4 listenport=11434 listenaddress=$(wsl -d ubdist cat /net-hostip)
netsh interface portproxy delete v4tov4 listenport=11434 listenaddress=0.0.0.0
netsh interface portproxy show v4tov4

wsl -d ubdist wget --timeout=1 --tries=3 'http://127.0.0.1:11434' -q -O -

cd /cygdrive/c/q/p/zCore/infrastructure/ubiquitous_bash
./ubiquitous_bash.sh _setup_wsl2_procedure-fw
./ubiquitous_bash.sh _setup_wsl2_procedure-portproxy
./ubiquitous_bash.sh _setup_wsl2_guest-portForward

netsh interface portproxy add v4tov4 listenport=11434 listenaddress=0.0.0.0 connectport=11434 connectaddress=127.0.0.1
netsh interface portproxy show v4tov4

sc.exe query iphlpsvc
netstat -ano | findstr :11434
wget --timeout=1 --tries=3 'http://127.0.0.1:11434' -q -O -

wsl -d ubdist wget --timeout=1 --tries=3 'http://127.0.0.1:11434' -q -O -
wsl -d ubdist cat /net-hostip ; wsl -d ubdist wget --timeout=1 --tries=3 'http://'$(wsl -d ubdist cat /net-hostip)':11434' -q -O -



# Scrap

wsl -d "ubdist" sudo -n systemctl daemon-reload
#wsl -d "ubdist" sudo -n systemctl enable --now hostport-proxy.service

wsl -d "ubdist" sudo -n systemctl disable hostport-proxy.service

wsl -d "ubdist" sudo -n systemctl restart hostport-proxy.service





#_setup_wsl2


fi



_setup_wsl2_guest-portForward() {
    _messagePlain_nominal 'setup: guest: portForward'

    local current_wsldist
    current_wsldist="$1"
    [[ "$current_wsldist" == "" ]] && current_wsldist="ubdist"

    echo "$current_wsldist"

    local current_wsl_scriptAbsoluteLocation
    current_wsl_scriptAbsoluteLocation=$(cygpath -m "$scriptAbsoluteLocation")
    current_wsl_scriptAbsoluteLocation=$(wsl -d "$current_wsldist" wslpath "$current_wsl_scriptAbsoluteLocation")

    _messagePlain_probe '_getDep socat'
    wsl -d "$current_wsldist" "$current_wsl_scriptAbsoluteLocation" _getDep socat

    # ATTRIBUTION-AI: ChatGPT o3  2025-06-01  (partially)


    _messagePlain_probe 'write: /usr/local/bin/hostport-proxy.sh'
    cat << 'CZXWXcRMTo8EmM8i4d' | wsl -d "$current_wsldist" sudo -n tee /usr/local/bin/hostport-proxy.sh > /dev/null
#!/usr/bin/env bash
set -euo pipefail

PORT=${PORT:-11434}               # default; override in the service if you like
HOST_IP_FILE="/net-hostip"

while true; do
  # Bail out quickly if the helper file doesn't exist (yet)
  [[ -r "$HOST_IP_FILE" ]] || { sleep 2; continue; }

  HOST_IP=$(<"$HOST_IP_FILE")
  [[ -n "$HOST_IP" ]] || { sleep 2; continue; }

  echo "$(date '+%F %T') 127.0.0.1:$PORT → $HOST_IP:$PORT"
  # --fork lets a single socat instance serve many clients in parallel
  socat TCP-LISTEN:"$PORT",fork,reuseaddr TCP4:"$HOST_IP":"$PORT" || true
  # If socat exits (network flap, etc.) loop and start again
  sleep 1
done
CZXWXcRMTo8EmM8i4d
    wsl -d "$current_wsldist" sudo -n chmod +x /usr/local/bin/hostport-proxy.sh
    #wsl -d "$current_wsldist" sudo -n cat /usr/local/bin/hostport-proxy.sh


    #_messagePlain_probe 'write: /etc/wsl.conf'
    # "$current_wsldist" /etc/wsl.conf already enables systemd by default
    #_here_wsl_conf
    #printf "[boot]\nsystemd=true\n" | sudo tee /etc/wsl.conf
    ## then from Windows:
    #wsl --shutdown <your-distro>


    _messagePlain_probe 'write: /etc/systemd/system/hostport-proxy.service'
    cat << 'CZXWXcRMTo8EmM8i4d' | wsl -d "$current_wsldist" sudo -n tee /etc/systemd/system/hostport-proxy.service > /dev/null
[Unit]
Description=Forward 127.0.0.1:11434 to Windows host (WSL2)
After=network-online.target
Wants=network-online.target

[Service]
Type=simple
Environment=PORT=11434      # edit or duplicate the unit to forward more ports
ExecStart=/usr/local/bin/hostport-proxy.sh
Restart=always
RestartSec=1

# Hardening (optional but nice)
NoNewPrivileges=true
ProtectSystem=full
ProtectHome=true
PrivateTmp=true

[Install]
WantedBy=multi-user.target

CZXWXcRMTo8EmM8i4d
    #wsl -d "$current_wsldist" sudo -n cat /etc/systemd/system/hostport-proxy.service

    _messagePlain_probe 'systemctl'
    wsl -d "$current_wsldist" sudo -n systemctl daemon-reload
    #wsl -d "$current_wsldist" sudo -n systemctl enable --now hostport-proxy.service

    wsl -d "$current_wsldist" sudo -n systemctl disable hostport-proxy.service

    wsl -d "$current_wsldist" sudo -n systemctl restart hostport-proxy.service

}











_setup_wsl2_procedure-fw() {
    _messagePlain_nominal 'setup: write: fw'

    #_powershell
    #powershell
    #powershell.exe
    
    # ATTRIBUTION-AI: ChatGPT o3 Deep Research  2025-06-01
    cat << 'CZXWXcRMTo8EmM8i4d' > /dev/null 2>&1
New-NetFirewallRule -Name "AllowWSL2-11434" -DisplayName "Allow WSL2 Port 11434 (TCP)" `
    -Description "Allows inbound TCP port 11434 from WSL2 virtual network only (for NAT port proxy)" `
    -Protocol TCP -Direction Inbound -Action Allow -LocalPort 11434 `
    -InterfaceAlias "vEthernet (WSL)"
CZXWXcRMTo8EmM8i4d

    # ATTRIBUTION-AI: ChatGPT o4-mini  2025-06-01
    # ATTRIBUTION-AI: Llama 3.1 Nemotron Ultra 253b v1  2025-06-01  (translation to one-liner)
    powershell -Command "Remove-NetFirewallRule -Name 'AllowWSL2-11434 - vEthernet (WSL (Hyper-V firewall))'; Remove-NetFirewallRule -Name 'AllowWSL2-11434 - vEthernet (Default Switch)'; Remove-NetFirewallRule -Name 'AllowWSL2-11434 - vEthernet (WSL)'"
    powershell -Command "Get-NetFirewallRule -Name 'AllowWSL2-11434*' | Remove-NetFirewallRule"
    #
    # DUBIOUS
    #netsh advfirewall firewall delete rule name="AllowWSL2-11434 - vEthernet (WSL (Hyper-V firewall))"
    #netsh advfirewall firewall delete rule name="AllowWSL2-11434 - vEthernet (Default Switch)"
    #netsh advfirewall firewall delete rule name="AllowWSL2-11434 - vEthernet (WSL)"

    # ATTRIBUTION-AI: Llama 3.1 Nemotron Ultra 253b v1  2025-06-01  (translation from PowerShell interactive terminal to powershell command call under Cygwin/MSW bash shell)
    # ATTENTION: Not all of these named interfaces usually exist. Cosmetic errors usually occur.
    powershell -Command "New-NetFirewallRule -Name 'AllowWSL2-11434 - vEthernet (WSL (Hyper-V firewall))' -DisplayName 'Allow WSL2 Port 11434 (TCP) - vEthernet (WSL (Hyper-V firewall))' -Description 'Allows inbound TCP port 11434 from WSL2 virtual network only (for NAT port proxy)' -Protocol TCP -Direction Inbound -Action Allow -LocalPort 11434 -InterfaceAlias 'vEthernet (WSL (Hyper-V firewall))'"
    powershell -Command "New-NetFirewallRule -Name 'AllowWSL2-11434 - vEthernet (Default Switch)' -DisplayName 'Allow WSL2 Port 11434 (TCP) - vEthernet (Default Switch)' -Description 'Allows inbound TCP port 11434 from WSL2 virtual network only (for NAT port proxy)' -Protocol TCP -Direction Inbound -Action Allow -LocalPort 11434 -InterfaceAlias 'vEthernet (Default Switch)'"
    powershell -Command "New-NetFirewallRule -Name 'AllowWSL2-11434 - vEthernet (WSL)' -DisplayName 'Allow WSL2 Port 11434 (TCP) - vEthernet (WSL)' -Description 'Allows inbound TCP port 11434 from WSL2 virtual network only (for NAT port proxy)' -Protocol TCP -Direction Inbound -Action Allow -LocalPort 11434 -InterfaceAlias 'vEthernet (WSL)'"

    powershell -Command "New-NetFirewallRule -Name 'AllowWSL2-11434 - InterfaceType' -InterfaceType HyperV -Direction Inbound -LocalPort 11434 -Protocol TCP -Action Allow"
    
}

# ATTENTION: NOTICE: Add to 'startup' of MSWindows host, etc, if necessary.
_setup_wsl2_procedure-portproxy() {
    _messagePlain_nominal 'setup: write: portproxy'

    local current_wsldist
    current_wsldist="$1"
    [[ "$current_wsldist" == "" ]] && current_wsldist="ubdist"

    echo "$current_wsldist"

    wsl -d "$current_wsldist" -u root -- sh -c "rm -f /net-hostip"

    # ATTRIBUTION-AI: Llama 3.1 Nemotron Ultra 253b v1  2025-06-01
    powershell.exe -Command - <<CZXWXcRMTo8EmM8i4d
    # ATTRIBUTION-AI: ChatGPT o3 Deep Research  2025-06-01  (partially)
    # Ensure running as Admin for registry and netsh access if needed.
    # Step 1: Try reading WSL NAT info from registry (requires recent WSL).
    \$wslKey = 'HKLM:\SOFTWARE\Microsoft\Windows\CurrentVersion\Lxss'
    try {
        \$reg = Get-ItemProperty -Path \$wslKey -ErrorAction Stop
        \$HostIP = \$reg.NatGatewayIpAddress
    } catch {
        \$HostIP = \$null
    }

    # Step 2: If not found in registry, use WSL to query the default gateway.
    if (-not \$HostIP) {
        try {
            \$routeInfo = wsl -e sh -c "ip route show default 2>/dev/null || route -n"
        } catch {
            \$routeInfo = ""
        }
        if (\$routeInfo) {
            if (\$routeInfo -match 'default via\s+([0-9\.]+)') {
                \$HostIP = \$Matches[1]
            } elseif (\$routeInfo -match '0\.0\.0\.0\s+0\.0\.0\.0\s+([0-9\.]+)') {
                \$HostIP = \$Matches[1]
            }
        }
    }

    # Step 3: If still not found, fall back to scanning network adapters.
    if (-not \$HostIP) {
        \$allIPs = Get-NetIPAddress -AddressFamily IPv4 | Where-Object { 
            \$_.IPAddress -notlike '127.*' -and \$_.IPAddress -notlike '169.254*' 
        }
        \$wslAdapterIP = \$allIPs | Where-Object { \$_.InterfaceAlias -match 'WSL' } | Select-Object -First 1
        if (\$wslAdapterIP) {
            \$HostIP = \$wslAdapterIP.IPAddress
        } else {
            \$defSwitchIP = \$allIPs | Where-Object { \$_.InterfaceAlias -match 'Default Switch' } | Select-Object -First 1
            if (\$defSwitchIP) {
                \$HostIP = \$defSwitchIP.IPAddress
            } else {
                \$hvAdapters = Get-NetAdapter | Where-Object { 
                    \$_.InterfaceDescription -like '*Hyper-V Virtual Ethernet*' -and \$_.Status -eq 'Up' 
                }
                foreach (\$adapter in \$hvAdapters) {
                    \$ip = \$allIPs | Where-Object { 
                        \$_.InterfaceIndex -eq \$adapter.InterfaceIndex -and 
                        \$_.IPAddress -match '^(10\.|172\.(1[6-9]|2\d|3[0-1])\.|192\.168\.)' 
                    }
                    if (\$ip) {
                        \$HostIP = \$ip.IPAddress
                        break
                    }
                }
            }
        }
    }

    # Step 4: Output result or error.
    if (\$HostIP) {
        Write-Output \$HostIP
    } else {
        Write-Error "WSL2 host IP could not be determined. Ensure WSL2 is installed and running (NAT mode)."
    }

    
    #netsh interface portproxy delete v4tov4 listenport=11434
    #netsh interface portproxy delete v4tov4 listenport=11434 listenaddress=\$HostIP
    #netsh interface portproxy add v4tov4 listenaddress=\$HostIP listenport=11434 connectaddress=127.0.0.1 connectport=11434
    #sc query iphlpsvc
    #sc start iphlpsvc
    #netsh interface portproxy show v4tov4


    # ATTRIBUTION-AI: ChatGPT o3  2025-06-01
    # --- Native tools -------------------------------------------------
    \$netsh = "\$env:SystemRoot\System32\netsh.exe"   # avoids “nets” typo
    \$sc    = "\$env:SystemRoot\System32\sc.exe"      # avoids Set-Content alias

    # make sure the helper service is running
    & \$sc   query iphlpsvc
    & \$sc   start iphlpsvc

    \$delArgs = @(
    'interface','portproxy','delete','v4tov4',
    "listenaddress=\$HostIP",
    'listenport=11434'
    )
    & \$netsh  @delArgs  2>\$null   # suppress harmless “not found”

    # (re-)create the port-proxy rule
    \$addArgs = @(
    'interface','portproxy','add','v4tov4',
    "listenaddress=\$HostIP",
    'listenport=11434',
    'connectaddress=127.0.0.1',
    'connectport=11434'
    )
    & \$netsh  @addArgs          # ← “@” splats the array as arguments

    # show the table so you can verify
    & \$netsh  interface portproxy show v4tov4



    # ATTRIBUTION-AI: Llama 3.1 Nemotron Ultra 253b v1  2025-06-01
    # Step 5: Output result or error.
    if (\$HostIP) {
        #Write-Output \$HostIP
        # Write \$HostIP to /net-hostip in WSL
        wsl -d "$current_wsldist" -u root -- sh -c "echo '\$(\$HostIP)' > /net-hostip"
    } else {
        wsl -d "$current_wsldist" -u root -- sh -c "echo '...' > /net-hostip"
    }

CZXWXcRMTo8EmM8i4d

    sleep 3
}










# End user function .
_setup_wsl2_procedure() {
    ! _if_cygwin && _messagePlain_bad 'fail: Cygwin/MSW only' && return 1
    
    _messageNormal 'init: _setup_wsl2'
    
    _messagePlain_nominal 'setup: write: _write_msw_WSLENV'
    _write_msw_WSLENV

    _messagePlain_nominal 'setup: write: _write_msw_wslconfig'
    _write_wslconfig "ub_ignore_kernel_wsl"

    _messagePlain_nominal 'setup: wsl2'
    
    # https://www.omgubuntu.co.uk/how-to-install-wsl2-on-windows-10
    
    _messagePlain_probe dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
    dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart

    _messagePlain_probe dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
    dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart

    _messagePlain_probe wsl --set-default-version 2
    wsl --set-default-version 2

    _messagePlain_probe wsl --update
    wsl --update

    _messagePlain_probe wsl --install --no-launch
    wsl --install --no-launch
    
    echo 'WSL errors and usage information above may or may not be disregarded.'

    _messagePlain_probe wsl --update
    wsl --update
    
    _messagePlain_probe wsl --set-default-version 2
    wsl --set-default-version 2

    _messagePlain_probe wsl --update
    wsl --update

    sleep 45
    wsl --update

    sleep 5
    wsl --update
    
    sleep 5
    wsl --set-default-version 2

    sleep 5
    wsl --update
    
    sleep 5
    wsl --set-default-version 2

    #sleep 5
    #_setup_wsl2_procedure-fw
    #_setup_wsl2_procedure-portproxy
}
_setup_wsl2() {
    "$scriptAbsoluteLocation" _setup_wsl2_procedure "$@"
}
_setup_wsl() {
    _setup_wsl2 "$@"
}







