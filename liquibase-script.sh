#cp /home/otalio/liquibase/refactor.py .
cd /var/lib/jenkins/workspace/test_liquibase

version='1'
name='db-changelog-'$version'.xml'

while [ 1 ]
do    
    if [ -f $name ]
    then
        version=$((version+1));
	    name='db-changelog-'$version'.xml'
    else
        name='db-changelog-'$version'.xml'
        break
    fi
done

cd /home/otalio/liquibase
./liquibase --driver=com.mysql.jdbc.Driver --changeLogFile=$name --classpath=mysql-connector-java-5.1.46.jar --url="jdbc:mysql://159.89.167.29:3306/"$target_db --username=root --password=dilip123 diffChangeLog --referenceUrl="jdbc:mysql://159.89.167.29:3306/"$source_db --referenceUsername=root --referencePassword=dilip123

empty_file='db-changelog-empty.xml'

old_version=$((version-1));
if [ $old_version -eq 0 ];then
	echo 'this is first version'
    old_name='db-changelog-master.xml'	
else
	old_name='db-changelog-'$old_version'.xml'
fi


sed -i 's/defaultValue\=\"0000\-00\-00 00\:00\:00\"/defaultValueComputed\=\"CURRENT\_TIMESTAMP\"/g' $name
#rsync -avz /home/otalio/liquibase/refactor.py .
python refactor.py $name

cp $name $name.copy

cp /var/lib/jenkins/workspace/test_liquibase/$old_name $old_name.copy

sed -i s/.*\<changeSet.*/removed/g $name.copy
sed -i s/.*\<changeSet.*/removed/g $old_name.copy


if cmp -s $name $empty_file;then
	echo 'empty delta found'
else
	echo 'delta exist'
    if cmp -s $name.copy $old_name.copy;then
		echo 'same changes'
        rm /home/otalio/liquibase/*.copy
        rm /home/otalio/liquibase/$name
    else
    	mv $name /var/lib/jenkins/workspace/test_liquibase
    	cd /var/lib/jenkins/workspace/test_liquibase
    	sed -i "/<\/databaseChangeLog>/i\<include file=\"${name}\"/>" db-changelog-master.xml
        #rsync -avz /home/otalio/liquibase/refactor.py .
        #python refactor.py $name
        sed -i s/timestamp\(19\)/timestamp/g $name
    	git add $name db-changelog-master.xml
    	git commit -m 'added file'$name
        #rm /home/otalio/liquibase/*.copy
		rm /home/otalio/liquibase/$name.copy
        
               
        
    fi
fi



d
