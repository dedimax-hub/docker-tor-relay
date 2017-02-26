#!/bin/sh

if [ -z "$TORRC" ]; then
  echo "Please provide a valid TORRC parameter!"
  echo "TORRC: $TORRC"
  exit
fi

echo "Using template $TORRC"
chown -Rv tord:tord /home/tord/

# Assumes a key-value'ish pair
# $1 is the key and $2 is the value
function update_or_add {
  FINDINFILE=$(grep -e "^$1.*$" $TORRC)

  echo "Adding $1 $2 to Torrc"

  # Append if missing.
  # Update if exist.
  if [ -z "$FINDINFILE" ]; then
    echo "$1 $2" >> $TORRC
  else
    sed -i "s/^$1.*/$1 $2/g" $TORRC
  fi
}

# Set $NICKNAME to the node nickname
if [ -n "$NICKNAME" ]; then
  update_or_add 'Nickname' "$NICKNAME"
else
  update_or_add 'Nickname' 'DockerTorRelay'
fi

# Set $CONTACTINFO to your contact info
if [ -n "$CONTACTINFO" ]; then
  update_or_add 'ContactInfo' "$CONTACTINFO"
else
  update_or_add 'ContactInfo' 'Anonymous'
fi

cp $TORRC /etc/tor/torrc -f

cat /etc/tor/torrc

tor -f /etc/tor/torrc
