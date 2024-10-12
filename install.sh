#!/bin/bash

SCRIPT_HOME="$(dirname "${BASH_SOURCE[0]}")"
BOLD="$(tput bold)"
NORMAL="$(tput sgr0)"
REPO_NAME="steamdeck_install"
GIT_PATH="/home/${USER}/documents/scm/${REPO_NAME}"
SSID="Martin Router King"  # Replace with your WiFi SSID
ENCRYPTED_FILE="${SCRIPT_HOME}/src/wifi_password.gpg"

function helptext() {
cat << EOF
Usage: $(basename "$0") [-h]

Options:
-h    Show this help message and exit.

Examples:
$(basename "$0")
$(basename "$0") -h

Description:
This script will configure the system with ansible
and the user environment with chezmoi
EOF
}

while getopts "h" flag
do
    case "${flag}" in
        h )
            helptext
            exit 0;;
        ?)
            helptext
            exit 1;;
    esac
done

source "${SCRIPT_HOME}/src/helpers.sh"

echo -e "\n__________________________________________________________\n"
echo "${BOLD}Welcome to the custom GSK installer!${NORMAL}"
echo -e "\n__________________________________________________________\n"

if [[ "${USER}" != "deck" && "${HOSTNAME}" != "steamdeck" ]]; then
    echo "please boot into steamdeck"
    exit 1
fi

check_internet "${SSID}" "${ENCRYPTED_FILE}"  # early to have all user interactions together early

# Create and enter virtual environment
if ! [ -d .venv ]; then
    python3 -m venv .venv
fi
source /home/deck/.venv/bin/activate

python3 -m ensurepip --upgrade  # same command will update pip later on
pip3 install ansible

inventory="${SCRIPT_HOME}/ansible/hosts.yml"
# TODO: add error handling in case ansible-playbook stops
/home/deck/.venv/bin/ansible-playbook "${SCRIPT_HOME}/ansible/main.yml" -i "${inventory}" -T 60 -e __dotfiles_dest="${GIT_PATH}/../dotfiles"

/home/deck/.local/bin/chezmoi init --apply --source "${GIT_PATH}/../dotfiles"

echo
echo "${BOLD}reboot recommended to apply all changes correctly${NORMAL}"
