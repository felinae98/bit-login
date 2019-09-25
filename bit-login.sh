#!/bin/bash

function test_connection {
    curl --connect-timeout 0.1 10.0.0.55 -I -s| grep SRunFlag > /dev/null
    if [[ $? != 0 ]]; then
        echo >&2 'you are unable to connect 10.0.0.55, plz check your connection'
        exit 1
    fi
} 

function get_connection_info {
    gateway=`ip route get 10.0.0.55 | head -1 | awk '{print $3}'`
    interface=`ip route get 10.0.0.55 | head -1 | awk '{print $5}'`
    device_ip=`ip route get 10.0.0.55 | head -1 | awk '{print $7}'`
}

function check_wireless {
    echo $interface | grep wlp > /dev/null
    if [[ $? != 0 ]]; then
        wireless=0
    else
        wireless=1
        ssid=`iw dev $interface info | grep 'ssid' | awk '{print $2}'`
    fi
}

test_connection
get_connection_info
check_wireless

echo "you are using [$interface]"
echo "your local ip is [$device_ip]"
if [[ $wireless == 1 ]]; then
    echo "you are using wlan"
    echo "your ssid is [$ssid]"
fi