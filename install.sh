#!/bin/bash
RED='\033[0;31m'
NORMAL='\033[0m'
GREEN='\033[0;32m'

WORKING_DIR=$(pwd)
DISTRO_VER=$(lsb_release -rs)

echo -n ${GREEN}"Setting up forensics environment with Ubuntu "$DISTRO_VER${NORMAL}
sleep 2
if [[ $DISTRO_VER == "23.04" || $DISTRO_VER > "23.04" ]]; then
        echo -n ${RED}"Ubuntu 23.04 installation script is unstable and may contains many bugs."${NORMAL}
        chmod +x ./bin/ubuntu23.sh
        bash ./bin/ubuntu23.sh $WORKING_DIR
else
        chmod +x ./bin/ubuntu22.sh
        bash ./bin/ubuntu22.sh $WORKING_DIR
fi