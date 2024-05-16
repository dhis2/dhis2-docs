# HA DHIS2 setup 
## The architecture 
###  Proxy 
###  dhis2 instances 
###  Redis Installation and Configuration:
Install Redis From a Package
1. To install Redis using the APT utility, follow the steps below:
```
sudo add-apt-repository ppa:redislabs/redis
```
2. Update your Ubuntu packages after adding redis repo
```
sudo apt update
```
3. Install Redis using the package installation program.
```
 sudo apt install redis-server
```
4. Ensure that redis-server is enabled and started 
```
sudo systemctl enable redis-server
sudo systemctl start redis-server
```
> Note
>
> If the Redislabs repository is added, APT automatically installs the latest
> stable version. We do not recommend installing Redis through the Ubuntu
> default packages, as that might install an older version.

### 
###  database

