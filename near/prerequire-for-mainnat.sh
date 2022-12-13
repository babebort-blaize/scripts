#/bin/bash

set -x
#set -e

sudo apt purge containerd.io  docker docker-engine docker.io containerd 
runc docker-ce -y 
#sudo apt purge docker.io -y


sudo apt-get update -y 
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release wget

sudo mkdir -p /etc/apt/keyrings
rm -f /etc/apt/keyrings/docker.gpg
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg 
--dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) 
signed-by=/etc/apt/keyrings/docker.gpg] 
https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee 
/etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y 

sudo apt install docker-ce docker-ce-cli containerd.io 
docker-compose-plugin httpie -y

export DEBIAN_FRONTEND=noninteractive; \
   export DEBCONF_NONINTERACTIVE_SEEN=true; \
   echo 'tzdata tzdata/Areas select Etc' | debconf-set-selections; \
   echo 'tzdata tzdata/Zones/Etc select UTC' | debconf-set-selections; \
   apt-get update -qqy && apt-get install -qqy --no-install-recommends \
   tzdata && apt update -y && apt install -y git binutils-dev libcurl4-openssl-dev zlib1g-dev libdw-dev libiberty-dev \
   cmake gcc g++  protobuf-compiler libssl-dev pkg-config clang llvm cargo awscli


curl https://sh.rustup.rs -sSf | bash -s -- -y
echo 'PATH="/root/.cargo/bin:${PATH}"' >> ~/.bashrc
source ~/.bashrc

rustup update stable

sudo apt install python3 python3-pip python3-dev -y

pip3 install --upgrade pip

pip3 install --user nearup

echo 'USER_BASE_BIN=$(python3 -m site --user-base)/bin
export PATH="$USER_BASE_BIN:$PATH"' >> ~/.bashrc
source ~/.bashrc

pip3 install --user --upgrade nearup


python3 -m pip install --upgrade pip wheel
python3 -m pip install httpie
python3 -m pip install --upgrade pip wheel
python3 -m pip install --upgrade httpie

cd / 
git clone https://github.com/near/nearcore.git
cd nearcore
#make neard
make release
