# Dockerized Tor Relay server

A simple Docker container for running a Tor relay server.
The container is also configured to listen on port 9001 for the relay traffic. Make sure to open the port in your firewall.

## Usage

### Minimal usage

Running the relay is super simple.

```
$ docker run -d \
    -p 9001:9001 \
    --name torrelay \
    -e 'TORRC=/etc/tor/torrc.middle' \
    -e 'NICKNAME=DockerTorRelay' \
    -v /etc/localtime:/etc/localtime \
    --restart always \
    dedimax/docker-tor-relay
```

### Required configuration

#### Give your node a nickname

It recommended that you provide a Nickname. You can do this using the following flag.

`-e 'NICKNAME=MyTorRelay' \`

#### Set your node type

You can set your node type by changing the torrc file.
There are 3 configuration: Bridge, Exit and Middle Node. If you are not sure what to use then "middle" is the right node to start.

`-e 'TORRC=/etc/tor/torrc.middle' \`
`-e 'TORRC=/etc/tor/torrc.bridge' \`
`-e 'TORRC=/etc/tor/torrc.exit' \`

### Recommended additional flags

#### Configure contact info

It is also recommended that you provide your contact information. This is mostly used for contact information in case there is something wrong with your node.

```
-e 'CONTACTINFO=John Smith <jsmith@example.com>' \
```

#### Use persistant storage

Since Tor relies on keys on saved keys on disk for establishing trust, it is a good idea to use a volume to store your tor keys on the host (since Docker containers are ephemeral by nature).

You can do this by passing on the following.

```
-v '/some/local/path:/home/tord/.tor' \
```

#### Other parameters (optional)

Expose local socks port:
`-p 127.0.0.1:9050:9050 \`

#### Final configuration

```
$ docker run -d \
    -p 9001:9001 \
    -p 127.0.0.1:9050:9050 \
    --name torrelay \
    -e 'TORRC=/etc/tor/torrc.middle' \
    -e 'NICKNAME=DockerTorRelay' \
    -e 'CONTACTINFO=John Smith <jsmith@example.com>' \
    -v /etc/localtime:/etc/localtime \
    -v '/var/torrelay:/home/tord/.tor' \
    --restart always \
    dedimax/docker-tor-relay
```
