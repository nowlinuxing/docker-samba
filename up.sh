#!/bin/sh

read_password()
{
  user=$1
  echo -n "Enter a password for a user \"${user}\": "
  stty -echo
  read -r smb_password
  stty echo
  echo
}

make_volume_opts()
{
  # The echo command is built in /bin/sh evaluates backslash, and escape or recognizes as a sequence it.
  # To avoid this, use here document instead.
  (jq -r '.sections | to_entries | map(.value.path + ":/mount/" + .key) | .[]' <<JSON
$1
JSON
  ) | while read volume; do
    echo "-v $volume"
  done
}

case $# in
  1)
    smb_param=$(cat $1)
    i=0
    for user in $(echo "$smb_param" | jq -r '.users[] | .name'); do
      echo "$smb_param" | jq -e ".users[$i].password" >/dev/null
      if [ $? -ne 0 ]; then
        read_password "$user"
        smb_param=$(echo "$smb_param" | jq --arg password "$smb_password" ".users[$i].password = \$password")
      fi

      i=$(expr $i + 1)
    done
    ;;
  4)
    user=$1
    uid=$2
    gid=$3
    share_dir=$4

    read_password

    smb_param=$(cat <<PARAM | jq --arg password "$smb_password" '.users[0].password = $password'
{
  "users": [
    {
      "name": "$user",
      "uid": $uid,
      "gid": $gid
    }
  ],
  "sections": {
    "share": {
      "path": "$share_dir"
    }
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

volume_opt=$(make_volume_opts "$smb_param")

sudo docker run \
  --rm \
  --init \
  -p 139:139 \
  -p 445:445 \
  $volume_opt \
  -e SMB_PARAM="$smb_param" \
  samba
