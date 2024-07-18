# ip_subneting
Tool designed to quickly obtain the necessary values to divide a large network into smaller and more manageable networks.

This tool requires to know an ipv4 address and the CIDR to obtain the following information:
* Subnet mask 
* Broadcast address
* Minimum usable host 
* Maximum usable host 
* Number of hosts that can be used on this subnet

## Requirements
```bash
apt install bc
```
## Usage:
Assign execution permissions to the program 

```bash
chmod u+x subneting.sh
```
Examples:

```bash
bash subneting.sh -i 172.14.15.16 -p 17    

                Binary notation                          Dot-decimal notation
------------------------------------------------------------------------------

IP               10101100.00001110.00001111.00010000            172.14.15.16
Subnet mask      11111111.11111111.10000000.00000000            255.255.128.0

Broadcast       10101100.00001110.01111111.11111111             172.14.127.255

Min. Host       10101100.00001110.00000000.00000001             172.14.0.1
Max. Host       10101100.00001110.01111111.11111110             172.14.127.254
------------------------------------------------------------------------------
Prefix           17
Total of Hosts   32768
Usabe hosts      32766
```

```bash
bash subneting.sh -i 192.112.114.29 -p 13

                Binary notation                          Dot-decimal notation
------------------------------------------------------------------------------

IP               11000000.01110000.01110010.00011101            192.112.114.29
Subnet mask      11111111.11111000.00000000.00000000            255.248.0.0

Broadcast       11000000.01110111.11111111.11111111             192.119.255.255

Min. Host       11000000.01110000.00000000.00000001             192.112.0.1
Max. Host       11000000.01110111.11111111.11111110             192.119.255.254
------------------------------------------------------------------------------
Prefix           13
Total of Hosts   524288
Usabe hosts      524286
```



