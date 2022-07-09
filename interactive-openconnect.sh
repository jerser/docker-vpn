#!/bin/bash

vpnHostname="$1"

eval $( gp-saml-gui --gateway --clientos=Windows "$vpnHostname" --allow-insecure-crypto )
echo $COOKIE | sudo openconnect --protocol=gp -u "$USER" --os=win --usergroup=gateway:prelogin-cookie --passwd-on-stdin "$vpnHostname"
