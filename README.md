# Setup Forensics Environment for Ubuntu VM and WSL

### **Minimum Requirements for UBUNTU-WSL**

- At least 60GB hard drive (WSL cost me around 2x GB of hard disk)
- At least 4-8GB RAM
- Windows Subsystem for Linux version 2
- Ubuntu Distro
- Docker Desktop 

### **Minimum Requirements for UBUNTU-VM**

- At least 128GB hard drive (VM)
- At least 4GB RAM (VM) and 8GB RAM (Host)
- Ubuntu Distro

**THOSE SCRIPTS ARE FOR FRESH AND CLEAN UBUNTU INSTALLATION ONLY**

### **How to setup:**

+ First, clone this repository to your local lab
    
    ```sh
    git clone https://github.com/1259iknowthat/Setup-Linux.git
    ```

+ Second, change dir to the repo and change the permission of all `.sh` files (or just one depend on your decision).
    
    ```sh
    cd Setup-Linux
    chmod +x ubuntu.sh
    chmod +x ubuntu-wsl.sh
    ```

+ Last, run the `.sh` file:
    
    ```
    ./ubuntu.sh //if you are in ubuntu virtual machine or actual os
    ./ubuntu-wsl.sh //if you are using WSL on Windows
    ```
    
    + If you encountered some errors on the first attemp running `sh` file, please try this:

    ```sh
    sudo apt install dos2unix -y
    dos2unix <sh file>
    ./<sh file>
    ```


Refs:


https://github.com/superponible/volatility-plugins

https://linuxhint.com/sleuth_kit_autopsy/

https://github.com/DominicBreuker/stego-toolkit

https://seanthegeek.net/1172/how-to-install-volatility-2-and-volatility-3-on-debian-ubuntu-or-kali-linux/
