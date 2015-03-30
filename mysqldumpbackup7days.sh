#!bin/bash


MYSQLDUMP='/usr/bin/mysqldump'
MYSQLUSER=''
MYSQLPASS=''

BACKUPDIRTO='/var/backup/'
BACKUPFILE='mysql.gz'
BACKUPLOG='/var/log/backupmysql.log'

scp="/usr/bin/scp"
scpkey="/root/exbackupkey"

BACKUPSERVER='scpbackup'
BACKUPUSER='dbabackup'
BACKUPSERVERDIR='mysql'

DBABACKUPEMAIL='dba@server.lan'

md5sumsex=""
md5sumsloc=""

date >> ${BACKUPLOG}

if [ -d ${BACKUPDIRTO} ]; then
    echo "Backup directory present" >>${BACKUPLOG} 2>&1
else
    echo "Backup directory absent" >>${BACKUPLOG} 2>&1
    echo "Creating backup directory... " >>${BACKUPLOG} 2>&1
    mkdir ${BACKUPDIRTO} >>${BACKUPLOG} 2>&1
    if [ -d ${BACKUPDIRTO} ]; then
        echo "done" >>${BACKUPLOG} 2>&1
    else
        echo "Can not create backup directory" >>${BACKUPLOG} 2>&1
        echo "For more detail look ${BACKUPTLOG}" >>${BACKUPLOG} 2>&1
#       tail -n 1 ${BACKUPLOG}
        exit 0
    fi
fi

echo "Creating backup..." >>${BACKUPLOG} 2>&1
if [ -s ${BACKUPDIRTO}/${BACKUPFILE} ]; then
    echo "Removing backup file ${BACKUPDIRTO}/${BACKUPFILE}... " >>${BACKUPLOG} 2>&1
    rm ${BACKUPDIRTO}/${BACKUPFILE} 2>&1
    if [ -s ${BACKUPDIRTO}/${BACKUPFILE} ]; then
        echo "Backup file ${BACKUPDIRTO}/${BACKUPFILE} present or any error and can not be deleted." >>${BACKUPLOG} 2>&1
        echo "For more detail look ${BACKUPLOG}" >>${BACKUPLOG} 2>&1
#       tail -n 1 ${BACKUPLOG}
        exit 0
    else
        echo "done" >>${BACKUPLOG} 2>&1
    fi
fi

echo "Backup file ${BACKUPDIRTO}/${BACKUPFILE} absent" >>${BACKUPLOG} 2>&1
echo "Creating backup file ${BACKUPDIRTO}/${BACKUPFILE}"  >>${BACKUPLOG} 2>&1
/usr/bin/mysqldump --all-databases -u ${MYSQLUSER} -p ${MYSQLPASS} | gzip > ${BACKUPDIRTO}/${BACKUPFILE} >>${BACKUPLOG} 2>&1
echo "done" >>${BACKUPLOG} 2>&1

cd ${BACKUPDIRTO}

ssh -i ${scpkey} ${BACKUPUSER}@${BACKUPSERVER} "rm ${BACKUPSERVERDIR}/${BACKUPFILE}.15" >>${BACKUPLOG} 2>&1
ssh -i ${scpkey} ${BACKUPUSER}@${BACKUPSERVER} "mv ${BACKUPSERVERDIR}/${BACKUPFILE}.14 ${BACKUPSERVERDIR}/${BACKUPFILE}.15" >>${BACKUPLOG} 2>&1
ssh -i ${scpkey} ${BACKUPUSER}@${BACKUPSERVER} "mv ${BACKUPSERVERDIR}/${BACKUPFILE}.13 ${BACKUPSERVERDIR}/${BACKUPFILE}.14" >>${BACKUPLOG} 2>&1
ssh -i ${scpkey} ${BACKUPUSER}@${BACKUPSERVER} "mv ${BACKUPSERVERDIR}/${BACKUPFILE}.12 ${BACKUPSERVERDIR}/${BACKUPFILE}.13" >>${BACKUPLOG} 2>&1
ssh -i ${scpkey} ${BACKUPUSER}@${BACKUPSERVER} "mv ${BACKUPSERVERDIR}/${BACKUPFILE}.11 ${BACKUPSERVERDIR}/${BACKUPFILE}.12" >>${BACKUPLOG} 2>&1
ssh -i ${scpkey} ${BACKUPUSER}@${BACKUPSERVER} "mv ${BACKUPSERVERDIR}/${BACKUPFILE}.10 ${BACKUPSERVERDIR}/${BACKUPFILE}.11" >>${BACKUPLOG} 2>&1
ssh -i ${scpkey} ${BACKUPUSER}@${BACKUPSERVER} "mv ${BACKUPSERVERDIR}/${BACKUPFILE}.9 ${BACKUPSERVERDIR}/${BACKUPFILE}.10" >>${BACKUPLOG} 2>&1
ssh -i ${scpkey} ${BACKUPUSER}@${BACKUPSERVER} "mv ${BACKUPSERVERDIR}/${BACKUPFILE}.8 ${BACKUPSERVERDIR}/${BACKUPFILE}.9" >>${BACKUPLOG} 2>&1
ssh -i ${scpkey} ${BACKUPUSER}@${BACKUPSERVER} "mv ${BACKUPSERVERDIR}/${BACKUPFILE}.7 ${BACKUPSERVERDIR}/${BACKUPFILE}.8" >>${BACKUPLOG} 2>&1
ssh -i ${scpkey} ${BACKUPUSER}@${BACKUPSERVER} "mv ${BACKUPSERVERDIR}/${BACKUPFILE}.6 ${BACKUPSERVERDIR}/${BACKUPFILE}.7" >>${BACKUPLOG} 2>&1
ssh -i ${scpkey} ${BACKUPUSER}@${BACKUPSERVER} "mv ${BACKUPSERVERDIR}/${BACKUPFILE}.5 ${BACKUPSERVERDIR}/${BACKUPFILE}.6" >>${BACKUPLOG} 2>&1
ssh -i ${scpkey} ${BACKUPUSER}@${BACKUPSERVER} "mv ${BACKUPSERVERDIR}/${BACKUPFILE}.4 ${BACKUPSERVERDIR}/${BACKUPFILE}.5" >>${BACKUPLOG} 2>&1
ssh -i ${scpkey} ${BACKUPUSER}@${BACKUPSERVER} "mv ${BACKUPSERVERDIR}/${BACKUPFILE}.3 ${BACKUPSERVERDIR}/${BACKUPFILE}.4" >>${BACKUPLOG} 2>&1
ssh -i ${scpkey} ${BACKUPUSER}@${BACKUPSERVER} "mv ${BACKUPSERVERDIR}/${BACKUPFILE}.2 ${BACKUPSERVERDIR}/${BACKUPFILE}.3" >>${BACKUPLOG} 2>&1
ssh -i ${scpkey} ${BACKUPUSER}@${BACKUPSERVER} "mv ${BACKUPSERVERDIR}/${BACKUPFILE}.1 ${BACKUPSERVERDIR}/${BACKUPFILE}.2" >>${BACKUPLOG} 2>&1
ssh -i ${scpkey} ${BACKUPUSER}@${BACKUPSERVER} "mv ${BACKUPSERVERDIR}/${BACKUPFILE}.0 ${BACKUPSERVERDIR}/${BACKUPFILE}.1" >>${BACKUPLOG} 2>&1
ssh -i ${scpkey} ${BACKUPUSER}@${BACKUPSERVER} "mv ${BACKUPSERVERDIR}/${BACKUPFILE} ${BACKUPSERVERDIR}/${BACKUPFILE}.0" >>${BACKUPLOG} 2>&1

${scp} -i ${scpkey} ${BACKUPFILE} ${BACKUPUSER}@${BACKUPSERVER}:${BACKUPSERVERDIR}/  >> ${BACKUPLOG} 2>&1

md5sumsex=`ssh -i ${scpkey} ${BACKUPUSER}@${BACKUPSERVER} "md5sum ${BACKUPSERVERDIR}/${BACKUPFILE}" | awk '{print $1}'`
md5sumsloc=`md5sum ${BACKUPFILE} | awk '{print $1}'`

if [ ${md5sumsex} = ${md5sumsloc} ]; then
   echo "CheckSum Backup ${BACKUPFILE} ...... ok" >>${BACKUPLOG} 2>&1
else
   echo "CheckSum Backup ${BACKUPFILE} ...... false" >>${BACKUPLOG} 2>&1
   echo "CheckSum Backup ${BACKUPFILE} ...... false" | mail -s "MySQL Backup Fail" ${DBABACKUPEMAIL}
fi

rm ${BACKUPDIRTO}/${BACKUPFILE} >> ${BACKUPLOG} 2>&1

echo -n 'Backup done: ' >> ${BACKUPLOG} 2>&1
date >> ${BACKUPLOG}

exit 0
