


_ip-dig() {
    # https://unix.stackexchange.com/questions/723287/using-dig-to-query-an-address-without-resolving-cnames
    # https://serverfault.com/questions/965368/how-do-i-ask-dig-to-only-return-the-ip-from-a-cname-record
    echo '#'"$1"
    dig -t a +short "$1" @8.8.8.8 2>/dev/null | tr -dc 'a-zA-Z0-9\:\/\.\n' | grep -v '\.$' | grep -v 'error'
    dig -t aaaa +short "$1" @8.8.8.8 2>/dev/null | tr -dc 'a-zA-Z0-9\:\/\.\n' | grep -v '\.$' | grep -v 'error'
    true
}


# WARNING: May be untested.
_ip-githubDotCOM() {
    # ATTRIBUTION: ChatGPT4 2023-10-08 .
    # Fetch IP addresses from GitHub's meta API
    if [[ "$GH_TOKEN" != "" ]]
    then
        curl -H "Authorization: token ${GH_TOKEN}" -s "https://api.github.com/meta" | jq -r '.git[], .hooks[], .web[], .api[], .actions[]' | tr -dc 'a-zA-Z0-9\:\/\.\n' 
    else
        curl -s "https://api.github.com/meta" | jq -r '.git[], .hooks[], .web[], .api[], .actions[]' | tr -dc 'a-zA-Z0-9\:\/\.\n'
    fi
}
_ip-githubassetsDotCOM() {
    # ATTRIBUTION: ChatGPT4 2023-10-08 .
    _ip-dig github.githubassets.com
}
_ip-github() {
    _ip-githubDotCOM
    _ip-githubassetsDotCOM
}

_ip-google() {
    _ip-dig google.com
    _ip-dig accounts.google.com
    _ip-dig mail.google.com
    _ip-dig gmail.com
}

# WARNING: May be untested.
# DANGER: Strongly discouraged. May not be protective against embedded malicious adds. In particular, many Google ads may be present at other (ie. Facebook) sites.
# ATTENTION: Override with 'ops.sh' or similar .
_ip-misc() {
    _ip-dig ic3.gov
    _ip-dig www.ic3.gov

    _ip-dig cvedetails.com
    _ip-dig www.cvedetails.com

    _ip-dig wikipedia.com

    _ip-dig stackexchange.com
    _ip-dig serverfault.com
    _ip-dig superuser.com
    _ip-dig cyberciti.biz
    _ip-dig www.cyberciti.biz
    _ip-dig arduino.cc
    _ip-dig forum.arduino.cc

    _ip-dig debian.org
    _ip-dig www.debian.org
    _ip-dig gpo.zugaina.org
    
    _ip-dig appimage.org

    _ip-dig weather.gov
    _ip-dig radar.weather.gov
    _ip-dig fcc.gov
    _ip-dig www.fcc.gov

    _ip-dig bing.com
    _ip-dig www.bing.com

    _ip-dig gitlab.com
    
    _ip-dig twitter.com
    _ip-dig x.com
    
    _ip-dig hackaday.com

    _ip-dig linkedin.com
    _ip-dig facebook.com
    _ip-dig microsoft.com
    _ip-dig youtube.com
    
    _ip-dig discord.com

    _ip-dig live.com
    _ip-dig login.live.com
    _ip-dig outlook.live.com
    
    _ip-dig proton.me
    _ip-dig mail.proton.me
    _ip-dig account.proton.me

    _ip-dig netflix.com
    _ip-dig www.netflix.com
    _ip-dig spotify.com
    _ip-dig open.spotify.com
    
    _ip-dig amazon.com
    _ip-dig ebay.com

    _ip-dig openai.com
    _ip-dig chat.openai.com
    
    _ip-dig signal.org
    _ip-dig wire.com
    _ip-dig app.wire.com

    _ip-dig liberra.chat
    _ip-dig web.liberra.chat

    _ip-dig mozilla.org
}

_ip-googleDNS() {
    # https://developers.google.com/speed/public-dns/docs/using
    echo '8.8.8.8'
    echo '8.8.4.4'
    echo '2001:4860:4860::8888'
    echo '2001:4860:4860:0:0:0:0:8888'
    echo '2001:4860:4860::8844'
    echo '2001:4860:4860:0:0:0:0:8844'
}

_ip-cloudfareDNS() {
    # https://www.cloudflare.com/learning/dns/dns-records/dns-aaaa-record/
    echo '1.1.1.1'
    echo '1.0.0.1'
    echo '2606:4700:4700::1111'
    echo '2606:4700:4700::1001'
}




_setup_hosts() {
    _test_hosts
}

_test_hosts() {
    _test_fw
    
    # Not incurring as a dependency... for now.
    return 0
    
    _if_cygwin && return 0

    _getDep dig
}


