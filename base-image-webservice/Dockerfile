# set the base image
FROM base-image

# update sources list
RUN apt-get update

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
