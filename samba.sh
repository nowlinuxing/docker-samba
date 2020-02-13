#!/bin/sh

# Create a smb.conf
(cd /root && ./mitamae local setup.rb)

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

exec /usr/sbin/smbd -F -S --no-process-group
