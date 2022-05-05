
Paste one of these three scripts as 'user data' (or similar) to a cloud provider. A 'croc' relay will run on port 9009 within approximately two minutes, and will also run after reboot if necessary. No login necessary.


croc --relay '<IPv4_Address>' --relay6 '<IPv6_Address>' send ./file





nmap '<IPv4_Address>' -p 9009 -Pn

Apparently usable as-is with Digital Ocean and Hetzner. With Vultur, did not seem to open the correct ports (eg. 9009). Expected usable as-is with other cloud providers (eg. Azure) as well.

Please beware these scripts may be derived from much more complete upstream scripts. Please see '_lib/kit/install/cloud/cloud-init/zRotten/special/croc' from 'ubiquitous_bash' .
