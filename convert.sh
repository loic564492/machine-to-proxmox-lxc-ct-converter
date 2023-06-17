#!/bin/bash

while [[ $# -gt 0 ]]; do
    key="$1"

    case $key in
        -n|--name)
        NAME="$2"
        shift
        shift
        ;;
        -t|--target)
        TARGET="$2"
        shift
        shift
        ;;
        -P|--port)
        PORT="$2"
        shift
        shift
        ;;
        -i|--id)
        ID="$2"
        shift
        shift
        ;;
        -s|--root-size)
        ROOT_SIZE="$2"
        shift
        shift
        ;;
        -a|--ip)
        IP="$2"
        shift
        shift
        ;;
        -b|--bridge)
        BRIDGE="$2"
        shift
        shift
        ;;
        -g|--gateway)
        GATEWAY="$2"
        shift
        shift
        ;;
        -m|--memory)
        MEMORY="$2"
        shift
        shift
        ;;
        -d|--disk-storage)
        DISK_STORAGE="$2"
        shift
        shift
        ;;
        -p|--password)
        PASSWORD="$2"
        shift
        shift
        ;;
        -k|--ssh-key)
        SSH_KEY="$2"
        shift
        shift
        ;;
        *)    
        echo "Unknown option: $1"
        exit 1
        ;;
    esac
done

if [[ -z $NAME || -z $TARGET || -z $PORT || -z $ID || -z $ROOT_SIZE || -z $IP || -z $BRIDGE || -z $GATEWAY || -z $MEMORY || -z $DISK_STORAGE || -z $PASSWORD ]]; then
    echo "Missing required arguments!"
    echo "Usage: ./convert.sh -n|--name [lxc container name] -t|--target [target machine ssh uri] -P|--port [target port ssh] -i|--id [proxmox container id] -s|--root-size [rootfs size in GB] -a|--ip [target container ip] -b|--bridge [bridge interface] -g|--gateway [gateway ip] -m|--memory [memory in mb] -d|--disk-storage [target proxmox storage pool] -p|--password [root password for container (min. 5 chars)] -k|--ssh-key [path to SSH private key]"
    exit 1
fi

echo "Creating LXC container: $NAME"
echo "Target machine: $TARGET"
echo "Target port: $PORT"
echo "Proxmox container ID: $ID"
echo "Rootfs size: $ROOT_SIZE GB"
echo "Target container IP: $IP"
echo "Bridge interface: $BRIDGE"
echo "Gateway IP: $GATEWAY"
echo "Memory: $MEMORY MB"
echo "Disk storage: $DISK_STORAGE"
echo "Root password: $PASSWORD"
echo "SSH private key: $SSH_KEY"

# Add your logic here to perform the conversion using the provided arguments


collectFS() {
    tar -czvvf - -C / \
	--exclude="sys" \
	--exclude="dev" \
	--exclude="run" \
	--exclude="proc" \
	--exclude="*.log" \
	--exclude="*.log*" \
	--exclude="*.gz" \
	--exclude="*.sql" \
	--exclude="swap.img" \
	.
}

ssh -p"$port" "root@$target" "$(typeset -f collectFS); collectFS" \
    > "/tmp/$name.tar.gz"

pct create "$id" "/tmp/$name.tar.gz" \
  -description LXC \
  -hostname "$name" \
  --features nesting=1 \
  -memory "$memory" -nameserver 8.8.8.8 \
  -net0 name=eth0,ip="$ip"/24,gw="$gateway",bridge="$bridge" \
  --rootfs "$rootsize" -storage "$storage" -password "$password"

rm -rf "/tmp/$name.tar.gz"
