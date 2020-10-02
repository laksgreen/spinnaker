#!/bin/bash

sudo fallocate -l 8G /swapspace
sudo chmod 600 /swapspace
sudo mkswap /swapspace
echo '/swapspace none swap sw 0 0' | sudo tee -a /etc/fstab
sudo swapon /swapspace
