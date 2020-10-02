#!/bin/bash
## Install JDK
sudo apt update
sudo apt install openjdk-8-jdk openjdk-8-jre -y
java -version
sudo apt-get -y install jq apt-transport-https


## Install Halyard
curl -O https://raw.githubusercontent.com/spinnaker/halyard/master/install/debian/InstallHalyard.sh
sudo bash InstallHalyard.sh --user ubuntu
hal -v
hal -h
sleep 5s

# Install Docker
PRIVATE_IP=`curl -X GET "http://169.254.169.254/latest/meta-data/local-ipv4"`
curl -fsSL get.docker.com -o get-docker.sh
sh get-docker.sh
sudo usermod -aG docker ubuntu
sudo docker run -p $PRIVATE_IP:9090:9000 -d --name minio1 -v /mnt/data:/data -v /mnt/config:/root/.minio minio/minio server /data

MINIO_SECRET_KEY="minioadmin"
MINIO_ACCESS_KEY="minioadmin"

echo $MINIO_SECRET_KEY | hal config storage s3 edit --endpoint http://$PRIVATE_IP:9090 \
    --access-key-id $MINIO_ACCESS_KEY \
    --secret-access-key

hal config storage edit --type s3
echo -e "NOTE: If the 'docker container ls' command is not working instantly, logout from current session and login again. It will be working fine"
