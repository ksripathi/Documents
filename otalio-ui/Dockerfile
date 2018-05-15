# set the base image
FROM ubuntu:16.04

# update sources list
RUN apt-get update -y
RUN apt-get install -y default-jdk unzip sudo curl vim net-tools apt-utils wget
WORKDIR "/usr/local/"
ADD http://www-us.apache.org/dist/maven/maven-3/3.5.3/binaries/apache-maven-3.5.3-bin.tar.gz .

RUN tar -xf apache-maven-3.5.3-bin.tar.gz
RUN ln -s /usr/local/apache-maven-3.5.3/bin/mvn mvn

ADD http://redrockdigimark.com/apachemirror/tomcat/tomcat-8/v8.5.31/bin/apache-tomcat-8.5.31.tar.gz "/opt"
WORKDIR "/opt"
# RUN wget http://redrockdigimark.com/apachemirror/tomcat/tomcat-8/v8.5.31/bin/apache-tomcat-8.5.31.tar.gz
RUN tar -xvf apache-tomcat-8.5.31.tar.gz
RUN mv apache-tomcat-8.5.31 tomcat
RUN groupadd tomcat
RUN useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
RUN chgrp -R tomcat /opt/tomcat ;chown -R tomcat /opt/tomcat;chmod -R 755 /opt/tomcat;chown -hR tomcat:tomcat tomcat;chmod +x /opt/tomcat/bin/*
COPY tomcat-users.xml /opt/tomcat/conf/
COPY context.xml /opt/tomcat/webapps/manager/META-INF/

RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
COPY otalio-metadataservice.zip /root
WORKDIR "/root/"
RUN unzip otalio-metadataservice.zip
RUN rm -rf otalio-metadataservice.zip
WORKDIR "/root/otalio-metadataservice"
RUN /usr/local/apache-maven-3.5.3/bin/mvn package
RUN mv metadataservice-core/target/metadataservice-core-0.0.1-SNAPSHOT.war metadataservice-core/target/metadata.war
RUN cp -r metadataservice-core/target/metadata.war /opt/tomcat/webapps/
CMD [ "/opt/tomcat/bin/catalina.sh", "run" ]