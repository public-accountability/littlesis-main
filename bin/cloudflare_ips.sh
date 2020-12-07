#!/bin/sh
set -eu

# realip_conf=ansible/roles/app/files/realip.conf
realip_conf=realip.test

curl -sSL "https://www.cloudflare.com/ips-v4" > /tmp/cloudflare-ips.txt
curl -sSL "https://www.cloudflare.com/ips-v6" >> /tmp/cloudflare-ips.txt
ruby -ne 'print "set_real_ip_from #{$_.delete("\n")};\n"' < /tmp/cloudflare-ips.txt > "$realip_conf"
echo 'real_ip_header X-Forwarded-For;' >> "$realip_conf"
