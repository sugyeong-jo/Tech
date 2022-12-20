# Server Guide
## Server setting

**ip 주소 넣기**
1. Changing the directory for assigning the IP address 
```
cd /etc/sysconfig/network-scripts/
vi ifcfg-eth0
```
2. Pressing the `<ESC>` --> `i`
3. Add the ip address, subnet, ...
(Example)
```
...
IPADDR=xxx.xxx.xxx.xxx
NETMASK=xxx.xxx.xxx.xxx
GATEWAY=xxx.xxx.xxx.xxx
DNS1=xxx.xxx.xxx.xxx
```
4. Changing the directory for assigning the DNS server
```
vi /etc/resolv.conf
```
5. Add the ip DNS server name
(Example)
```
nameserver xxx.xxx.xxx.xxx
nameserver xxx.xxx.xxx.xxx
```
6. Change the assessment  port
```
cd /etc/ssh/
vi sshd_config
```
7. Add the port information
```
Port xxxx
```
8. Restart the ssh and network
```
service sshd restart
service network restart
```
9. Check the result
```
ifconfig
ping 8.8.8.8
```

## Server management

**Add users**
```
useradd [user id]
```

**Modify the password**
```
passwd [user id]
```

**Create a directory and give permission**
```
mkdir path/foldername
chmod 777 -m 777 foldername
```

**Mount floder**
```
mkdir path/foldername
mount --bind [bind하고자 하는 폴더 경로] [path/foldername]
```
- e.g.
`mount --bind ./ORlab/ ./sugyeong/ORlab/`

**Un-Mount floder**
```
umount [path/foldername]
```
- e.g.
`umount ./sugyeong/ORlab/`


## Server connection
```
ssh -p [port] [user id]@[ip address]
```
