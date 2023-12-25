#!/bin/bash
RED='\033[0;31m'
NORMAL='\033[0m'
GREEN='\033[0;32m'

WORKING_DIR=$1
LOG_FILE=$WORKING_DIR"/log/Installation.log"

touch $LOG_FILE
chmod +w $LOG_FILE

function writeToLog {
    if [ $1 -eq 0 ]; then
        printf "%s: %s installation successful\n" "$(date)" "$2" >> "$LOG_FILE"
    else
        printf "%s: ERROR - %s installation failed with exit code %d\n" "$(date)" "$2" "$1" >> "$LOG_FILE"
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
                gnome-terminal cargo
        )
        for package in "${APT_PACKAGES[@]}"; do
                sudo apt install -y $package
                writeToLog $? "APT - $package"
        done
        sudo apt update && sudo apt upgrade -y
}

function Memory {
        # Install Volatility 2 and Volatility 3
        echo -e ${RED}'Installing Volatility 2 and 3'${NORMAL}
        sleep 3

        curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
        sudo python2.7 get-pip.py
        sudo python2.7 -m pip install -U setuptools wheel
        while read package; do
                python2.7 -m pip install -U "$package"
                writeToLog $? "PIP2 - $package"
        done < $WORKING_DIR/config/requirements2.txt
        sudo ln -s ~/.local/lib/python2.7/site-packages/usr/lib/libyara.so /usr/lib/libyara.so
        python2.7 -m pip install -U git+https://github.com/volatilityfoundation/volatility.git
        writeToLog $? "Volatility 2"
        
        while read package; do
                python3 -m pip install -U "$package" 
                writeToLog $? "PIP3 - $package"
        done < $WORKING_DIR/config/requirements3.txt
        python3 -m pip install -U git+https://github.com/volatilityfoundation/volatility3.git 
        writeToLog $? "Volatility 3"
        
        # Install Volatility's plugin
        git clone https://github.com/superponible/volatility-plugins.git
        cp ~/lab/volatility-plugins/* ~/.local/lib/python2.7/site-packages/volatility/plugins/
        git clone https://github.com/kudelskisecurity/volatility-gpg.git
        cp ~/lab/volatility-gpg/linux/* ~/.local/lib/python3.10/site-packages/volatility3/framework/plugins/linux/
        git clone https://github.com/volatilityfoundation/volatility.git
        
        # Install AVML and LiME
        echo -e ${RED}'Installing Memory Extractor tools'${NORMAL}
        sleep 3

        cd ~/lab && mkdir AVML && cd AVML && \
                wget https://github.com/microsoft/avml/releases/download/v0.13.0/avml
        chmod +x avml
        cd ~/lab && mkdir LiME && cd LiME && \
                wget https://github.com/504ensicsLabs/LiME/archive/refs/tags/v1.9.1.zip -O LiME-1.9.1.zip
        unzip LiME-1.9.1.zip 
}

function Networking_Logging {
        # Install Wireshark, tshark, Zui and Fakenet
        echo -e ${RED}'Installing Networking and Log/Monitoring tools'${NORMAL}
        sleep 3

        echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
        sudo DEBIAN_FRONTEND=noninteractive apt -y install wireshark
        writeToLog $? "APT - wireshark"
        sudo usermod -a -G wireshark $USER
        sudo apt install -y tshark
        writeToLog $? "APT - tshark"

        cd ~/lab && \
                git clone https://github.com/mandiant/flare-fakenet-ng.git
        sudo python3 -m pip install https://github.com/mandiant/flare-fakenet-ng/zipball/master 
        writeToLog $? "PIP - Fakenet"
        cd ~/lab/flare-fakenet-ng
        sudo python3 setup.py install
        writeToLog $? "PY - Fakenet"
        cd ~/lab && \
                wget https://github.com/brimdata/zui/releases/download/v1.4.1/zui_1.4.1_amd64.deb -O zui_1.4.1_amd64.deb
        sudo dpkg -i zui_1.4.1_amd64.deb
        writeToLog $? "DPKG - Zui"

        # Install elastic
        wget https://artifacts.elastic.co/downloads/kibana/kibana-8.11.0-linux-x86_64.tar.gz
        wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.11.0-linux-x86_64.tar.gz
        tar -xf kibana-8.11.0-linux-x86_64.tar
        tar -xf elasticsearch-8.11.0-linux-x86_64.tar
        
        # Install chainsaw and sigma
        cd ~/lab && \
                wget https://github.com/WithSecureLabs/chainsaw/releases/download/v2.8.0/chainsaw_x86_64-unknown-linux-gnu.tar.gz
        tar -xf chainsaw_x86_64-unknown-linux-gnu.tar
        cd ~/lab/chainsaw/ && \
                sudo cp chainsaw /usr/bin/chainsaw && sudo chmod +x /usr/bin/chainsaw
        pip3 install --upgrade pip
        python3 -m pip install sigma-cli
}

function FileAnalizing {
        # Install oletools and peepdf
        echo -e ${RED}'Installing File analizing tools'${NORMAL}
        sleep 3

        sudo -H python3 -m pip install -U oletools[full] 
        writeToLog $? "PIP - oletools"
        cd ~/lab && \
                git clone https://github.com/jesparza/peepdf.git
        cd peepdf/ && \
                sed -i '1i#!/usr/bin/python2.7' peepdf.py
}

function Stego_Osint {
        # Install steghide, stegseek stegsolve
        echo -e ${RED}'Installing Stego and OSINT tools'${NORMAL}
        sleep 3

        cd ~/lab
        sudo apt install -y exiftool steghide
        sudo gem install zsteg
        wget https://github.com/RickdeJager/stegseek/releases/download/v0.6/stegseek_0.6-1.deb
        chmod +x ./stegseek_0.6-1.deb
        sudo apt install -y ./stegseek_0.6-1.deb
        wget http://www.caesum.com/handbook/Stegsolve.jar -O stegsolve.jar
        sudo cp stegsolve.jar /usr/bin/
        echo -e "alias 'stegsolve'='sudo java -jar /usr/bin/stegsolve.jar'" >> $SHELL_RC_FILE
        
        # Install blackbird, Ghunt, holehe
        git clone https://github.com/p1ngul1n0/blackbird
        cd blackbird && \
                sed -i '1i#!/usr/bin/python3' ~/lab/blackbird/blackbird.py
        while read package; do
                python3 -m pip install -U "$package" 
                writeToLog $? "PIP3 - $package"
        done < requirements.txt
        sudo cp ~/lab/blackbird/blackbird.py /usr/bin/blackbird && sudo chmod +x /usr/bin/blackbird
        sudo apt install pipx
        writeToLog $? "APT - PIPX"
        export PATH="${PATH}:$(python3 -c 'import site; print(site.USER_BASE)')/bin"
        pipx ensurepath
        pipx install ghunt
        writeToLog $? "PIPX - ghunt"
        cd ~/lab && \
                git clone https://github.com/megadose/holehe.git && cd holehe
        sudo python3 setup.py install
        writeToLog $? "PY - Holehe"

        # Install trid
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
        sudo sed 's/UTF-8/utf-8/g' /etc/locale.gen > ~/locale.gen
        sudo cp ~/locale.gen /etc/locale.gen
        sudo rm -f /usr/lib/locale/locale-archive
        sudo locale-gen --no-archive en_US.utf8
        echo -e "export LANG=en_US.utf-8" >> $SHELL_RC_FILE
        sudo rm ~/locale.gen
}

function Cracking {
        # Install hashcat and johntheripper
        echo -e ${RED}'Installing Cracking tools & Wordlists'${NORMAL}
        sleep 3

        sudo apt install -y hashcat
        writeToLog $? "APT - hashcat"
        sudo snap install john-the-ripper
        writeToLog $? "SNAP - johntheripper"
        
        # Install chainbreaker
        cd ~/lab && \
                git clone https://github.com/n0fate/chainbreaker.git
        cd chainbreaker/
        python3 setup.py bdist_wheel -d dist
        python3 -m pip install -e .

        # Get cracking wordlists
        cd ~/lab && \
                git clone https://github.com/danielmiessler/SecLists.git && \
                git clone https://github.com/3ndG4me/KaliLists.git
        cd KaliLists/
        gunzip rockyou.txt.gz 
        echo "alias 'wordlists'='echo ~/lab/KaliLists ~/lab/SecLists'" >> $SHELL_RC_FILE
        cd ~/lab && \
                git clone https://github.com/Yara-Rules/rules.git
}

function Disk {
        # Install some disk forensics tools here
        echo -e ${RED}'Installing Disk tools'${NORMAL}
        sleep 3

        APT_PACKAGES=(
                autopsy ewf-tools testdisk cryptsetup-bin
                libfvde1 libfvde-dev libfvde-utils
        )
        for package in "${APT_PACKAGES[@]}"; do
                sudo apt install -y $package
                writeToLog $? "APT - $package"
        done
}

function Misc {
        # Install docker
        echo -e ${RED}'Installing Docker'${NORMAL}
        sleep 3
        
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        echo -e \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt update
        DOCKER_PACKAGES=(docker-ce docker-ce-cli containerd.io docker-compose-plugin)
        for package in "${DOCKER_PACKAGES[@]}"; do
                sudo apt install -y $package
                writeToLog $? "APT - $package"
        done
        sudo usermod -aG docker $USER

        # Pull stego toolkit
        sudo docker pull dominicbreuker/stego-toolkit
        
        # Install something funny
        cd ~/lab && \
                git clone https://github.com/TheDarkBug/uwufetch.git && cd uwufetch
        make build
        sudo make install
        SNAP_PACKAGES=(
                ngrok dive pycdc pyinstxtractor
        )
        for package in "${APT_PACKAGES[@]}"; do
                sudo snap install $package
                writeToLog $? "SNAP - $package"
        done
        APT_PACKAGES=(
                tree neofetch lolcat bat nala htop 
                bpytop bison flex dwarfdump openssh-server net-tools 
                binwalk openvpn dos2unix gdb ltrace
        )
        for package in "${APT_PACKAGES[@]}"; do
                sudo apt install -y $package
                writeToLog $? "APT - $package"
        done

        # Install pwndbg
        cd ~/lab && \
                git clone https://github.com/pwndbg/pwndbg
        cd pwndbg && \
                chmod +x setup.sh
                ./setup.sh
                writeToLog $? "pwndbg"

        # Upgrade PIP packages
        pip2 --disable-pip-version-check list --outdated --format=json | python2.7 -c "import json, sys; print('\n'.join([x['name'] for x in json.load(sys.stdin)]))"
        writeToLog $? "UPGRADE-PIP2"
        pip3 --disable-pip-version-check list --outdated --format=json | python3 -c "import json, sys; print('\n'.join([x['name'] for x in json.load(sys.stdin)]))"
        writeToLog $? "UPGRADE-PIP3"

        #Install ZSH
        sudo apt install zsh
        writeToLog $? "INSTALLED ZSH"
        chsh -s $(which zsh)
        writeToLog $? "SET ZSH AS DEFAULT"

        #Install oh-my-zsh
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
        writeToLog $? "DOWNLOAD AND INSTALL OH-MY-ZSH"
        curl https://gist.githubusercontent.com/PkNova76/6823ebad7e7d246a4bb0a0d7e0f7ca60/raw/e477aee406ea64013acfe64263a515980dfa25ae/pknova.zsh-theme -o ~/.oh-my-zsh/themes/pknova.zsh-theme
        writeToLog $? "DOWNLOAD My Theme"
        sed -i "/^ZSH_THEME=/cZSH_THEME=\"pknova\"" ~/.zshrc
        writeToLog $? "SET MY THEME"
        sed -i "/^plugins=/cplugins=(git aliases colorize colored-man-pages copypath encode64)" ~/.zshrc
}

function EditGrub {
        sudo cp /etc/default/grub /etc/default/grub.backup
        echo -e \
'GRUB_DEFAULT=0
GRUB_TIMEOUT_STYLE=menu
GRUB_HIDDEN_TIMEOUT=5
GRUB_TIMEOUT=10
GRUB_DISTRIBUTOR=`lsb_release -i -s 2> /dev/null || echo Debian`
GRUB_CMDLINE_LINUX_DEFAULT="quiet splash"
GRUB_CMDLINE_LINUX="find_preseed=/preseed.cfg auto noprompt priority=critical locale=en_US"
GRUB_DISABLE_OS_PROBER=false' | sudo tee /etc/default/grub
        sudo update-grub 
}

function Main {
        sudo apt update && sudo apt upgrade -y
        SHELL_RC_FILE="$HOME/.$(echo $SHELL | awk -F '/' '{print $NF}')"rc
        export LC_TIME=en_US.UTF-8
        mkdir ~/lab
        cd ~/lab

        Dependencies
        Memory
        Networking_Logging
        FileAnalizing
        Cracking
        Disk
        Stego_Osint
        Misc
        EditGrub

        sudo apt update
        sudo apt upgrade -y 
        sudo apt autoremove
        echo -e "export PATH=/usr/bin/peepdf:/home/\$USER/.local/bin:\$PATH" >> $SHELL_RC_FILE
        echo -e "export LC_TIME=en_US.utf-8" >> $SHELL_RC_FILE
        echo -e "export LC_ALL=en_US.UTF-8" >> $SHELL_RC_FILE
        echo -e "export LC_ALL=C" >> $SHELL_RC_FILE
}

Main

echo -e ${GREEN}'Log file located at '$(echo $WORKING_DIR)${NORMAL}
sleep 2
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