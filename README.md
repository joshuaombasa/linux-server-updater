# Linux Server Updater

This project automates security updates on  Linux servers using a simple Bash script.

## Features
- SSH into multiple servers
- Perform updates automatically
- Log success/failure of each server
- Reboot servers if needed

## Requirements
- Linux/MacOS environment
- SSH key-based authentication to servers
- `bash`, `ssh`, `tee`, and standard utilities installed

## Usage
1. Update `servers_list.txt` with your  server hostnames/IPs.
2. Edit `update_servers.sh` if needed (e.g., username, package manager).
3. Run manually or schedule it using `cron`:
   ```bash
   bash update_servers.sh
