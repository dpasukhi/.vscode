#!/bin/bash

# Update repository
sudo apt update

# special terminal helper
sudo apt-get install -y rlwrap

# perf
if [ -f /etc/lsb-release ]; then
    # Ubuntu
    sudo apt-get update
    sudo apt-get install -y linux-tools-common linux-tools-generic linux-tools-`uname -r`
elif [ -f /etc/debian_version ]; then
    # Debian
    sudo apt-get update
    sudo apt-get install -y linux-perf
else
    echo "Unsupported Debian-based OS"
fi

# valgrind
sudo apt-get install -y valgrind

# boost
sudo apt-get install -y libboost-dev

sudo apt install -y nodejs

# debugging option
sudo sysctl kernel.perf_event_paranoid=-1
sudo sysctl kernel.yama.ptrace_scope=0

# setting up git profile
username=$(git config --global user.name)
git config --global user.email "${username}@opencascade.com"

wget https://apt.llvm.org/llvm.sh
chmod +x llvm.sh
sudo ./llvm.sh 20 all

# Add the repository to the sources list
echo "deb http://ftp.de.debian.org/debian sid main" | sudo tee -a /etc/apt/sources.list

# Update the package list
sudo apt update

# Install the cmake package
sudo apt install -y cmake
