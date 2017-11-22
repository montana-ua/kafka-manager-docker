# Kafka Manager Dockerfile
[Kafka Manager](https://github.com/yahoo/kafka-manager) is a tool for managing [Apache Kafka](http://kafka.apache.org) developed by [Yahoo Inc](https://www.yahoo.com).

## Description
The latest version of the docker image is based on:  

* docker image - [oraclelinux:6.8](https://hub.docker.com/_/oraclelinux/)  
* java - [JDK 1.8.0_152](http://www.oracle.com/technetwork/java/javase/downloads/index.html)  
* kafka manager - [1.3.3.14](https://github.com/yahoo/kafka-manager/releases/tag/1.3.3.14)

The following actions will be performed during building a docker image:  

* install the additional packages (git, wget, tar, vim, mc, unzip, lsof)  
* kafka-manager home set to /opt/kafka-manager  
* delete all unused files (README.md bin/*.bat share/)  
* change debug level from INFO/WARN to ERROR into logback.xml and logger.xml files  
* set kafka-manager client port to 9000  
* define application.home -Dapplication.home=./  
* define ZK\_HOST=localhost:2181  
* export JAVA\_HOME  
* set TERM=xterm  

### How to build the image
If you want to build your own image, you should perform the following steps:  

```bash	
cd /tmp
git clone https://github.com/intropro/kafka-manager-docker.git
cd kafka-manager-docker/
docker build -t <NAME:TAG> .
rm -rf /tmp/kafka-manager-docker	
```

*Example:*

``` bash
docker build -t kafka-manager:1.3.3.14 .
```

### Create a container
#### Quick start

```bash
docker run -d -p <YOUR_PORT>:9000 -e ZK_HOSTS=<YOUR_ZK_CLUSTER:YOUR_ZK_PORT> --name <YOUR_CONTAINER_NAME> intropro/kafka-manager:latest
```

If you don't specify ZK\_HOST variable, the default value "localhost:2181" will be used by a docker container.

*Example:*

```bash
docker run -d -p 9000:9000 -e ZK_HOSTS=zkdv-kdc01.ea.intropro.com:2181 --name kafka-manager intropro/kafka-manager:latest
```

Another way is to use a docker-compose file.

```bash
docker-compose -f <PATH_TO_DOCKER_COMPOSE_FILE>.yml up -d	
```

If zookeeper service is not running on the localhost, you need to define ZK\_HOST variable in your docker-compose file.

*Example:*

```bash
docker-compose -f /opt/docker/kafka-manager.yml up -d
```

#### Use own configuration file
You can use your own configuration file via environment variable KM\_CONFIG
  
```bash
docker run -d -p <YOUR-PORT>:9000 -e ZK_HOSTS=<YOUR_ZK_CLUSTER:YOUR_ZK_PORT> -v <PATH_TO_LOCAL_CONFIGDIR>:<CONTAINER_MOUNT_POINT> -e KMANAGER_CONFIG=<CONTAINER_MOUNT_POINT>/<YOUR_CONFIG_FILE> --name <YOUR_CONTAINER_NAME> intropro/kafka-manager:latest
```

*Example:*

```bash
docker run -d -p 9001:9000 -e ZK_HOSTS=kmgr-kdc01.ea.intropro.com:2181 -v /opt/kmm-config:/mnt -e KMANAGER_CONFIG=/mnt/application.conf --name kafka-manager intropro/kafka-manager:latest
```

#### Pass aditional arguments to the container
You can pass additional arguments into the Kafka Manager container through the JAVA\_OPTS or/and KMANAGER\_ARGS variables.  

*Example how to pass JAVA HEAP size:*

```bash
docker run -d -p 9000:9000 -e ZK_HOSTS="kmgr-kdc01.ea.intropro.com:2181" -e JAVA_OPTS="-Xms512M -Xmx512M" --name kafka-manager intropro/kafka-manager
```

*Example how to pass JAVA HEAP and own arguments:*

```bash
docker run -d -p 9000:9000 -e ZK_HOSTS="kmgr-kdc01.ea.intropro.com:2181" -e JAVA_OPTS="-Xms512M -Xmx512M" -e KMANAGER_ARGS="-Dname=KafkaManager" --name kafka-manager intropro/kafka-manager
```

### Change a revision
To upgrade or downgrade Kafka Manager change the KMANAGER\_VERSION and KMANAGER\_REVISION variables. You can also upgrade or downgrade Java version via the JAVA\_MAJOR, JAVA\_UPDATE, JAVA\_BUILD, and JAVA\_DOWNLOAD_HASH variables into the dockerfile.  

### Manage the docker container
Show the list of running containers.  

```bash
docker ps
```

Show the list of all containers.

```bash
docker ps -a
```

start/stop/stats one or more containers

```bash
docker start <YOUR_CONTAINER_NAME>
docker stop <YOUR_CONTAINER_NAME>
docker stats <YOUR_CONTAINER_NAME>
```


---
If you have a question or you want to get a support and customize this one for your specific task, please contact me <sergey@vergun.in.ua>
