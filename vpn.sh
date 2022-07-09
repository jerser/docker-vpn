#!/bin/bash

openconnect() {
    local vpnName="$1"; shift
    if [ -z "$vpnName" ]; then
        echo "VPN name must be provided"
        return
    fi

    # check if socat is running
    if [ ! $(socat /dev/null TCP:127.0.0.1:6000) ]; then
        echo "socat is not running, will try to run now..."
        socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
    else
        echo "socat running as expected"
    fi

    # listen on localhost by default
    local bindIf="${BIND_INTERFACE:-127.0.0.1}"
    local socksPort="${SOCKS_PORT:-1080}"
    
    local vpnConfig="$HOME/.vpn"
    local dockerImage="jerser/docker-vpn"

    local dockerCmd=("docker" "run")
    local vpnCmd=("/interactive-openconnect.sh")
    dockerCmd+=("--rm" "--name" "vpn-$vpnName")
    dockerCmd+=("--hostname" "vpn-$vpnName")
    dockerCmd+=("--network" "host")
    dockerCmd+=("--interactive" "--tty")
    dockerCmd+=("--cap-add" "NET_ADMIN")
    dockerCmd+=("--device" "/dev/net/tun")
    dockerCmd+=("--publish" "$bindIf:$socksPort:1080")
    dockerCmd+=("--env" "DISPLAY=host.docker.internal:0")
    dockerCmd+=("$dockerImage")

    # append any extra args provided
    vpnCmd+=("$@")
    # display help if there are no arguments at this point
    if [ ${#vpnCmd[@]} -eq 1 ]; then
        vpnCmd+=("--help")
    fi


    echo "============================================"
    echo "SOCKS Proxy Port: $socksPort (customize with SOCKS_PORT)"
    echo "============================================"

    "${dockerCmd[@]}" "${vpnCmd[@]}"
}
