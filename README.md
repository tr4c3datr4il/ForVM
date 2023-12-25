# Setup Forensics Environment for Ubuntu VM and WSL

### **Minimum Requirements for UBUNTU-WSL**

- At least 60GB hard drive (WSL cost me around 2x GB of hard disk)
- At least 4-8GB RAM
- Windows Subsystem for Linux version 2
- Ubuntu Distro (Tested with 22.04.2)

### **Minimum Requirements for UBUNTU-VM**

- At least 128GB hard drive (VM)
- At least 4GB RAM (VM) and 8GB RAM (Host)
- Ubuntu Distro (Tested with 22.04.2)

**THOSE SCRIPTS ARE FOR FRESH AND CLEAN UBUNTU INSTALLATION ONLY**

### **How to setup:**

+ First, clone this repository to your local lab
    
    ```sh
    git clone https://github.com/tr4c3datr4il/ForVM.git
    ```

+ Second, change dir to the repo and change the permission of **install.sh** file.
    
    ```sh
    cd ForVM
    chmod +x install.sh
    ```

+ Last, run the install file:
    
    ```
    ./install.sh
    ```

### Something you shouldn't miss:

+ You can use this command to check if there's any error package while installing: **cat Installation.log | grep -i "ERROR"**. **Installation.log** is located at the folder where you put the install script.

+ Tools is listed at `Tools.md` file.

+ Open an `Issues` session if you have any problems while installing.

+ If you want to contribute to this small project, you can open a `Pull requests`.
