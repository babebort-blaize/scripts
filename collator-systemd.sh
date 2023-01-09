#/bin/bash

set -x
set -e

NODE_NAME="BLAIZE-NODE-TEST"


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


wget $(curl -s https://api.github.com/repos/AstarNetwork/Astar/releases/latest | grep "tag_name" | awk '{print "https://github.com/AstarNetwork/Astar/releases/download/" substr($2, 2, length($2)-3) "/astar-collator-v" substr($2, 3, length($2)-4) "-ubuntu-x86_64.tar.gz"}')


tar -xvf astar-collator*.tar.gz

mv astar-collator /usr/local/bin/astar-collator

echo '[Unit]
Description=Astar Collator

[Service]
User=astar
Group=astar
  
ExecStart=/usr/local/bin/astar-collator \
  --collator \
  --rpc-cors all \
  --name BLAIZE-NODE \
  --chain astar \
  --base-path /var/lib/astar \
  --telemetry-url 'wss://telemetry.polkadot.io/submit/ 0' \
  --execution wasm

Restart=always
RestartSec=120

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/astar.service

sudo systemctl enabled astar
sudo systemctl start astar.service
