#!/bin/sh

read_password()
{
  echo -n "Enter a password: "
  stty -echo
  read -r smb_password
  stty echo
}

case $# in
  1)
    smb_param=$(cat $1)
    read_password
    smb_param=$(echo "$smb_param" | jq --arg password "$smb_password" '.user.password = $password')

    share_dir=$(echo $smb_param | jq .share.path)
    ;;
  4)
    user=$1
    uid=$2
    gid=$3
    share_dir=$4

    read_password

    smb_param=$(cat <<PARAM | jq --arg password "$smb_password" '.user.password = $password'
{
  "user": {
    "name": "$user",
    "uid": $uid,
    "gid": $gid
  }
}
PARAM
    )
    ;;
  *)
    echo "Usage: up.sh user uid gid share_dir"
    echo "       up.sh param.json"
    exit 1
    ;;
esac

sudo docker run \
  --rm \
  -p 139:139 \
  -p 445:445 \
  -v $share_dir:/mount \
  -e SMB_PARAM="$smb_param" \
  samba
