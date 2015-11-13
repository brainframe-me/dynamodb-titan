#!/usr/bin/env bash
# Update ubuntu
apt-get update && apt-get -y upgrade

# remove no longer used kernels
apt-get -y autoremove

# Download & install Docker (if not already installed)
sudo apt-get -y install docker.io rsync

# Add vagrant user to docker group so docker runs as vagrant instead of root
sudo usermod -aG docker vagrant

# This part syncs the local code from /vagrant to /local while applying git ignore
sudo mkdir /local
sudo rsync -avu --filter=':- /vagrant/.gitignore' /vagrant/ /local/
sudo chown -R vagrant:vagrant /local

# Download docker for dynamodb-local
echo "Downloading brainframe/dynamodb-local..."
docker pull brainframe/dynamodb-local

# Download docker for titan-on-dynamodb
echo "Downloading and starting brainframe/titan-on-dynamodb..."
docker pull brainframe/titan-on-dynamodb

# Start docker for dynamodb-local
echo "Starting brainframe/dynamodb-local..."
docker run -d --name dynamodb-local -p 8000:8000 brainframe/dynamodb-local

# Start docker for titan-on-dynamodb
echo "Starting brainframe/titan-on-dynamodb..."
docker run -d --name titan-on-dynamodb --link dynamodb-local:dynamodb-local -p 8182:8182 -p 8183:8183 -p 8184:8184 -e DYNAMODB_HOSTPORT=http://dynamodb-local:8000 -e AWS_ACCESS_KEY_ID=notcheckedlocallybutmustbeprovided -e AWS_SECRET_ACCESS_KEY=notcheckedlocallybutmustbeprovided -e GRAPH_NAME=yourdatabasename brainframe/titan-on-dynamodb &

# Background message
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"
echo "If this is the first time you do vagrant up, the dockers that need to be downloaded in the background will take a while (+-2GB)."
echo "They will only start after the download of the images is completed, so count on 2-5 minutes before testing."
echo "Once the images are in vagrant, a new 'vagrant provision' will go quickly and immediately start the dockers"
echo ""
echo "Try in your browser: http://localhost:8182/graphs"
echo "!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!"