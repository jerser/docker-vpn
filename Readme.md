## About

docker-vpn is an alternative to installing VPN software on your host system and routing all your traffic through a VPN. This is useful if you want to have control over which traffic is sent through the VPN. Sending all your traffic through a VPN is a privacy concern and limits your internet connection to the speed of your VPN.

This is a fork of [`ethack/vpn`](https://github.com/ethack/docker-vpn) to serve a specific Global Protect use case and combines it with [`dlenski/gp-saml-gui`](https://github.com/dlenski/gp-saml-gui). README is tweaked for the specific use case, but otherwise remains as-is.

It provides
- OpenConnect, tested for Global Protect
- SAML GUI for interactive login on Global Protected
- SOCKS 5 server (default port 1080)

## Install

- [Install Docker](https://docs.docker.com/install/)
- (On Mac) [Install XQuartz](https://www.xquartz.org)
- [Install socat](https://www.redhat.com/sysadmin/getting-started-socat)
- Source `vpn.sh` in your `.bashrc` file or current shell. E.g. `source vpn.sh`

## Usage

```
openconnect bar https://vpn.example.com
```

The first argument is an arbitrary name that you give your VPN connection. This is used in the Docker container names. The rest of the arguments are passed to the VPN client. 

Before connecting you will see an X11 window prompting to sign in, after sign in you will be connected.

```
============================================
SOCKS Proxy Port: 1080
============================================
```

## Customizing

You can customize options by setting the following environment variables. The defaults are shown below.

* `BIND_INTERFACE`: 127.0.0.1
* `SOCKS_PORT`: 1080

## Limitations
- If you have multiple VPNs you want to connect to at once, you have to choose ports that do not conflict.
- VPN configurations can be wildly different. This has only really been tested with Global Protect using Okta and Google as the SAML providers.

## Credits
- https://github.com/ethack/docker-vpn
- https://github.com/dlenski/gp-saml-gui
