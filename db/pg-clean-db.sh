#!/bin/bash
#
# Author ftravaglia
# Write the 24/12/2014
# This script is use for clean a database.

usage() {
	echo "This script is use for clean a database"
	echo ""
	echo "Usage of the dump command:"
	echo "-u,  --user : database user"
	echo "-h,  --host : database host"
	echo "-p,  --port : database port"
	echo "-db, --database-name : database name"
}




while [ "$1" != "" ]; do
    case $1 in
        -u | --user )           shift
                                USER_NAME=$1
                                ;;
        -h | --host )    	shift
				HOST=$1
                                ;;
        -p | --port )           shift
				PORT=$1
                                ;;
        -db | --database-name ) shift
				DB_NAME=$1
                                ;;
        -help | --help )        usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

TMP_FILE=$DB_NAME.drop.sql

psql -h $HOST -d  $DB_NAME -p $PORT -U $USER_NAME --no-password -t -c "select 'drop table \"' || tablename || '\" cascade;' from pg_tables where schemaname = 'public'" > $TMP_FILE
psql -h $HOST -d  $DB_NAME -p $PORT -U $USER_NAME --no-password -t -c "select 'drop sequence \"' || relname || '\" ;' from pg_class  where relkind='S'" >> $TMP_FILE
echo "$TMP_FILE create!"
psql -h $HOST -d  $DB_NAME -p $PORT -U $USER_NAME --no-password -t -f $TMP_FILE
echo "drop tables and sequences of the $DB_NAME($HOST) database finished"
rm $TMP_FILE
echo "$TMP_FILE file removed"

COUNT_TABLE=`psql -h $HOST -d  $DB_NAME -p $PORT -U $USER_NAME --no-password -t -c "select count(tablename) from pg_tables where schemaname = 'public'"`
COUNT_SEQ=`psql -h $HOST -d  $DB_NAME -p $PORT -U $USER_NAME --no-password -t -c "select count(relname) from pg_class  where relkind='S'"`

#Error code =2 when the is table or sequence on the database.
ERROR=0
if [ $COUNT_TABLE -ne 0 ]; then
  echo "Cleanning fail ! Remains > $COUNT_TABLE tables ! Try to replay the script!"
  ERROR=2
fi

if [ $COUNT_SEQ -ne 0 ]; then
  echo "Cleanning fail ! Remains > $COUNT_SEQ sequences ! Try to replay the script!"
  ERROR=2
fi

exit $ERROR;

