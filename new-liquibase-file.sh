#!/bin/bash
  
#Predev database credentials
predevdb_url='jdbc:mysql://159.89.167.29:3306/'
predevdb_user='root'
predevdb_db_name=$source_db
predevdb_password=$source_db_password

#Dev database credentials
devdb_url='jdbc:mysql://159.89.167.29:3306/'
devdb_user='root'
devdb_db_name=$target_db
devdb_password=$target_db_password
 
empty_file='db-changelog-empty.xml'
  
version='1'
file_name='db-changelog-'$version'.xml'
  
while [ 1 ]
do    
   if [ -f $file_name ]
   then
        version=$((version+1));
		file_name='db-changelog-'$version'.xml'
   else
        file_name='db-changelog-'$version'.xml'
        break
   fi
done
  
echo '##########'
echo $file_name
echo '##########'
  
  
cd /home/otalio/liquibase
  
./liquibase --driver=com.mysql.jdbc.Driver --changeLogFile=$file_name --classpath=mysql-connector-java-5.1.46.jar --url=$devdb_url$target_db --username=$devdb_user --password=$devdb_password diffChangeLog --referenceUrl=$predevdb_url$source_db --referenceUsername=$predevdb_user --referencePassword=$predevdb_password
  
pre_version=$((version-1));
  
if [ $pre_version -eq 0 ]
then
    echo '#####################'
    echo 'This is very first version'
    echo '#####################'
    pre_file_name='db-changelog-master.xml'	
else
    pre_file_name='db-changelog-'$pre_version'.xml'
fi
  
python refactor.py $file_name
  
if cmp -s $file_name $empty_file
then
    echo '##############'
    echo 'No data model changes found'
    echo '##############'
    rm $file_name
else
    cp $file_name $file_name.copy
    cp /var/lib/jenkins/workspace/test_liquibase/$pre_file_name $pre_file_name.copy
    sed -i s/.*\<changeSet.*/removed/g $file_name.copy
    sed -i s/.*\<changeSet.*/removed/g $pre_file_name.copy
    echo '##############'
    echo 'çomparing '$file_name' and '$pre_file_name
    echo '##############'

    if cmp -s $file_name.copy $pre_file_name.copy
    then
		echo '##############'
		echo 'No data model changes found'	
		echo '##############'	
        rm *.copy
        rm $file_name
    else
		echo '##############'
		echo 'New data model changes found'	
		echo '##############'	
        rm *.copy	
        mv $file_name /var/lib/jenkins/workspace/test_liquibase
        cd /var/lib/jenkins/workspace/test_liquibase
        sed -i "/<\/databaseChangeLog>/i\<include file=\"${file_name}\"/>" db-changelog-master.xml
        git add $file_name db-changelog-master.xml
        git commit -m 'Added new data model change and linked file'$file_name'to master file'
    fi
fi
  
  
  
