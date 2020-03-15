#!/bin/sh

docker exec -i -t ipsec-vpn-server grep -v '^#' /etc/ppp/chap-secrets | cut -d' ' -f1 | cut -d'"' -f2
