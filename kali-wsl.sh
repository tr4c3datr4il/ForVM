#!/bin/bash
RED='\033[0;31m'
GREEN='\033[0;32m'

sudo apt update
sudo apt install -y kali-linux-large
sudo apt update && sudo apt upgrade
sudo apt install xrdp -y 
printf ${RED}'Press ENTER to continue\n'${GREEN}
read a

printf ${RED}'Install win-kex environment\n'${GREEN}
sudo apt install -y kali-win-kex
sudo apt update && sudo apt upgrade

printf ${RED}'Install Volatility 2 and 3\n'${GREEN}
sudo apt install -y build-essential git libdistorm3-dev yara libraw1394-11 libcapstone-dev capstone-tool tzdata
sudo apt install -y python2 python2.7-dev libpython2-dev
curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
sudo python2 get-pip.py
sudo python2 -m pip install -U setuptools wheel
python2 -m pip install -U distorm3 yara pycrypto pillow openpyxl ujson pytz ipython capstone
sudo python2 -m pip install yara
sudo ln -s /usr/local/lib/python2.7/dist-packages/usr/lib/libyara.so /usr/lib/libyara.so
python2 -m pip install -U git+https://github.com/volatilityfoundation/volatility.git
sudo apt install -y python3 python3-dev libpython3-dev python3-pip python3-setuptools python3-wheel
python3 -m pip install -U distorm3 yara pycrypto pillow openpyxl ujson pytz ipython capstone
python3 -m pip install -U git+https://github.com/volatilityfoundation/volatility3.git
cp /mnt/d/WSL_LAB/Tools/volatility-plugins/* ~/.local/lib/python2.7/site-packages/volatility/plugins/
echo 'export PATH=/home/kali/.local/bin:$PATH' >> ~/.bashrc
printf ${RED}'Press ENTER to continue\n'${GREEN}
read a

sudo apt update
sudo apt install neofetch lolcat htop bpytop
sudo apt upgrade 

