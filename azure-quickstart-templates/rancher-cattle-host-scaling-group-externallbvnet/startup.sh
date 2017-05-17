#!/bin/bash

# Update Ubuntu

apt-get update

# Setup Cattle Storage Mount

./addfileshare.sh $STORAGE_ACCOUNT_NAME $STORAGE_ACCESS_KEY cattlestorage

mkdir /mnt/cattlestorage

mount -t cifs //$STORAGE_ACCOUNT_NAME.file.core.windows.net/cattlestorage /mnt/cattlestorage -o vers=3.0,username=$STORAGE_ACCOUNT_NAME,password=$STORAGE_ACCESS_KEY,dir_mode=0777,file_mode=0777

fstab=/etc/fstab

if [[ !$(grep -q "/mnt/cattlestorage" "$fstab") ]]
then
     echo -e "#Cattle Azure File Storage\n//$STORAGE_ACCOUNT_NAME.file.core.windows.net/cattlestorage /mnt/cattlestorage cifs vers=3.0,username=$STORAGE_ACCOUNT_NAME,password=$STORAGE_ACCESS_KEY,dir_mode=0777,file_mode=0777\n$(cat $fstab)" > $fstab
else
    echo "Entry in fstab exists."
fi

# Remove bad mount https://bugs.launchpad.net/ubuntu/+source/cloud-init/+bug/1603222

sed -i '/azure_resource/d' $fstab

# Setup ZFS

apt-get install -y software-properties-common zfs python-pip

zpool create -f zpool-docker /dev/sdc

zfs create -o mountpoint=/var/lib/docker zpool-docker/docker

# Install Docker

apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D

apt-add-repository 'deb https://apt.dockerproject.org/repo ubuntu-xenial main'

apt-get update

apt-cache policy docker-engine

apt-get install -y docker-engine=$DOCKER_VERSION-0~ubuntu-xenial

# Write Docker config

cat <<EOF > /etc/systemd/system/docker.service
[Service]
ExecStart=/usr/bin/docker daemon --storage-driver=zfs

[Install]
WantedBy=multi-user.target
EOF

# Restart Docker

systemctl daemon-reload

systemctl restart docker

# Add rancher user to docker group

usermod -aG docker $ADMIN_USERNAME

# Auto join Rancher Agent

pip install requests

python rancherautojoin.py