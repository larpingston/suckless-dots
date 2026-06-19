#!/bin/sh
set -e

doas pacman -S --noconfirm docker docker-dinit docker-compose

doas dinitctl enable dockerd

mkdir -p ~/searxng && cd ~/searxng

cat > docker-compose.yml << 'EOF'
services:
  searxng:
    image: searxng/searxng
    ports:
      - "8080:8080"
    volumes:
      - ./searxng-config:/etc/searxng
    restart: unless-stopped
EOF

doas docker-compose up -d
