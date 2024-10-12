#!/bin/bash

function connect_wifi() {
    # Define variables
    local ssid="$1"
    local encrypted_file="$2"

    # Scan for available WiFi networks
    AVAILABLE_NETWORKS=$(nmcli -t -f SSID dev wifi list)

    # Check if the desired SSID is available
    if echo "$AVAILABLE_NETWORKS" | grep -q "^$SSID$"; then
        echo
        echo "Connect to wifi network ${ssid} - ${BOLD}please enter passphrase to decrypt password${NORMAL}"
        # Decrypt the password
        WIFI_PASSWORD=$(gpg --decrypt $ENCRYPTED_FILE 2>/dev/null)
        # Check if decryption was successful
        if [ -z "$WIFI_PASSWORD" ]; then
            echo "Failed to decrypt the WiFi password."
            return
        fi
        # Connect to the WiFi using nmcli
        nmcli dev wifi connect "$SSID" password "$WIFI_PASSWORD"
        sleep 5  # give network some time to connect
    else
        echo "WiFi network '$SSID' is not available."
    fi
}

function check_internet() {
    local ssid="$1"
    local encrypted_file="$2"

    if [[ "${skip}" != 1 ]]; then
        if ! (: >/dev/tcp/8.8.8.8/53) >/dev/null 2>&1; then
            connect_wifi "${ssid}" "${encrypted_file}"
        fi
        while true; do
            if (: >/dev/tcp/8.8.8.8/53) >/dev/null 2>&1; then
                break
            else
                echo "${BOLD}Offline. Please connet to the internet${NORMAL}"
                read -p "Press enter when connected (write - ${BOLD}skip${NORMAL} - and press enter to try without internet): ${BOLD}" input
                echo ${NORMAL}
                if [[ "${input}" == "skip" ]]; then
                    export skip=1
                    break
                fi
            fi
        done
    fi
}
