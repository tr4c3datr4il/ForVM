#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'
sudo apt-get update
printf ${RED}'Install Volatility 2 and 3\n'${GREEN}
sudo apt-get install -y build-essential git libdistorm3-dev yara libraw1394-11 libcapstone-dev capstone-tool tzdata
sudo apt-get install -y python2 python2.7-dev libpython2-dev
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
sudo python2 get-pip.py
sudo python2 -m pip install -U setuptools wheel
python2 -m pip install -U distorm3 yara pycrypto pillow openpyxl ujson pytz ipython capstone
sudo python2 -m pip install yara
sudo ln -s /usr/local/lib/python2.7/dist-packages/usr/lib/libyara.so /usr/lib/libyara.so
python2 -m pip install -U git+https://github.com/volatilityfoundation/volatility.git
sudo apt install -y python3 python3-dev libpython3-dev python3-pip python3-setuptools 
sudo apt install -y python3-wheel
python3 -m pip install -U distorm3 yara pycrypto pillow openpyxl ujson pytz ipython capstone
python3 -m pip install -U git+https://github.com/volatilityfoundation/volatility3.git
echo 'export PATH=/home/ubuntu/.local/bin:$PATH' >> ~/.bashrc
sudo apt install -y git 
git clone https://github.com/superponible/volatility-plugins.git
sudo cp ~/lab/volatility-plugins/* ~/.local/lib/python2.7/site-packages/volatility/plugins
read -n 1 -r -s -p "Press any key to continue...\n" key 
printf ${RED}'Install Docker\n'${GREEN}
sudo apt install gnome-terminal
sudo apt-get update
sudo apt-get install ca-certificates curl gnupg lsb-release
sudo mkdir -p /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt-get update
sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin
docker pull dominicbreuker/stego-toolkit
read -n 1 -r -s -p "Press any key to continue...\n" key
printf ${RED}'Install Metasploit\n'${GREEN}
curl https://raw.githubusercontent.com/rapid7/metasploit-omnibus/master/config/templates/metasploit-framework-wrappers/msfupdate.erb > msfinstall && chmod 755 msfinstall && ./msfinstall
printf ${RED}'Install Autopsy\n'${GREEN}
sudo apt install -y autopsy
read -n 1 -r -s -p "Press any key to continue...\n" key
sudo apt update
sudo apt install -y neofetch lolcat htop bpytop
sudo apt upgrade 