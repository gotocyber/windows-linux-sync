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

##### Check and install OpenSSH Server in Windows Machine
##### CHECK: *Get-WindowsCapability -Online | Where-Object Name -like 'OpenSSH.Server*'
##### INSTALL: *Add-WindowsCapability -Online -Name OpenSSH.Server~~~~0.0.1.0*
##### RUN: *Start-Service sshd Set-Service -Name sshd -StartupType 'Automatic'*

"""One more "gotcha": The Firewall
Windows is naturally protective. You might need to make sure the firewall is letting SSH through on Port 22. You can check this in PowerShell as well:

Get-NetFirewallRule -Name *OpenSSH-Server* | select Name, DisplayName, Enabled

If Enabled is False, run:
Enable-NetFirewallRule -Name *OpenSSH-Server*"""

"""The Next Steps
As soon as that finishes, the sshd service will finally exist. You can then run the "Start" commands we tried earlier:

Start it: Start-Service sshd

Make it permanent: Set-Service -Name sshd -StartupType 'Automatic'"""

------Oh but first, we must check the power status of our ubuntu----
#### The Quick Way (acpi): 
#### INSTALL: *sudo apt install acpi*
#### RUN: *acpi -b*

-------TROUBLESHOOTING-----
####  systemctl status is showing *ssh Active:inactive(dead)* 
#### SOLUTION: *sudo systemctl enable ssh*

Another reminders: make the IP Static for your machine. I'm now talking to you! We will discuss it in another story.

And this is where the slution begin. Did I say Solution? Yes! for A Backup Solution using rsync.

----------------------------------------------------------------------------------------------------------------

JUST Create a new user

### Create the user
net user labadmin Password123! /add

### Make them an admin
net localgroup administrators labadmin /add

### Allow the password in SSH
### Run this to open the config file in Notepad: *notepad C:\ProgramData\ssh\sshd_config*
### Look for *PasswordAuthentication*. Make sure it says *yes* and does not have a *#* in front of it. Save and close, Then, *Restart-Service sshd*

-------------------I did some *scp* or copy test during this time and it works.---I will tell the story in another time-------AND HERE COMES THE RSYNC-----

--------BUT BEFORE THAT WE NEED TO BE STEALTH-----
#### We need to hide the created labadmin user, but HOW? we will make it as a "service" account - available for SSH and background tasks, but invisible on the login screen so it doesn't clutter up your Windows welcome page.

#### *We can do this by modifying a specific key in the Windows Registry*
#### 1. In Windows: CTRL+R then type regedit. Run as **Administrator**
#### 2. Navigate to the following path (you can copy and paste this into the address bar at the top):
*HKEY_LOCAL_MACHINE\SOFTWARE\Microsoft\Windows NT\CurrentVersion\Winlogon*
#### 3. Right-click the Winlogon folder (the "key") and select New > Key. Name this new key *SpecialAccounts*.
#### 4. Right-click the SpecialAccounts key you just created and select *New > Key*. Name it UserList.
#### 5. Now, inside UserList, right-click on the right-hand side white space and select New > DWORD (32-bit) Value.
#### 6. Name this value exactly: labadmin.
#### 7. Ensure the "Data" is set to 0 (this is the default).
## KABOOM

--------Let's Go Back to RSYNC-----
#### Compared to scp, rsync is smarter:
#### 1. It only copies files that have changed (saving time).
#### 2. It can automatically create the directory structure if you use certain flags.
#### 3. If the internet cuts out halfway through, it can resume where it left off.

BONUS: instead of *ssh labadmin@IP*, simplify to *ssh win*. Sounds good, right?
Command: nano ~/.ssh/config
NANO: 

    Host win
        HostName IP_Address
        User labadmin
        Port 22

#### Ctr + O, Enter
#### Ctr + X to exit

Another Bonus: 
## Step 1. Secret Handshake (SSH Keys) *Automation can't type a password*
#### 1. On Ubuntu, generate the key (just hit Enter through all prompts):
ssh-keygen -t ed25519
#### 2. Copy it to Windows:
ssh-copy-id win 
(Since we set up your "win" alias, this should work! Type your password one last time.)
#### 3. Test it: Type ssh win. If it lets you in without a password, you’re ready.
## Step 2. Create the Backup Script: We’ll write a tiny script that tells Ubuntu exactly what to grab.
#### 1. Create the file: nano ~/backup_windows.sh
#### 2. Paste this in (adjust your folder paths as needed):

    #!/bin/bash
    # Syncing Windows Desktop to Ubuntu Backup folder
    rsync -avz --delete win:"/C:/Users/labadmin/Desktop/" ~/Documents/Windows_Backup/
#### 3. Save and Exit.
#### 4. Make it executable: chmod +x ~/backup_windows.sh
________Error Alert_____
#### 1. Try this in Powershell as Administrator

    # Create the .ssh folder if it doesn't exist
    New-Item -ItemType Directory -Force -Path "C:\Users\labadmin\.ssh"

    # Create the authorized_keys file
    New-Item -ItemType File -Force -Path "C:\Users\labadmin\.ssh\authorized_keys"  
#### 2. Put your Ubuntu Key inside the File: *On your Ubuntu ssh-keygen -t ed25519*
Since we are on the Windows machine now, you'll need to paste your Ubuntu key into that new file.

On Ubuntu, run: cat ~/.ssh/id_ed25519.pub

Copy that long string of text that starts with ssh-ed25519.

On Windows, run: notepad C:\Users\labadmin\.ssh\authorized_keys

Paste the key, Save, and Close Notepad.
#### Step 3: Apply the "Golden" Permissions
#### Now that the file actually exists, these commands will work: Powershell
    $path = "C:\Users\labadmin\.ssh\authorized_keys"
    # Disable inheritance
    icacls $path /inheritance:r
    # Grant only the specific users needed
    icacls $path /grant "labadmin:F"
    icacls $path /grant "SYSTEM:F"
    # Restart SSH to refresh everything
    Restart-Service sshd
#### Step 4: Final Test from Ubuntu
#### Now, go back to your Ubuntu terminal and try: *ssh win*
#### Does ssh win finally log you in without a password? If it does, your automated backup script is officially ready to run! *ANSWER SHOULD BE YEAH*
#### Finally! That "Yeah" is the sound of success. If you are in without a password, the "bridge" between your two machines is officially permanent and secure.

Now, let's put that bridge to work and get your Automated Backup running. Since the password barrier is gone, your script can now run silently in the background.

    #!/bin/bash
    # Create the backup directory if it doesn't exist
    mkdir -p ~/Documents/Windows_Backup

    # Sync files from Windows to Ubuntu
    # -a: archive mode, -v: verbose, -z: compress, --delete: mirror perfectly
    rsync -avz --delete win:"/C:/Users/labadmin/Desktop/" ~/Documents/Windows_Backup/

    echo "Backup completed at $(date)"

Save and exit (Ctrl+O, Enter, Ctrl+X).

Make it executable: chmod +x ~/backup_windows.sh

Test the Script

Run it manually once to make sure the files fly across: Bash: *./backup_windows.sh*

Check your folder: ls ~/Documents/Windows_Backup

Continuation ----RSYNC----


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
