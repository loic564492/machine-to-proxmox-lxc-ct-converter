# convert any gnu/linux machine into a proxmox lxc container #

#### root ssh access on target machine required ##### 
#### run this script on the @proxmox host with root privileges ##### 

```
./convert.sh \
-n test \
-t syspass.dgmbsd.de \
-P 22 \ 
-i 114 \
-s 10 \
-a 192.168.111.63 \
-b vmbr0 \
-g 192.168.111.64 \
-m 2048 \
-d default \
-p foo
-k   /path/to/ssh/private_key

```

```
/convert.sh -h|--help
 -n|--name [lxc container name]
 -t|--target [target machine ssh uri]
 -P|--port [target port ssh]
 -i|--id [proxmox container id]
 -s|--root-size [rootfs size in GB]
 -a|--ip [target container ip]
 -b|--bridge [bridge interface]
 -g|--gateway [gateway ip]
 -m|--memory [memory in mb]
 -d|--disk-storage [target proxmox storage pool]
 -p|--password [root password for container (min. 5 chars)]
 -k  /path/to/ssh/private_key
```
