#!/bin/sh

if [ $# -lt 4 ]; then
  echo "Usage: up.sh user uid gid share_dir"
  exit 1
fi

user=$1
uid=$2
gid=$3
share_dir=$4

echo -n "Enter a password: "
stty -echo
read smb_password
stty echo
echo

echo "user: $user"
echo "uid: $uid"
echo "gid: $gid"
echo "share_dir: $share_dir"

smb_param=$(cat <<PARAM
{
  "user": {
    "name": "$user",
    "password": "$smb_password",
    "uid": $uid,
    "gid": $gid
  }
}
PARAM
)

sudo docker run \
  --rm \
  -p 139:139 \
  -p 445:445 \
  -v $share_dir:/mount \
  -e SMB_PARAM="$smb_param" \
  samba
