
# PowerShell?


# https://docs.microsoft.com/en-us/azure/virtual-machines/custom-data
# ' Custom data is placed in %SYSTEMDRIVE%\AzureData\CustomData.bin as a binary file, but it isn't processed. If you want to process this file, you'll need to build a custom image and write code to process CustomData.bin. '

# https://devkimchi.com/2020/08/26/app-provisioning-on-azure-vm-with-chocolatey-for-live-streaming/
# ' To run the custom script, add this extension to the ARM template. '

# 'RunPowerShellScript'



# https://devkimchi.com/2020/08/26/app-provisioning-on-azure-vm-with-chocolatey-for-live-streaming/

# Install Chocolatey
Set-ExecutionPolicy Bypass -Scope Process -Force; iex ((New-Object System.Net.WebClient).DownloadString('https://chocolatey.org/install.ps1'))

# Install Software
choco install git -y
choco install nmap -y
choco install qalculate -y

# https://www.reddit.com/r/PowerShell/comments/ofrsue/unattended_nuget_installation/
Install-PackageProvider -Name NuGet -Force -Scope AllUsers -ForceBootstrap

# https://git-scm.com/book/en/v2/Appendix-A%3A-Git-in-Other-Environments-Git-in-PowerShell
Install-Module PowerShellGet -Force -SkipPublisherCheck
Install-Module posh-git -Scope CurrentUser -Force
#Install-Module posh-git -Scope CurrentUser -AllowPrerelease -Force # Newer beta version with PowerShell Core support
Import-Module posh-git
Add-PoshGitToProfile -AllHosts
Import-Module posh-git

cmd /c "C:\Program Files\Git\bin\git.exe" config --global core.autocrlf input

cmd /c "C:\Program Files\Git\bin\git.exe" clone --recursive --depth 1 https://github.com/mirage335/ubiquitous_bash.git


cd ./ubiquitous_bash/_local/ubcp
.\ubcp-cygwin-portable-installer
cp ubcp_rename-to-enable.cmd ubcp.cmd


cd ../..


cmd /c .\_setupUbiquitous.bat



./_bin _mitigate-ubcp

./_bin _package-cygwinOnly

./_bin _setup_ubcp


