



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
    dig github.githubassets.com A +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
    dig github.githubassets.com AAAA +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
}
_ip-github() {
    _ip-githubDotCOM
    _ip-githubassetsDotCOM
}

_ip-google() {
    dig google.com A +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
    dig google.com AAAA +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
    dig accounts.google.com A +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
    dig accounts.google.com AAAA +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
    dig gmail.com A +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
    dig gmail.com AAAA +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
}

# WARNING: May be untested.
# DANGER: Strongly discouraged. May not be protective against embedded malicious adds. In particular, many Google ads may be present at other (ie. Facebook) sites.
# ATTENTION: Override with 'ops.sh' or similar .
_ip-misc() {
    dig wikipedia.com A +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
    dig wikipedia.com AAAA +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'

    dig gitlab.com A +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
    dig gitlab.com AAAA +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'

    dig linkedin.com A +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
    dig linkedin.com AAAA +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
    dig facebook.com A +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
    dig facebook.com AAAA +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
    dig microsoft.com A +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
    dig microsoft.com AAAA +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
    dig youtube.com A +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
    dig youtube.com AAAA +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'

    dig openai.com A +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
    dig openai.com AAAA +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
    dig chat.openai.com A +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
    dig chat.openai.com AAAA +short @8.8.8.8 | tr -dc 'a-zA-Z0-9\:\/\.\n'
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


