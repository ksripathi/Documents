# set the base image
FROM base-image

# update sources list
RUN apt-get update

COPY tomcat-users.xml /opt/tomcat/conf/
COPY context.xml /opt/tomcat/webapps/manager/META-INF/

RUN curl -sL https://deb.nodesource.com/setup_8.x | sudo -E bash -
RUN apt-get install -y nodejs
RUN npm install -g @angular/cli
COPY otalio-ui.zip /root
WORKDIR "/root/"
RUN unzip otalio-ui.zip
RUN rm -rf otalio-ui.zip
WORKDIR "/root/otalio-ui"
COPY file.sh /
RUN chmod +x /file.sh
# RUN npm install
# RUN ng build --prod --app=system --env=dev
# RUN cp -r dist/apps/system /opt/tomcat/webapps/
#CMD [ "/opt/tomcat/bin/catalina.sh", "run" ]