#!/bin/sh

USER_USERNAME="$1"

if [ -z "$USER_USERNAME" ]; then
  echo "Usage: $0 username" >&2
  echo "Example: $0 jordi" >&2
  exit 1
fi

case "$USER_USERNAME" in
  *[\\\"\']*)
    echo "VPN credentials must not contain any of these characters: \\ \" '" >&2
    exit 1
    ;;
esac

SHARED_SECRET=$(cut -d'"' -f2 etc/ipsec.secrets)
if [ -z "$SHARED_SECRET" ] ; then
	SHARED_SECRET=$(LC_CTYPE=C tr -dc 'A-HJ-NPR-Za-km-z2-9' < /dev/urandom | head -c 20)
cat > etc/ipsec.secrets <<EOF
%any  %any  : PSK "$SHARED_SECRET"
EOF
fi
echo "Shared secret: $SHARED_SECRET"

USER_PASSWORD="$(LC_CTYPE=C tr -dc 'A-HJ-NPR-Za-km-z2-9' < /dev/urandom | head -c 20)"
USER_PASSWORD_ENC=$(openssl passwd -1 "$USER_PASSWORD")
echo "Password for user is: $USER_PASSWORD"

echo '"'$USER_USERNAME'" "'$USER_PASSWORD'"' >> etc/ipsec.users
