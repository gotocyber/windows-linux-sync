# Windows-to-Linux Automated Rsync Bridge

#### Back Story: 
##### I want to learn ssh in deeper sense. That's why this solution came into picture. 
##### I have encountered ssh before but only using it without understanding how it really works. Let me share to you what I have learned.

The standard syntax looks like this:
*ssh username@remote_host_or_IP*

Checking for the SSH Client: 
*Open your terminal (Linux) or PowerShell (Windows) and type ssh -V*

Verify that the server software is running on your Ubuntu machine:
*sudo systemctl status ssh*

Note: On Linux, the client (which lets you connect out) and the server (which lets others connect in) are often separate packages.

Let's get that service set up so your Windows machine can find it. You'll need to run these commands in your Ubuntu terminal:

Update your package list: *sudo apt update*

Install the OpenSSH Server: *sudo apt install openssh-server*

Reminder: Both machine has to be in the same subnet otherwise, in my case I use the port-forwarding which I will tell a story in the different repository.



🚀 Overview

A lightweight, robust solution for daily incremental backups from a Windows workstation to a Linux server. This setup bypasses the overhead of heavy backup software by leveraging the power of Rsync over SSH.

🛠 Technology Stack

Source: Windows 10/11

Destination: Ubuntu 22.04+

Transport: OpenSSH (Key-based authentication)

Sync Engine: MSYS2 (rsync.exe)

Automation: Bash + Crontab

📖 Setup Steps

1. The Windows Side (The Source)

Install MSYS2 to provide a native rsync environment.

Run the following to install the rsync package:
pacman -S rsync

Security Tip: Ensure your .ssh/authorized_keys file has the correct Windows permissions (icacls) or the SSH server will reject the key.

2. The Linux Side (The Destination)

Generate an SSH key (ssh-keygen -t ed25519) and copy it to Windows.

Verify the "Handshake" with a version test:

ssh win "C:/msys64/usr/bin/rsync.exe --version"

📜 The Backup Script (backup-windows.sh)

⏰ Automation (Crontab)

To run this every day at 2:15 AM, add this to crontab -e:

15 14 * * * /home/UserName/backup-windows.sh

⚠️ Key Lessons Learned ("The Gotchas")

Path Syntax: MSYS2 requires the C:/ format for the rsync-path variable, but the source path uses the /C/Users/ format.

Cron Environment: Cron doesn't load your user's $PATH. Always use absolute paths for local commands if the script fails in the background.
