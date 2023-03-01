#!/bin/bash
RED='\033[0;31m'
CYAN="\033[0;36m"
sudo apt update && sudo apt upgrade -y

mkdir ~/lab
cd ~/lab

echo -e ${RED}'Installing Volatility 2 and 3\n'${CYAN}
    sudo apt install -y curl build-essential git libdistorm3-dev yara libraw1394-11 libcapstone-dev capstone-tool tzdata
    sudo apt install -y python2 python2.7-dev libpython2-dev
    curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
    sudo python2 get-pip.py
    sudo python2 -m pip install -U setuptools wheel
    python2 -m pip install -U distorm3 yara pycryptodome pillow openpyxl ujson pytz ipython capstone construct==2.5.5-reupload
    sudo ln -s /usr/local/lib/python2.7/dist-packages/usr/lib/libyara.so /usr/lib/libyara.so
    python2 -m pip install -U git+https://github.com/volatilityfoundation/volatility.git

    sudo apt install -y python3 python3-dev libpython3-dev python3-pip python3-setuptools python3-wheel
    python3 -m pip install -U distorm3 pillow openpyxl ujson pytz ipython capstone pefile yara-python pycryptodome jsonschema leechcorepyc python-snappy
    python3 -m pip install -U git+https://github.com/volatilityfoundation/volatility3.git
    echo -e "export PATH=/home/$USER/.local/bin:$PATH" >> ~/.bashrc
    git clone https://github.com/superponible/volatility-plugins.git
    sudo cp ~/lab/volatility-plugins/* ~/.local/lib/python2.7/site-packages/volatility/plugins/
    git clone https://github.com/volatilityfoundation/volatility.git

echo -e ${RED}'Press ENTER to continue\n'${CYAN}
read a

echo -e ${RED}'Install tshark and Fakenet\n'${CYAN}
    sudo apt install tshark -y
    wget https://github.com/mandiant/flare-fakenet-ng/releases/download/v1.4.11/fakenet1.4.11.zip

echo -e ${RED}'Install John the Ripper & Hashcat & Wordlists\n'${CYAN}
    sudo apt install hashcat snapd -y
    sudo snap install john-the-ripper
    git clone https://github.com/danielmiessler/SecLists.git
    git clone https://github.com/3ndG4me/KaliLists.git
    cd KaliLists/ 
    gunzip rockyou.txt.gz 
    cd ~ 
    echo "alias 'wordlists'='echo ~/lab/KaliList ~/lab/SecLists'" >> ~/.zshrc

echo -e ${RED}'Install Stego and OSINT tools\n'${CYAN}
    cd ~/lab
    sudo apt install exiftool steghide -y
    sudo gem install zsteg
    wget https://github.com/RickdeJager/stegseek/releases/download/v0.6/stegseek_0.6-1.deb
    chmod 777 ./stegseek_0.6-1.deb
    sudo apt install ./stegseek_0.6-1.deb -y
    sudo apt install default-jre
    wget http://www.caesum.com/handbook/Stegsolve.jar -O stegsolve.jar
    chmod +x stegsolve.jar
    git clone https://github.com/p1ngul1n0/blackbird
    cd blackbird
    python3 -m pip install -r requirements.txt
    python3 -m pip install pipx
    pipx ensurepath
    sudo apt install python3.10-venv -y
    pipx install ghunt
    sed -i '1i#!/usr/bin/python3' ~/lab/blackbird/blackbird.py
    sudo cp ~/lab/blackbird/blackbird.py /usr/bin/blackbird.py

echo -e ${RED}'Press ENTER to continue\n'${CYAN}
read a

echo -e ${RED}'Install oletools\n'${CYAN}
    sudo -H pip3 install -U oletools[full]
    cd ~/lab
    git clone https://github.com/jesparza/peepdf.git
    cd peepdf
    sed -i '1i#!/usr/bin/python2.7' peepdf.py
    sudo cp -r * /usr/bin/
    cd

echo -e ${RED}'Press ENTER to continue\n'${CYAN}
read a
    sudo apt update -y
    sudo apt install -y neofetch lolcat batcat nala htop bpytop bison flex dwarfdump openssh-server net-tools openvpn dos2unix
    sudo apt upgrade -y 

