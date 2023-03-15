#!/bin/bash

# Update the system and install dependencies
sudo apt-get update && sudo apt-get upgrade -y
sudo apt-get install -y curl git

# Install Docker
curl -fsSL https://get.docker.com -o get-docker.sh
sudo sh get-docker.sh
sudo usermod -aG docker $USER
rm get-docker.sh

# Install Docker Compose
sudo curl -L "https://github.com/docker/compose/releases/download/1.29.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose

# Create directories for each service
mkdir -p ~/nginx-proxy-manager ~/plex ~/emby ~/jellyfin ~/portainer ~/watchtower

# NGINX Proxy Manager
cat > ~/nginx-proxy-manager/docker-compose.yml <<EOL
version: "3"
services:
  app:
    image: jc21/nginx-proxy-manager:latest
    restart: always
    ports:
      - 80:80
      - 81:81
      - 443:443
    environment:
      DB_MYSQL_HOST: db
      DB_MYSQL_PORT: 3306
      DB_MYSQL_USER: npm
      DB_MYSQL_PASSWORD: npm
      DB_MYSQL_NAME: npm
    volumes:
      - ./data:/data
      - ./letsencrypt:/etc/letsencrypt
  db:
    image: mariadb:latest
    restart: always
    environment:
      MYSQL_ROOT_PASSWORD: npm
      MYSQL_DATABASE: npm
      MYSQL_USER: npm
      MYSQL_PASSWORD: npm
    volumes:
      - ./mysql:/var/lib/mysql
EOL

# Plex
cat > ~/plex/docker-compose.yml <<EOL
version: "3"
services:
  plex:
    image: plexinc/pms-docker:latest
    restart: always
    ports:
      - 32400:32400/tcp
    environment:
      - PLEX_CLAIM=change_me # Retrieve at https://www.plex.tv/claim/
      - ADVERTISE_IP=http://your_external_ip:32400/
      - TZ=Your_Time_Zone # IE: America/Chicago
    devices:
      - /dev/dri:/dev/dri
    volumes:
      - ./config:/config
      - ./transcode:/transcode
      - /path/to/your/media:/media
EOL

# Emby
cat > ~/emby/docker-compose.yml <<EOL
version: "3"
services:
  emby:
    image: emby/embyserver:latest
    restart: always
    ports:
      - 8096:8096
      - 8920:8920
    environment:
      - UID=1000
      - GID=1000
      - GIDLIST=1000
    devices:
      - /dev/dri:/dev/dri
    volumes:
      - ./config:/config
      - ./cache:/cache
      - /path/to/your/media:/media
EOL

# Jellyfin
cat > ~/jellyfin/docker-compose.yml <<EOL
version: "3"
services:
  jellyfin:
    image: jellyfin/jellyfin:latest
    restart: always
    ports:
      - 8097:8096
      - 8921:8920
    environment:
      - TZ=Your_Time_Zone # IE: America/Chicago
    devices:
      - /dev/dri:/dev/dri
    volumes:
      - ./config:/config
      - ./cache:/cache
      - /path/to/your/media:/media
EOL

# Portainer
cat > ~/portainer/docker-compose.yml <<EOL
version: '3.3'
services:
  portainer:
    image: portainer/portainer-ce:latest
    restart: always
    ports:
      - 9000:9000
      - 8000:8000
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
      - ./data:/data
EOL

# Watchtower
cat > ~/watchtower/docker-compose.yml <<EOL
version: '3'
services:
  watchtower:
    image: containrrr/watchtower
    restart: always
    volumes:
      - /var/run/docker.sock:/var/run/docker.sock
EOL

# Start NGINX Proxy Manager
(cd ~/nginx-proxy-manager && docker-compose up -d)

# Start Plex
(cd ~/plex && docker-compose up -d)

# Start Emby
(cd ~/emby && docker-compose up -d)

# Start Jellyfin
(cd ~/jellyfin && docker-compose up -d)

# Start Portainer
(cd ~/portainer && docker-compose up -d)

# Start Watchtower
(cd ~/watchtower && docker-compose up -d)

# Add a cron job for Watchtower to update containers weekly on Saturday at 2:00 AM local time of server.
(crontab -l 2>/dev/null; echo "0 2 * * 6 cd ~/watchtower && docker-compose up -d") | crontab -
