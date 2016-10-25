# Kafka Manager Dockerfile
[Kafka Manager](https://github.com/yahoo/kafka-manager) is a tool for managing [Apache Kafka](http://kafka.apache.org) developed by [Yahoo Inc](https://www.yahoo.com).

## Description
The latest version of docker image based on:  
* docker image - [oraclelinux:6.8](https://hub.docker.com/_/oraclelinux/)  
* java - [JDK 1.8.0_112](http://www.oracle.com/technetwork/java/javase/downloads/index.html)  
* kafka manager - [1.3.1.8](https://github.com/yahoo/kafka-manager/releases/tag/1.3.1.8)

The following actions will be performed by docker build:  
* install the additional packages (git, wget, tar, vim, mc, unzip, lsof)  
* kafka-manager home set to /opt/kafka-manager  
* delete all unused files (README.md bin/*.bat share/)  
* change debug level from INFO/WARN to ERROR into logback.xml and logger.xml files  
* set kafka-manager client port to 9000  
* define application.home -Dapplication.home=./  
* define ZK\_HOST=localhost:2181  
* export JAVA\_HOME  
* set TERM=xterm  

### Build an image
If you need to build your own image based on the Dockerfile from [github](https://github.com/intropro/kafka-manager-docker.git), then you should perform the following actions:  

	cd /tmp
	git clone https://github.com/intropro/kafka-manager-docker.git
	cd kafka-manager-docker/
	docker build -t <NAME:TAG> .
	rm -rf /tmp/kafka-manager-docker	

*Example:*

	docker build -t kafka-manager:1.3.1.8 .

### Create a container
####Quick start

	docker run -d -p <YOUR_PORT>:9000 -e ZK_HOSTS=<YOUR_ZK_CLUSTER:YOUR_ZK_PORT> --name <YOUR_CONTAINER_NAME> intropro/kafka-manager

If you don't specify ZK_HOST variable, then the default value "localhost:2181" will be used by a docker container.

*Example:*

	docker run -d -p 9000:9000 -e ZK_HOSTS=zkdv-kdc01.ea.intropro.com:2181 --name kafka-manager intropro/kafka-manager

Another way is to use a docker-compose file.

	docker-compose -f <PATH_TO_DOCKER_COMPOSE_FILE>.yml up -d	

If your zookeeper service is not a localhost, then specify the ZK_HOST variable into docker-compose file.

*Example:*

	docker-compose -f /opt/docker/kafka-manager.yml up -d

####Use own configuration file
You can specify an own configuration file via environment variable KM_CONFIG
  
	docker run -d -p <YOUR-PORT>:9000 -e ZK_HOSTS=<YOUR_ZK_CLUSTER:YOUR_ZK_PORT> -v <PATH_TO_LOCAL_CONFIGDIR>:<CONTAINER_MOUNT_POINT> -e KMANAGER_CONFIG=<CONTAINER_MOUNT_POINT>/<YOUR_CONFIG_FILE> --name <YOUR_CONTAINER_NAME> intropro/kafka-manager

*Example:*

	docker run -d -p 9001:9000 -e ZK_HOSTS=kmgr-kdc01.ea.intropro.com:2181 -v /opt/kmm-config:/mnt -e KMANAGER_CONFIG=/mnt/application.conf --name kafka-manager intropro/kafka-manager

####Pass aditional arguments to a container
You can pass aditional arguments to a Kafka Manager container throught the JAVA\_OPTS or/and KMANAGER\_ARGS variables.  

*Example how to pass JAVA HEAP:*

	docker run -d -p 9000:9000 -e ZK_HOSTS="kmgr-kdc01.ea.intropro.com:2181" -e JAVA_OPTS="-Xms512M -Xmx512M" --name kafka-manager-args intropro/kafka-manager

*Example how to pass JAVA HEAP and own arguments:*

	docker run -d -p 9000:9000 -e ZK_HOSTS="kmgr-kdc01.ea.intropro.com:2181" -e JAVA_OPTS="-Xms512M -Xmx512M" -e KMANAGER_ARGS="-Dname=KafkaManager" --name kafka-manager-args intropro/kafka-manager

### Change a revision
To upgrade or downgrade Kafka Manager change the KMANAGER\_VERSION and KMANAGER\_REVISION variables.  
You can also upgrade or downgrade Java version. Use for it JAVA\_MAJOR, JAVA\_UPDATE, JAVA\_BUILD variables into the dockerfile.  

###Manage a container
A list of running containers.  

	docker ps

A list of all containers.

	docker ps -a

start/stop/stats one or more containers

	docker start <YOUR_CONTAINER_NAME>
	docker stop <YOUR_CONTAINER_NAME>
	docker stats <YOUR_CONTAINER_NAME>
