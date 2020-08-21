#!/bin/bash
DATE_EXEC=`date "+%Y%m%d_%H%M"`

for i in `ps -ef |grep weblogic.Server |grep -v grep |awk -F" " {'print $2'}`
do

        export VALIDA_JRCMD=`ps -ef | grep $i |grep -v grep |awk -F" " {'print $8'} | sed s/"bin\/java"/"bin\/jrcmd"/`
        export VALIDA_JSTACK=`ps -ef | grep $i |grep -v grep |awk -F" " {'print $8'} | sed s/"bin\/java"/"bin\/jstack"/`
        export INST_NAME=`ps -ef |grep $i |grep weblogic.Server |grep -v grep | sed "s/ /&\n/g" |grep weblogic.Name | awk -F"=" {'print $2'}|sed "s/ //g"`

        if [ -f $VALIDA_JRCMD ]; then
                $VALIDA_JRCMD/jrcmd $i print_threads > /u99/oracle/dump/capta/td_${HOSTNAME}_${INST_NAME}_$DATE_EXEC.txt

        elif [ -f $VALIDA_JSTACK ]; then
                $VALIDA_JSTACK/jstack -l $i > /u99/oracle/dump/capta/td_${HOSTNAME}_${INST_NAME}_$DATE_EXEC.txt
        else
            echo "Não foi encontrado comando de dump"
        fi

done