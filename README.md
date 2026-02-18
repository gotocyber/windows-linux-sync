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

System Health Check: *top* (Note: You can press q at any time to exit the top screen and get back to your prompt.)

Network Activity: The most common tool for a quick overview of active connections is *ss* (Socket Statistics)

Checking Disk Space: *df -h*

----------------I explore linux command before proceeding to ssh keys---------I can tell story on this later or other repository----

##### Back to the "remote control" command! It’s the most important tool in your kit for managing that Ubuntu server from your Windows desk.

The "Shortcut" (SSH Keys) - digital fingerprint

Checking Who Else is There: *who* or *w*

SSH Hardening (The Config File): *The "brain" of your SSH service lives in a file called /etc/ssh/sshd_config. This is where you can change the port (to hide from bots) or disable password logins entirely once your keys are set up.*

I have a Secret. I'm actually speaking and ask to gemini for guidance. Now that I spill the beans. Here's the question I ask that leads to the exciting part.

##### GotoCyber: How can I ssh my windows from ubuntu?
##### Gemini: This is a great "flip the script" moment! Usually, we use Windows to control Linux, but doing it the other way around is a classic move for managing a mixed-environment lab. By default, Windows is "closed" to incoming connections, while Linux comes with the tools to "speak" SSH out of the box. To make this work, we have to turn on the SSH Server on your Windows machine.

##### Step 1: Turn on the SSH Server in Windows
##### You don't need to download anything; it's a built-in "Optional Feature" in Windows 10 and 11.
##### A. On your Windows machine, click Start and type "Optional Features".
##### B. Look for "OpenSSH Server".
##### ----If it’s not there: Click "View features" (or "Add a feature"), search for "OpenSSH Server," and install it.
##### C. Now, we need to start the service. Open PowerShell as Administrator and run:
Powershell: Start-Service sshd
Set-Service -Name sshd -StartupType 'Automatic'

------------------------------By the way, I got an error in here-------------------------------

--------------THE SOLUTION-------------------



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
