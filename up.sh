#!/bin/sh

if [ $# -lt 4 ]; then
  echo "Usage: up.sh user uid gid share_dir"
  exit 1
fi

smb_user=$1
smb_user_uid=$2
smb_user_gid=$3
share_dir=$4

echo -n "Enter a password: "
stty -echo
read smb_password
stty echo
echo

echo "smb_user: $smb_user"
echo "smb_user_uid: $smb_user_uid"
echo "smb_user_gid: $smb_user_gid"
echo "share_dir: $share_dir"

sudo docker run \
  --rm \
  -p 139:139 \
  -p 445:445 \
  -v $share_dir:/mount \
  -e SMB_USER=$smb_user \
  -e SMB_USER_UID=$smb_user_uid \
  -e SMB_USER_GID=$smb_user_gid \
  -e "SMB_PASSWORD=$smb_password" \
  samba
