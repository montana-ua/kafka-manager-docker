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
```
Example of build command:
```
docker build -t kafka-manager:1.3.1.8 .
```
