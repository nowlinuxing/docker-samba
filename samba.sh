#!/bin/sh

# Create a smb.conf
#
# Setting up Samba as a Standalone Server - SambaWiki
# https://wiki.samba.org/index.php/Setting_up_Samba_as_a_Standalone_Server
smb_conf=/etc/samba/smb.conf
cp /root/smb.conf.base $smb_conf
cat <<SMBCONF>> $smb_conf
[share]
	path = /mount
	browsable = yes
	read only = no
	guest ok = no
	valid users = $SMB_USER
SMBCONF

groupadd -g $SMB_USER_GID $SMB_USER
useradd -u $SMB_USER_UID -g $SMB_USER_GID $SMB_USER
cat <<PASSWORD | passwd $SMB_USER
$SMB_PASSWORD
$SMB_PASSWORD
PASSWORD
cat <<PASSWORD | smbpasswd -a -s $SMB_USER
$SMB_PASSWORD
$SMB_PASSWORD
PASSWORD

/usr/sbin/smbd -F -S --no-process-group
