# Doris Setup 
Pre-requisites
- Ubuntu24.04 server 
- ssh access to the server with non root user with sudo privileges 
#### Step1: Login to the server via ssh and install java8 
```
ssh server_ip -p <ssh_port>
sudo apt update -y 
sudo apt upgrade -y 
sudo 48;51;272;1020;190448;51;272;1020;1904apt install openjdk-17-jre-headless 
```
#### Disable swap on the host 
To disable swap temporarily (swap will be re-enabled after a restart):
```
swapoff -a

```
To permanently disable swap, edit /etc/fstab and comment out the swap partition entry, then restart the machine:

```
# /etc/fstab
# <file system>        <dir>         <type>    <options>             <dump> <pass>
tmpfs                  /tmp          tmpfs     nodev,nosuid          0      0
/dev/sda1              /             ext4      defaults,noatime      0      1
# /dev/sda2              none          swap      defaults              0      0
/dev/sda3              /home         ext4      defaults,noatime      0      2
  ```

#### Step1: Add doris User
```
sudo adduser --comment "Doris Application User" --home  /usr/local/doris --disabled-login --system doris
```
#### Step2: switch to doris user  
```
sudo su -l doris -s /bin/bash 
```

#### Step3: Download  app binaries application
```
# 2.0.3
wget https://apache-doris-releases.oss-accelerate.aliyuncs.com/apache-doriso-2.0.3-bin-x64.tar.gz

# 3.0.5
wget https://apache-doris-releases.oss-accelerate.aliyuncs.com/apache-doris-3.0.5-bin-x64.tar.gz
```

#### Step4: Extract Doris 
```
tar -xvzf ./apache-doris-3.0.5-bin-x64.tar.gz
```

#### Step5: Edit fe.conf  and be.conf and set JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64", can be java 8 or 17
```
vim fe/conf/fe.conf
```
JAVA_HOME="/usr/lib/jvm/java-8-openjdk-amd64"

start fe

```
./fe/bin/start_fe.sh --daemo
```
./fe/bin/start_fe.sh --daemon

Please set the maximum number of open file descriptors larger than 60000

ulimit -n 60000
OR
vi /etc/security/limits.conf 
* soft nofile 1000000
* hard nofile 1000000
Start be
 ./be/bin/start_be.sh --daemon

Modify the number of virtual memory areas

sysctl -w vm.max_map_count=2000000 # set on the host if using lxd


Register BE node in Doris, you’ll need mysql client to connect to doris 

apt install mysql-client-core-8.0
mysql -uroot -P9030 -h127.0.0.1
ALTER SYSTEM ADD BACKEND "127.0.0.1:9050";



Configure DHIS2 to connect to Dorirs for Analytics 
```
# Analytics database management system
analytics.database = doris

# Analytics database JDBC driver class
analytics.connection.driver_class = com.mysql.cj.jdbc.Driver

# Analytics database connection URL
analytics.connection.url = jdbc:mysql://172.19.2.40:9030/analytics

# Analytics database username
analytics.connection.username = root

# Analytics database password
analytics.connection.password = SvnnH

```


#### PosgresqlJAR



