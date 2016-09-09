# Kafka Manager Dockerfile
[Kafka Manager](https://github.com/yahoo/kafka-manager) is a tool for managing [Apache Kafka](http://kafka.apache.org) developed by [Yahoo Inc](https://www.yahoo.com).

## Description
The latest version of docker image based on:
* docker image - [oraclelinux:6.8](https://hub.docker.com/_/oraclelinux/)
* java - [JDK 1.8.0_102](http://www.oracle.com/technetwork/java/javase/downloads/index.html)
* kafka manager - [1.3.1.8](https://github.com/yahoo/kafka-manager/releases/tag/1.3.1.8)

The following actions will be performed by docker build:
* install the additional packages (git, wget, tar, vim, mc, unzip, lsof)
* kafka-manager home set to /opt/kafka-manager
* delete all unused files (README.md bin/*.bat share/)
* change debug level from INFO/WARN to ERROR into logback.xml and logger.xml files
* set kafka-manager client port to 9000
* define application.home -Dapplication.home=./
* define ZK_HOST=localhost:2181
* export JAVA_HOME
* set TERM=xterm

### Build an image
If you need to build your own image based on the Dockerfile from [github](https://github.com/intropro/kafka-manager-docker.git), then you should to perform the following actions:
```
cd /tmp
git clone https://github.com/intropro/kafka-manager-docker.git
cd kafka-manager-docker/
docker build -t <NAME:TAG> .
rm -rf /tmp/kafka-manager-docker
```
*Example :*
```
docker build -t kafka-manager:1.3.1.8 .
```
### Create a container
####Quick start
```
docker run -d -p <YOUR-PORT>:9000 -e ZK_HOSTS=<YOUR-ZK-CLUSTER:YOUR-ZK-PORT> --name <YOUR-CONTAINER-NAME> intropro/kafka-manager
```
If you don't speficify ZK_HOST, then the default value "localhost:2181" will be used by a docker container.

*Example:*
```
docker run -d -p 9000:9000 -e ZK_HOSTS=zkdv-kdc01.ea.intropro.com:2181 --name kafka-manager intropro/kafka-manager
```
####Use own configuration file
You can specify an own configuration file via environment variable KM_CONFIG
```
docker run -d -p <YOUR-PORT>:9000 -e ZK\_HOSTS=<YOUR\_ZK\_CLUSTER:YOUR\_ZK\_PORT> -v <PATH\_TO\_LOCAL\_CONFIGDIR>:<CONTAINER\_MOUNT\_POINT> -e KMANAGER\_CONFIG=<CONTAINER\_MOUNT\_POINT>/<YOUR\_CONFIG\_FILE> --name <YOUR\_CONTAINER\_NAME> intropro/kafka-manager
```
*Example:*
```
docker run -d -p 9001:9000 -e ZK\_HOSTS=kmgr-kdc01.ea.intropro.com:2181 -v /opt/kmm-config:/mnt -e KMANAGER\_CONFIG=/mnt/application.conf --name kafka-manager intropro/kafka-manager
```


###Manage a container
A list of running containers.
```
docker ps
```

A list of all containers.
```
docker ps -a
```

start/stop/stats one or more containers
```
docker start <YOUR-CONTAINER-NAME>
docker stop <YOUR-CONTAINER-NAME>
docker stats <YOUR-CONTAINER-NAME>
```
