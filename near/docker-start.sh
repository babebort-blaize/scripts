#/bin/bash

set -x
set -e


sudo apt-get update -y 
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release wget

sudo mkdir -p /etc/apt/keyrings && \
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg

echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

sudo apt-get update -y && sudo apt install docker-ce docker-ce-cli \
    containerd.io docker-compose-plugin httpie -y

docker run -v $HOME/.near:/root/.near -p 3030:3030 -d --name nearup nearup/nearprotocol run localnet

sleep 20

http post http://127.0.0.1:3030  jsonrpc=2.0 id=dontcare method=tx \
   params:='[ "6zgh2u9DqHHiXzdy9ouTP7oGky2T4nugqzqt9wJZwNFm", "sender.mainnet"]'
