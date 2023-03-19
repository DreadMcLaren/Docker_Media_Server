# Docker Media Server
Install Docker, Docker-Compose, Nginx Proxy Manager, Portainer, Plex, Emby, Jellyfin and Watchtower on Linux.

# Instructions:

**The following instructions were created using Ubuntu, assumes you have the proper ports exposed, and logged in as root or a user with sudo privileges.**

1. Clone the github repository
```
sudo git clone https://github.com/DreadMcLaren/Docker_Media_Server.git
```

2. Navigate to where you cloned ```install.sh```
```
sudo cd path/to/Docker_Media_Server
```

3. Make ```install.sh``` executable by running
```
sudo chmod +x install.sh
```

4. Open ```install.sh``` and adjust the values to meet your requirements
```
sudo nano install.sh
```

5. Required values to change:
```
Plex:
PLEX_CLAIM=change_me
ADVERTISE_IP=http://your_external_ip:32400/
TZ=Your_Time_Zone
/path/to/your/media:/media
```
```
Emby:
/path/to/your/media:/media
```
```
Jellyfin:
TZ=Your_Time_Zone
/path/to/your/media:/media
```

6. Save the file ```(CTRL + X)``` and keep the filename the same

7. Execute the script:
```
sudo ./install.sh
```


Everything will now download, install and start automatically. You can get to each application by navigating to the url below:

- **NGINX Proxy Manager:** http://localhost:81 **OR** http://your_external_ip:81
- **Plex:** http://localhost:32400/web **OR** http://your_external_ip:32400/web
- **Emby:** http://localhost:8096 **OR** http://your_external_ip:8096
- **Jellyfin:** http://localhost:8097 **OR** http://your_external_ip:8097
- **Portainer:** http://localhost:9000 **OR** http://your_external_ip:9000
