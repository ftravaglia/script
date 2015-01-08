#!/bin/bash
# Author ftravaglia
# Write the 24/12/2014
# This script is use for simplify the use for restore a dump.


usage() {
	echo "This script is use for simplify the use of the pg_restore command."
	echo ""
	echo "Usage of the restore command:"
	echo "-u,  --user : database user"
	echo "-h,  --host : database host"
	echo "-p,  --port : database port"
	echo "-db, --database-name : database name"
	echo "-f,  --file : the file to restore"

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
        -f | --file )    	shift
				DUMP_NAME=$1
                                ;;
        -help | --help )        usage
                                exit
                                ;;
        * )                     usage
                                exit 1
    esac
    shift
done

psql -h $HOST -d  $DB_NAME -p $PORT -U $USER_NAME --no-password -t -a -f $DUMP_NAME

