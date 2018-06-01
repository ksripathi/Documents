#!/usr/bin/env bash
echo "#############"
echo "Building '$1' application in '$2' environment"
echo "#############"
cd /root/otalio-ui
if [ $? -ne 0 ]; then
    echo "No such file or directory"
    exit 1;
fi
npm cache clean --force
if [ $? -ne 0 ]; then
    echo "Error in clearing npm cache"
    exit 1;
fi

npm i -g npm
if [ $? -ne 0 ]; then
    echo "Error in updating npm"
    exit 1;
fi

npm install
if [ $? -ne 0 ]; then
    echo "Error in installing packages"
    exit 1;
fi

ng build --prod --app=$1 --env=$2
if [ $? -ne 0 ]; then
    echo "Error in building app=$1 in evn=$2"
    exit 1;
fi

cp -r dist/apps/$1 /opt/tomcat/webapps/

if [ $? -ne 0 ]; then
    echo "Error in copying $1 folder to tomcat"
    exit 1;
fi
/opt/tomcat/bin/catalina.sh run
