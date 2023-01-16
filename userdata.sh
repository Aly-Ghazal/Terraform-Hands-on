#!/usr/bin/bash
apt update -y
apt install -y nginx
systemctl enable --now nginx