# Setup Forensics Environment for Ubuntu VM and WSL

# **ATTENTION!!!**:

## **This script is tested with Ubuntu 22.04.2 and older releases. I'm working on Ubuntu 23.04 now.**

### **Minimum Requirements for UBUNTU-WSL**

- At least 60GB hard drive (WSL cost me around 2x GB of hard disk)
- At least 4-8GB RAM
- Windows Subsystem for Linux version 2
- Ubuntu Distro 

### **Minimum Requirements for UBUNTU-VM**

- At least 128GB hard drive (VM)
- At least 4GB RAM (VM) and 8GB RAM (Host)
- Ubuntu Distro

**THOSE SCRIPTS ARE FOR FRESH AND CLEAN UBUNTU INSTALLATION ONLY**

### **How to setup:**

+ First, clone this repository to your local lab
    
    ```sh
    git clone https://github.com/1259iknowthat/ForVM.git
    ```

+ Second, change dir to the repo and change the permission of all `.sh` files (or just one depend on your decision).
    
    ```sh
    cd ForVM
    chmod +x ubuntu.sh
    chmod +x ubuntu-wsl.sh
    ```

+ Last, run the `.sh` file:
    
    ```
    ./ubuntu.sh     //if you are in ubuntu virtual machine
    ./ubuntu-wsl.sh     //if you are using WSL on Windows
    ```

### Something you shouldn't miss:

+ You can use this command to check if there's any error package while installing: `cat Installation.log | grep -i "ERROR"`. `Installation.log` is located at the folder where you put the install script.

+ Tools is listed at `Tools.md` file.

+ Open an `Issues` session if you have any problems while installing.

+ If you want to contribute to this small project, you can open a pull request.