#!/bin/bash
RED='\033[0;31m'
NORMAL='\033[0m'
GREEN='\033[0;32m'

WORKING_DIR=$(pwd)
DISTRO_VER=$(lsb_release -rs)

echo -e ${RED}"Are you using WSL? (y/n)"${NORMAL}
read -p 'Input: ' INPUT
until [[ $INPUT == "Y" || $INPUT == "y" || $INPUT == "N" || $INPUT == "n" ]];
do
        echo -e ${RED}'Please try again!'${NORMAL}
        read INPUT
done
if [[ $INPUT == "Y" || $INPUT == "y" ]]; then
        echo -e ${GREEN}"Setting up forensics environment with WSL"${NORMAL}
        sleep 2
        chmod +x ./bin/ubuntu-wsl.sh
        bash ./bin/ubuntu-wsl.sh $WORKING_DIR
else
        echo -e ${GREEN}"Setting up forensics environment with Ubuntu "$DISTRO_VER${NORMAL}
        sleep 2
        if [[ $DISTRO_VER == "23.04" || $DISTRO_VER > "23.04" ]]; then
                echo -e ${RED}"Ubuntu 23.04 installation script is unstable and may contains many bugs."${NORMAL}
                sleep 2
                chmod +x ./bin/ubuntu23.sh
                bash ./bin/ubuntu23.sh $WORKING_DIR
        else
                chmod +x ./bin/ubuntu22.sh
                bash ./bin/ubuntu22.sh $WORKING_DIR
        fi
fi

