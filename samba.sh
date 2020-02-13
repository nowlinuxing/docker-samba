#!/bin/sh

# Setup samba
(cd /root && ./mitamae local setup.rb)

exec /usr/sbin/smbd -F -S --no-process-group
