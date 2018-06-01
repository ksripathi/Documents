# set the base image
FROM ubuntu:16.04

# update sources list
RUN apt-get update

COPY jdk-8u171-linux-x64.tar.gz /root/
WORKDIR /root/
RUN tar -xvf jdk-8u171-linux-x64.tar.gz
# RUN echo 'export JAVA_HOME=/root/jdk1.8.0_171' >> /root/.bashrc
# RUN echo 'export PATH=$JAVA_HOME/bin:$PATH' >> /root/.bashrc
ENV JAVA_HOME /root/jdk1.8.0_171
RUN export JAVA_HOME
RUN apt-get install -y unzip sudo curl vim net-tools apt-utils
ADD http://redrockdigimark.com/apachemirror/tomcat/tomcat-8/v8.5.31/bin/apache-tomcat-8.5.31.tar.gz "/opt"
WORKDIR /opt/
RUN tar -xvf apache-tomcat-8.5.31.tar.gz
RUN mv apache-tomcat-8.5.31 tomcat
RUN groupadd tomcat
RUN useradd -s /bin/false -g tomcat -d /opt/tomcat tomcat
RUN chgrp -R tomcat /opt/tomcat ;chown -R tomcat /opt/tomcat;chmod -R 755 /opt/tomcat;chown -hR tomcat:tomcat tomcat;chmod +x /opt/tomcat/bin/*
#CMD [ "/opt/tomcat/bin/catalina.sh", "run" ]
#COPY tomcat-users.xml /opt/tomcat/conf/
#COPY context.xml /opt/tomcat/webapps/manager/META-INF/

# RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
# RUN apt-get install -y nodejs
# RUN npm install -g @angular/cli
# COPY otalio-ui.zip /root
# WORKDIR "/root/"
# RUN unzip otalio-ui.zip
# RUN rm -rf otalio-ui.zip
# WORKDIR "/root/otalio-ui"
# RUN npm install
# RUN ng build --prod --app=system --env=dev
# RUN cp -r dist/apps/system /opt/tomcat/webapps/
CMD [ "/opt/tomcat/bin/catalina.sh", "run" ]