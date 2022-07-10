#!/bin/bash

openconnect() {
    local dockerImage="jerser/docker-vpn"

    local vpnName="$1"; shift
    if [ -z "$vpnName" ]; then
        echo "VPN name must be provided"
        return
    fi

    if ! command -v "xquartz" &> /dev/null; then
        echo "You need XQuartz to run this on MacOS, please install it from https://xquartz.org"
        exit
    else
        if ! pgrep -x "xquartz" > /dev/null; then
            echo "Running XQuartz..."
            xquartz &
        fi
    fi

    if ! command -v "socat" &> /dev/null; then
        echo "You need socat to run this, please install it using your preferred package manager"
        exit
    else
        if ! pgrep -x "socat" > /dev/null; then
            echo "Running socat on port 6000..."
            socat TCP-LISTEN:6000,reuseaddr,fork UNIX-CLIENT:\"$DISPLAY\" &
        fi
    fi

    local bindIf="${BIND_INTERFACE:-127.0.0.1}"
    local socksPort="${SOCKS_PORT:-1080}"

    local dockerCmd=("docker" "run")
    dockerCmd+=("--rm" "--name" "vpn-$vpnName")
    dockerCmd+=("--hostname" "vpn-$vpnName")
    dockerCmd+=("--network" "host")
    dockerCmd+=("--interactive" "--tty")
    dockerCmd+=("--cap-add" "NET_ADMIN")
    dockerCmd+=("--device" "/dev/net/tun")
    dockerCmd+=("--publish" "$bindIf:$socksPort:1080")
    dockerCmd+=("--env" "DISPLAY=host.docker.internal:0")
    dockerCmd+=("$dockerImage")

    local vpnCmd=("/interactive-openconnect.sh")
    vpnCmd+=("$@")

    echo "============================================"
    echo "SOCKS Proxy Port: $socksPort (customize with SOCKS_PORT)"
    echo "============================================"

    echo "If you don't see a login screen opening up, please check XQuartz and socat (on port 6000) are running. Restarting the processes usually solves the problem."

    "${dockerCmd[@]}" "${vpnCmd[@]}"
}
