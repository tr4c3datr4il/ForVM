#!/bin/bash
RED='\033[0;31m'
NORMAL='\033[0m'


WORKING_DIR=$(pwd)
LOG_FILE=$WORKING_DIR"/Installation.log"
touch $LOG_FILE
chmod +w $LOG_FILE

function writeToLog {
    if [ $1 -eq 0 ]; then
        echo "$(date): $2 installation successful" >> $LOG_FILE
    else
        echo "$(date): ERROR - $2 installation failed with exit code $1" >> $LOG_FILE
    fi
}

function Dependencies {
        APT_PACKAGES=(
                unzip snapd default-jre curl yara git ca-certificates gnupg lsb-release
                build-essential libdistorm3-dev libraw1394-11
                libnetfilter-queue-dev libssl-dev libssl3 libyara-dev
                libcapstone-dev capstone-tool tzdata
                python2.7 python2.7-dev libpython2-dev
                python3 python3-dev libpython3-dev python3-pip
                python3-setuptools python3-wheel python3.10-venv
                gnome-terminal
        )
        for package in "${APT_PACKAGES[@]}"; do
                sudo apt install -y $package
                writeToLog $? "APT - $package"
        done
        sudo apt-get update && sudo apt-get upgrade -y
}

function Memory {
        echo -e ${RED}'Installing Volatility 2 and 3'${NORMAL}
        sleep 3
        curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
        sudo python2.7 get-pip.py
        sudo python2.7 -m pip install -U setuptools wheel
        while read package; do
                python2.7 -m pip install -U "$package"
                writeToLog $? "PIP2 - $package"
        done < requirements.txt
        sudo ln -s ~/.local/lib/python2.7/site-packages/usr/lib/libyara.so /usr/lib/libyara.so
        python2.7 -m pip install -U git+https://github.com/volatilityfoundation/volatility.git
        writeToLog $? "Volatility 2"
        
        while read package; do
                python3 -m pip install -U "$package"
                writeToLog $? "PIP3 - $package"
        done < requirements.txt
        python3 -m pip install -U git+https://github.com/volatilityfoundation/volatility3.git
        writeToLog $? "Volatility 3"
        
        git clone https://github.com/superponible/volatility-plugins.git
        cp ~/lab/volatility-plugins/* ~/.local/lib/python2.7/site-packages/volatility/plugins/
        git clone https://github.com/kudelskisecurity/volatility-gpg.git
        cp ~/lab/volatility-gpg/linux/* ~/.local/lib/python3.10/site-packages/volatility3/framework/plugins/linux/
        git clone https://github.com/volatilityfoundation/volatility.git

}

function Networking_Logging {
        echo -e ${RED}'Installing Networking and Log/Monitoring tools'${NORMAL}
        sleep 3
        sudo apt-get install -y tshark
        writeToLog $? "APT - tshark"

        git clone https://github.com/mandiant/flare-fakenet-ng.git
        sudo python2.7 -m pip install https://github.com/mandiant/flare-fakenet-ng/zipball/master
        cd ~/lab/flare-fakenet-ng
        sudo python2.7 setup.py install

        cd ~/lab && \
                wget https://github.com/WithSecureLabs/chainsaw/releases/download/v2.5.0/chainsaw_x86_64-unknown-linux-gnu.tar.gz
        tar -xf chainsaw_x86_64-unknown-linux-gnu.tar
        cd ~/lab/chainsaw/ && \
                sudo cp chainsaw /usr/bin/chainsaw && sudo chmod +x /usr/bin/chainsaw
        pip3 install --upgrade pip
        python3 -m pip install sigma-cli
}

function File_analizing {
        echo -e ${RED}'Installing File analizing tools'${NORMAL}
        sleep 3
        sudo -H python3 -m pip install -U oletools[full]
        writeToLog $? "PIP - oletools"
        cd ~/lab && \
                git clone https://github.com/jesparza/peepdf.git
        cd peepdf/ && \
                sed -i '1i#!/usr/bin/python2.7' peepdf.py
        cd ~/lab && \
                sudo cp -r peepdf/ /usr/bin && sudo chmod +x /usr/bin/peepdf
}

function OSX {
        cd ~/lab && \
                git clone https://github.com/n0fate/chainbreaker.git
        cd chainbreaker/
        python3 setup.py bdist_wheel -d dist
        python3 -m pip install -e .
}

function Stego_Osint {
        echo -e ${RED}'Installing Stego and OSINT tools'${NORMAL}
        sleep 3
        cd ~/lab
        sudo apt-get install -y exiftool steghide
        sudo gem install zsteg
        wget https://github.com/RickdeJager/stegseek/releases/download/v0.6/stegseek_0.6-1.deb
        chmod +x ./stegseek_0.6-1.deb
        sudo apt-get install -y ./stegseek_0.6-1.deb
        wget http://www.caesum.com/handbook/Stegsolve.jar -O stegsolve.jar
        chmod +x stegsolve.jar
        git clone https://github.com/p1ngul1n0/blackbird
        cd blackbird && \
                sed -i '1i#!/usr/bin/python3' ~/lab/blackbird/blackbird.py
        while read package; do
                python3 -m pip install -U "$package"
                writeToLog $? "PIP3 - $package"
        done < requirements.txt
        sudo cp ~/lab/blackbird/blackbird.py /usr/bin/blackbird.py && sudo chmod +x /usr/bin/blackbird.py
        pipx ensurepath
        pipx install ghunt
        writeToLog $? "PIPX - ghunt"
        cd ~/lab && \
                wget https://mark0.net/download/trid_linux_64.zip && \
                mkdir trid && \
                unzip trid_linux_64.zip -d ./trid
        cd trid && \
                wget https://mark0.net/download/tridupdate.zip && \
                unzip tridupdate.zip
        python3 tridupdate.py
        sudo cp trid /usr/bin/trid && sudo chmod +x /usr/bin/trid
        sudo cp *.trd /usr/bin/
        echo -e "export LANG=/usr/lib/locale/en_US" >> $SHELL_RC_FILE
        cd ~/lab && \
                git clone https://github.com/megadose/holehe.git && cd holehe
        sudo python3 setup.py install
}

function Misc {     
        cd ~/lab && \
                git clone https://github.com/TheDarkBug/uwufetch.git && cd uwufetch
        make build
        sudo make install
        sudo snap install ngrok
        writeToLog $? "SNAP - ngrok"
        APT_PACKAGES=(
                dive tree neofetch lolcat bat nala htop 
                bpytop bison flex dwarfdump openssh-server net-tools 
                binwalk openvpn dos2unix gdb
        )
        for package in "${APT_PACKAGES[@]}"; do
                sudo apt install -y $package
                writeToLog $? "APT - $package"
        done
}

function Main {
        sudo apt-get update && sudo apt-get upgrade -y
        SHELL_RC_FILE="$HOME/.$(echo $SHELL | awk -F '/' '{print $NF}')"rc
        mkdir ~/lab
        cd ~/lab

        Dependencies
        Memory
        Networking_Logging
        File_analizing
        Cracking
        Disk
        Stego_Osint
        OSX
        Misc

        sudo apt-get update
        sudo apt-get upgrade -y 
        sudo apt autoremove
        echo -e "export PATH=/usr/bin/peepdf:/home/\$USER/.local/bin:\$PATH" >> $SHELL_RC_FILE
        echo -e ${RED}'Do you want to reboot the system (y/n)? If not, please do it manually to make sure everything is working fine!'${NORMAL}
        read INPUT
        until [[ $INPUT == "Y" || $INPUT == "y" || $INPUT == "N" || $INPUT == "n" ]];
        do
                echo -e ${RED}'Please try again!'${NORMAL}
                read INPUT
        done
        if [[ $INPUT == "Y" || $INPUT == "y" ]]; then
                sudo reboot -f
        else
                echo -e ${RED}"Please reboot asap ^_^"${NORMAL}
        fi
}

Main