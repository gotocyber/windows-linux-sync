Windows-to-Linux Automated Rsync Bridge

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
