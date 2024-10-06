#!/bin/bash

# อัพเดตและติดตั้งแพ็กเกจที่จำเป็น
sudo apt update
sudo apt install curl git make jq build-essential gcc unzip wget lz4 aria2 -y

# สร้างไดเรกทอรีและเพิ่ม $HOME/go/bin ลงใน PATH
mkdir -p $HOME/go/bin
echo 'export PATH=$PATH:$HOME/go/bin' >> $HOME/.bash_profile
source $HOME/.bash_profile

# โหลดไฟล์และติดตั้ง Story-Geth
wget https://story-geth-binaries.s3.us-west-1.amazonaws.com/geth-public/geth-linux-amd64-0.9.3-b224fdf.tar.gz
tar -xzvf geth-linux-amd64-0.9.3-b224fdf.tar.gz
sudo cp geth-linux-amd64-0.9.3-b224fdf/geth $HOME/go/bin/story-geth

# ตรวจสอบเวอร์ชัน Story-Geth
story-geth version

# โหลดไฟล์และติดตั้ง Story
wget https://story-geth-binaries.s3.us-west-1.amazonaws.com/story-public/story-linux-amd64-0.10.1-57567e5.tar.gz
tar -xzvf story-linux-amd64-0.10.1-57567e5.tar.gz
cp $HOME/story-linux-amd64-0.10.1-57567e5/story $HOME/go/bin

# ตรวจสอบเวอร์ชัน Story
story version

# รับค่า input ชื่อโหนดจากผู้ใช้
read -p "Input Name NOde : " moniker

# สร้างคอนฟิกโดย Init
story init --network iliad --moniker "$moniker"

# สร้างไฟล์ Service สำหรับรัน Story-geth
sudo tee /etc/systemd/system/story-geth.service > /dev/null <<EOF
[Unit]
Description=Story Geth Client
After=network.target

[Service]
User=root
ExecStart=/root/go/bin/story-geth --iliad --syncmode full
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

# สร้างไฟล์ Service สำหรับรัน Story
sudo tee /etc/systemd/system/story.service > /dev/null <<EOF
[Unit]
Description=Story Consensus Client
After=network.target

[Service]
User=root
ExecStart=/root/go/bin/story run
Restart=on-failure
RestartSec=3
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

# โหลดไฟล์และ Start Story-geth service
sudo systemctl daemon-reload
sudo systemctl start story-geth
sudo systemctl enable story-geth
sudo systemctl status story-geth

# จับ Logs ของ Story-geth
sudo journalctl -u story-geth -f -o cat &

# โหลดไฟล์และ Start Story service
sudo systemctl start story
sudo systemctl enable story
sudo systemctl status story

# จับ Logs ของ Story
sudo journalctl -u story -f -o cat
