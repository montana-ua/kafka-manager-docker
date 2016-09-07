FROM oraclelinux:6.8

MAINTAINER IntroPro AMPADM team <ampadm@intropro.com>

ENV JAVA_MAJOR=8 \
    JAVA_UPDATE=102 \
    JAVA_BUILD=14 \
	JAVA_HOME=/usr/java/jdk1.${JAVA_MAJOR}.0_${JAVA_UPDATE} \
    ZK_HOSTS=localhost:2181 \
	KMANAGER_VERSION=1.3.1.8 \
	KMANAGER_REVISION=97329cc8bf462723232ee73dc6702c064b5908eb \
    KMANAGER_CONFIG="conf/application.conf" \
	TERM=xterm

RUN mkdir -p /usr/share/info/dir && \
	yum update -y && \
	yum install -y git wget tar vim mc unzip lsof && \
	wget -nv --no-cookies --no-check-certificate \
    --header "Cookie: oraclelicense=accept-securebackup-cookie" \
    "http://download.oracle.com/otn-pub/java/jdk/${JAVA_MAJOR}u${JAVA_UPDATE}-b${JAVA_BUILD}/jdk-${JAVA_MAJOR}u${JAVA_UPDATE}-linux-x64.rpm" -O /tmp/jdk-${JAVA_MAJOR}u${JAVA_UPDATE}-linux-x64.rpm && \
	yum localinstall -y /tmp/jdk-${JAVA_MAJOR}u${JAVA_UPDATE}-linux-x64.rpm && \
	rm -f /tmp/jdk-${JAVA_MAJOR}u${JAVA_UPDATE}-linux-x64.rpm && \
	cd /tmp && \
	git clone https://github.com/yahoo/kafka-manager && \
	cd /tmp/kafka-manager && \
	git checkout ${KMANAGER_REVISION} && \
	echo 'scalacOptions ++= Seq("-Xmax-classfile-name", "200")' >> build.sbt && \
	./sbt clean dist && \
	unzip  -d /tmp ./target/universal/kafka-manager-${KMANAGER_VERSION}.zip && \
	cd /tmp/kafka-manager-${KMANAGER_VERSION} && \
	rm -rf README.md bin/*.bat share/ && \
	cd /tmp && \
	yes | mv /tmp/kafka-manager-${KMANAGER_VERSION} /opt && \
	mv /opt/kafka-manager-${KMANAGER_VERSION} /opt/kafka-manager && \
	sed -i -e 's|INFO|ERROR|g' /opt/kafka-manager/conf/logback.xml && \
	sed -i -e 's|WARN|ERROR|g' /opt/kafka-manager/conf/logback.xml && \
	sed -i -e 's|INFO|ERROR|g' /opt/kafka-manager/conf/logger.xml && \
	printf '#!/bin/sh\nexec ./bin/kafka-manager -Dconfig.file=${KMANAGER_CONFIG} -Dapplication.home=./ "${KMANAGER_ARGS}" "${@}"\n' > /opt/kafka-manager/kmanager-start.sh && \
	chmod +x /opt/kafka-manager/kmanager-start.sh && \
	yum clean all && \
	rm -fr /tmp/* /root/.sbt /root/.ivy2
	
WORKDIR /opt/kafka-manager
	
EXPOSE 9000
	
ENTRYPOINT ["./kmanager-start.sh"]