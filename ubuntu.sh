!/bin/bash
red='\033[0;31m'
cyan="\033[0;36m"
sudo apt update && sudo apt upgrade -y

mkdir ~/lab
cd ~/lab

echo -e ${red}'installing volatility 2 and 3\n'${cyan}
        sudo apt install -y curl build-essential git libdistorm3-dev yara libraw1394-11 libcapstone-dev capstone-tool tzdata
        sudo apt install -y python2 python2.7-dev libpython2-dev
        curl https://bootstrap.pypa.io/pip/2.7/get-pip.py --output get-pip.py
        sudo python2 get-pip.py
        sudo python2 -m pip install -U setuptools wheel
        python2 -m pip install -U distorm3 yara pycryptodome pillow openpyxl ujson pytz ipython capstone
        python2 -m pip install yara
        pip2 install construct==2.5.5-reupload
        sudo ln -s /usr/local/lib/python2.7/dist-packages/usr/lib/libyara.so /usr/lib/libyara.so
        python2 -m pip install -U git+https://github.com/volatilityfoundation/volatility.git

        sudo apt install -y python3 python3-dev libpython3-dev python3-pip python3-setuptools python3-wheel
        python3 -m pip install -U distorm3 pillow openpyxl ujson pytz ipython capstone pefile yara-python pycryptodome jsonschema leechcorepyc python-snappy
        python3 -m pip install -U git+https://github.com/volatilityfoundation/volatility3.git
        echo -e "export path=/home/$user/.local/bin:$path" >> ~/.bashrc
        git clone https://github.com/superponible/volatility-plugins.git
        sudo cp ~/lab/volatility-plugins/* ~/.local/lib/python2.7/site-packages/volatility/plugins/
        git clone https://github.com/volatilityfoundation/volatility.git

echo -e ${red}'press enter to continue\n'${cyan}
read a
echo -e ${red}'installing docker\n'${cyan}
        sudo apt install gnome-terminal -y
        sudo apt update
        sudo apt install ca-certificates gnupg lsb-release -y
        sudo mkdir -p /etc/apt/keyrings
        curl -fssl https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
        echo -e \
        "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
        $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
        sudo apt-get update -y
        sudo apt-get install docker-ce docker-ce-cli containerd.io docker-compose-plugin -y
        sudo docker pull dominicbreuker/stego-toolkit
        sudo usermod -ag docker $user

echo -e ${red}'press enter to continue\n'${cyan}
read a

echo -e ${red}'install autopsy\n'${cyan}
        sudo apt install -y autopsy

echo -e ${red}'install wireshark and fakenet\n'${cyan}
        sudo apt install wireshark -y
        echo -e ${red}'please make sure you choose "yes" while installing wireshark\n'${cyan}
        read a
        sudo dpkg-reconfigure wireshark-common
        sudo usermod -a -g wireshark ubuntu
        sudo apt install tshark -y
        wget https://github.com/mandiant/flare-fakenet-ng/releases/download/v1.4.11/fakenet1.4.11.zip

echo -e ${red}'install john the ripper & hashcat & wordlists\n'${cyan}
        sudo apt install hashcat snapd -y
        sudo snap install john-the-ripper
        git clone https://github.com/danielmiessler/seclists.git
        git clone https://github.com/3ndg4me/kalilists.git
        cd kalilists/ 
        gunzip rockyou.txt.gz 
        cd ~ 
        echo "alias 'wordlists'='echo ~/lab/kalilist ~/lab/seclists'" >> ~/.zshrc

echo -e ${red}'install stego and osint tools\n'${cyan}
        cd ~/lab
        sudo apt install exiftool steghide -y
        sudo gem install zsteg
        wget https://github.com/rickdejager/stegseek/releases/download/v0.6/stegseek_0.6-1.deb
        chmod 777 ./stegseek_0.6-1.deb
        sudo apt install ./stegseek_0.6-1.deb -y
        sudo apt install default-jre
        wget http://www.caesum.com/handbook/stegsolve.jar -o stegsolve.jar
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

echo -e ${red}'press enter to continue\n'${cyan}
read a

echo -e ${red}'install oletools\n'${cyan}
        sudo -h python3 -m pip install -U oletools[full]
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
        echo -e ${RED}'Do you want to reboot the system? If not, please do it manually to make sure everything is working fine!\n'${CYAN}
read input
until [ $input == "Y" || $input == "y" || $input == "N" || $input == "n" ]
do
        echo -e ${RED}'Please try again'
        read input
done
if [[ $input == "Y" || $input == "y" ]]; then
        sudo reboot -f
else
        echo -e "Please reboot asap ^_^"
fi
#2>&1 | tee install_log.txt
