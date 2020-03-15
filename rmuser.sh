#!/bin/sh

USER_USERNAME="$1"

if [ -z "$USER_USERNAME" ]; then
  echo "Usage: $0 username" >&2
  echo "Example: $0 jordi" >&2
  exit 1
fi

cp etc/ipsec.users etc/ipsec.users.bak
sed "/$USER_USERNAME/d" etc/ipsec.users.bak > etc/ipsec.users
