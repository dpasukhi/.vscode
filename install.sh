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

# Download and install CMake 3.30.4
wget https://github.com/Kitware/CMake/releases/download/v3.30.4/cmake-3.30.4-Linux-x86_64.sh
chmod +x cmake-3.30.4-Linux-x86_64.sh
sudo ./cmake-3.30.4-Linux-x86_64.sh --prefix=/usr/local --skip-license

# First time initialization
mkdir -p ~/work
cd ~/work

# Create OCCT directory
if [ ! -d "$HOME/work/OCCT" ]; then
  GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git clone git@github.com:Open-Cascade-SAS/OCCT.git
  git clone git@github.com:Open-Cascade-SAS/OCCT.git
  cd "$HOME/work/OCCT"
  git remote add old gitolite@git.dev.opencascade.org:occt

  mkdir -p build
  cd "$HOME/work/OCCT/build"

  cmake -DCMAKE_BUILD_TYPE:STRING=Debug -DCMAKE_INSTALL_PREFIX:STRING=/home/coder/work/OCCT/install -D3RDPARTY_DIR=/mnt/dn29/coder-occt/3rdparty -DCMAKE_C_FLAGS_DEBUG="-g -fno-limit-debug-info -glldb" -DCMAKE_CXX_FLAGS_DEBUG="-g -fno-limit-debug-info -glldb" -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -DCMAKE_C_COMPILER:FILEPATH=/usr/bin/clang-20 -DCMAKE_CXX_COMPILER:FILEPATH=/usr/bin/clang++-20 --no-warn-unused-cli -S/home/coder/work/OCCT -B/home/coder/work/OCCT/build -G Ninja
fi

# Create PROD directory
if [ ! -d "$HOME/work/occt-products" ]; then
  GIT_SSH_COMMAND="ssh -o StrictHostKeyChecking=no" git clone occ@git.nnov.opencascade.com:occt-products.git
  git clone occ@git.nnov.opencascade.com:occt-products.git
  cd "$HOME/work/occt-products"

  mkdir -p build
  cd "$HOME/work/occt-products/build"

  cmake -DCMAKE_BUILD_TYPE:STRING=Debug -DCMAKE_INSTALL_PREFIX:STRING=/home/coder/work/occt-products/install -D3RDPARTY_DIR=/mnt/dn29/coder-occt/3rdparty -DCMAKE_C_FLAGS_DEBUG="-g -fno-limit-debug-info -glldb" -DCMAKE_CXX_FLAGS_DEBUG="-g -fno-limit-debug-info -glldb" -DCMAKE_EXPORT_COMPILE_COMMANDS:BOOL=TRUE -DCMAKE_C_COMPILER:FILEPATH=/usr/bin/clang-20 -DCMAKE_CXX_COMPILER:FILEPATH=/usr/bin/clang++-20 --no-warn-unused-cli -S/home/coder/work/occt-products -B/home/coder/work/occt-products/build -G Ninja
fi
