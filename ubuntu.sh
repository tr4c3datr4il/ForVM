#!/bin/bash
RED='\033[0;31m'
CYAN='\033[0;36m'

function Dependencies {
        sudo apt-get install ca-certificates gnupg lsb-release -y
        sudo apt-get install unzip snapd default-jre curl yara git -y
        sudo apt-get install -y build-essential libdistorm3-dev libraw1394-11 \
                                libcapstone-dev capstone-tool tzdata
        sudo apt-get install -y python2.7 python2.7-dev libpython2-dev
        sudo apt-get install -y python3 python3-dev libpython3-dev python3-pip \
                                python3-setuptools python3-wheel python3.10-venv
        sudo apt-get install -y libnetfilter-queue-dev libssl-dev libssl3 libyara-dev
        sudo apt-get install gnome-terminal -y
        sudo apt-get update && sudo apt-get upgrade -y
}

function Memory {
        echo -e ${RED}'Installing Volatility 2 and 3'${CYAN}
        curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
        sudo python2.7 get-pip.py
        sudo python2.7 -m pip install -U setuptools wheel
        python2.7 -m pip install -U distorm3 yara-python pycryptodome pillow openpyxl ujson pytz ipython capstone construct==2.5.5-reupload
        sudo ln -s ~/.local/lib/python2.7/site-packages/usr/lib/libyara.so /usr/lib/libyara.so
        python2.7 -m pip install -U git+https://github.com/volatilityfoundation/volatility.git
        python3 -m pip install -U distorm3 pillow openpyxl ujson pytz ipython capstone pefile yara-python pycryptodome jsonschema leechcorepyc python-snappy
        python3 -m pip install -U git+https://github.com/volatilityfoundation/volatility3.git
        git clone https://github.com/superponible/volatility-plugins.git
        cp ~/lab/volatility-plugins/* ~/.local/lib/python2.7/site-packages/volatility/plugins/
        git clone https://github.com/kudelskisecurity/volatility-gpg.git
        cp ~/lab/volatility-gpg/linux/* ~/.local/lib/python3.10/site-packages/volatility3/framework/plugins/linux/
        git clone https://github.com/volatilityfoundation/volatility.git
        echo -e ${RED}'Installing Memory Extractor tools'${CYAN}
        cd ~/lab && mkdir AVML && cd AVML && wget https://github.com/microsoft/avml/releases/download/v0.11.0/avml
        chmod +x avml
        cd ~/lab && wget https://github.com/504ensicsLabs/LiME/archive/refs/tags/v1.9.1.zip
        mkdir LiME && cd LiME && unzip LiME-1.9.1.zip 
}

function Networking_Logging {
        echo -e ${RED}'Installing Networking and Log/Monitoring tools'${CYAN}
        echo "wireshark-common wireshark-common/install-setuid boolean true" | sudo debconf-set-selections
        sudo DEBIAN_FRONTEND=noninteractive apt-get -y install wireshark
        sudo usermod -a -G wireshark $USER
        sudo apt-get install tshark -y
        git clone https://github.com/mandiant/flare-fakenet-ng.git
        python2.7 -m pip install requests
        sudo python2.7 -m pip install https://github.com/mandiant/flare-fakenet-ng/zipball/master
        cd ~/lab/flare-fakenet-ng
        sudo python2.7 setup.py install
        python3 -m pip install pyshark
        cd ~/lab && wget https://github.com/brimdata/zui/releases/download/v1.0.0/zui_1.0.0_amd64.deb -O zui_1.0.0_amd64.deb
        sudo dpkg -i zui_1.0.0_amd64.deb
        wget https://artifacts.elastic.co/downloads/kibana/kibana-8.6.2-linux-x86_64.tar.gz
        wget https://artifacts.elastic.co/downloads/elasticsearch/elasticsearch-8.6.2-linux-x86_64.tar.gz
        gunzip  kibana-8.6.2-linux-x86_64.tar.gz && tar -xf kibana-8.6.2-linux-x86_64.tar
        gunzip elasticsearch-8.6.2-linux-x86_64.tar.gz && tar -xf elasticsearch-8.6.2-linux-x86_64.tar
        cd ~/lab && wget https://github.com/WithSecureLabs/chainsaw/releases/download/v2.5.0/chainsaw_x86_64-unknown-linux-gnu.tar.gz
        gunzip chainsaw_x86_64-unknown-linux-gnu.tar.gz && tar -xf chainsaw_x86_64-unknown-linux-gnu.tar
        cd ~/lab/chainsaw/ && sudo cp chainsaw /usr/bin/chainsaw && sudo chmod +x /usr/bin/chainsaw
        pip3 install --upgrade pip
        python3 -m pip install sigma-cli
}

function File_analizing {
        echo -e ${RED}'Installing File analizing tools'${CYAN}
        sudo -H python3 -m pip install -U oletools[full]
        cd ~/lab
        git clone https://github.com/jesparza/peepdf.git
        cd peepdf
        sed -i '1i#!/usr/bin/python2.7' peepdf.py
        cd ~/lab && cp -r peepdf/ /usr/bin
        cd ~/lab && git clone https://github.com/n0fate/chainbreaker.git && cd chainbreaker/
        python3 setup.py bdist_wheel -d dist
        python3 -m pip install -e .
}

function Misc {
        echo -e ${RED}'Installing Docker'${CYAN}
        sudo mkdir -p /etc/apt/keyrings
        curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        echo -e \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
        sudo docker pull dominicbreuker/stego-toolkit
        sudo usermod -aG docker $USER
        cd ~/lab && git clone https://github.com/TheDarkBug/uwufetch.git && cd uwufetch
        make build
        sudo make install
}

function Stego_Osint {
        echo -e ${RED}'Installing Stego and OSINT tools'${CYAN}
        cd ~/lab
        sudo apt-get install exiftool steghide -y
        sudo gem install zsteg
        wget https://github.com/RickdeJager/stegseek/releases/download/v0.6/stegseek_0.6-1.deb
        chmod +x ./stegseek_0.6-1.deb
        sudo apt-get install ./stegseek_0.6-1.deb -y
        wget http://www.caesum.com/handbook/Stegsolve.jar -O stegsolve.jar
        chmod +x stegsolve.jar
        git clone https://github.com/p1ngul1n0/blackbird
        cd blackbird
        python3 -m pip install -r requirements.txt
        python3 -m pip install pipx
        pipx ensurepath
        pipx install ghunt
        sed -i '1i#!/usr/bin/python3' ~/lab/blackbird/blackbird.py
        sudo cp ~/lab/blackbird/blackbird.py /usr/bin/blackbird.py && sudo chmod +x /usr/bin/blackbird.py
        cd ~/lab
        wget https://mark0.net/download/trid_linux_64.zip && mkdir trid && unzip trid_linux_64.zip -d ./trid
        cd trid && wget https://mark0.net/download/tridupdate.zip && unzip tridupdate.zip
        python3 tridupdate.py
        sudo cp trid /usr/bin/trid && sudo chmod +x /usr/bin/trid
        sudo cp *.trd /usr/bin/
        echo -e "export LANG=/usr/lib/locale/en_US" >> $SHELL_RC_FILE
        cd ~/lab && git clone https://github.com/megadose/holehe.git && cd holehe
        sudo python3 setup.py install
}

function Cracking {
        echo -e ${RED}'Installing Cracking tools & Wordlists'${CYAN}
        sudo apt-get install hashcat -y
        sudo snap install john-the-ripper
        git clone https://github.com/danielmiessler/SecLists.git
        git clone https://github.com/3ndG4me/KaliLists.git
        cd KaliLists/ 
        gunzip rockyou.txt.gz 
        echo "alias 'wordlists'='echo ~/lab/KaliLists ~/lab/SecLists'" >> $SHELL_RC_FILE
        cd ~/lab && git clone https://github.com/Yara-Rules/rules.git
}

function Disk {
        echo -e ${RED}'Installing Autopsy'${CYAN}
        sudo apt-get install -y autopsy ewf-tools
}

function Edit_grub {
        sudo cp /etc/default/grub /etc/default/grub.backup
        echo 'GRUB_DEFAULT=0
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
        Misc
        Edit_grub

        echo -e ${RED}'Press ENTER to continue'${CYAN}
        read a
                sudo apt-get update
                sudo apt-get install -y tree neofetch lolcat bat nala htop bpytop bison flex dwarfdump openssh-server net-tools openvpn dos2unix
                sudo apt-get upgrade -y 
                sudo apt autoremove
                echo -e "export PATH=/usr/bin/peepdf:/home/\$USER/.local/bin:\$PATH" >> $SHELL_RC_FILE
                echo -e ${RED}'Do you want to reboot the system? If not, please do it manually to make sure everything is working fine!'${CYAN}
                read input
        until [[ $input == "Y" || $input == "y" || $input == "N" || $input == "n" ]];
        do
                echo -e ${RED}'Please try again'${CYAN}
                read input
        done
        if [[ $input == "Y" || $input == "y" ]]; then
                sudo reboot -f
        else
                echo -e ${RED}"Please reboot asap ^_^"${CYAN}
        fi
}

Main 2>&1 | tee Installation.log

val="$( cat Installation.log | grep -i "error" -C 10)"
if [[ "$val" ]] ; then 
        cat Installation.log | grep -i "error -C 10" > Error.log 
else
        echo "No error during installation" > Error.log
fi