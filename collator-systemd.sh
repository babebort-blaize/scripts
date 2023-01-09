#/bin/bash

set -x
set -e

NODE_NAME="BLAIZE-NODE"


sudo apt-get update -y 
sudo apt-get install -y \
    ca-certificates \
    curl \
    gnupg \
    lsb-release wget

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
  --name ${NODE_NAME} \
  --chain astar \
  --base-path /var/lib/astar \
  --telemetry-url 'wss://telemetry.polkadot.io/submit/ 0' \
  --execution wasm

Restart=always
RestartSec=120

[Install]
WantedBy=multi-user.target' > /etc/systemd/system/astar.service

systemctl enable astar
systemctl start astar.service
systemctl status astar
