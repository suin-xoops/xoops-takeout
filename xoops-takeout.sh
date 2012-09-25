#!/usr/bin/env bash

# xoops-takeout.sh
#
#    "Take out XOOPS database and files fully"
#
# Usage
#
# $ /path/to/xoops-takeout.sh </path/to/mainfile.php> </path/to/export/directory>
#
# Website
#
#    https://github.com/suin/xoops-takeout
#

PATH=/sbin:/bin:/usr/sbin:/usr/bin:/usr/local/sbin:/usr/local/bin

SCRIPT_NAME=$0

#
# Show help and usages
#
help(){
	echo "Take out XOOPS database and files fully"
	echo ""
	echo "Usage:"
	echo "  \$ $SCRIPT_NAME <path/to/mainfile.php> <export-directory>"
}

#
# Export XOOPS information
#
export_xoops_info() {
	mainfile="$1"
	php -r "
		define('_LEGACY_PREVENT_LOAD_CORE_', 1);
		error_reporting(0);
		require '$mainfile';
		echo 'export XOOPS_DB_USER=',    XOOPS_DB_USER,    PHP_EOL;
		echo 'export XOOPS_DB_PASS=',    XOOPS_DB_PASS,    PHP_EOL;
		echo 'export XOOPS_DB_HOST=',    XOOPS_DB_HOST,    PHP_EOL;
		echo 'export XOOPS_DB_NAME=',    XOOPS_DB_NAME,    PHP_EOL;
		echo 'export XOOPS_ROOT_PATH=',  XOOPS_ROOT_PATH,  PHP_EOL;
		echo 'export XOOPS_TRUST_PATH=', XOOPS_TRUST_PATH, PHP_EOL;
		"
}

#
# Make MySQL dump
#
make_mysql_dump() {
	[ $# -eq 5 ] || return 1

	host="$1"
	user="$2"
	pass="$3"
	database="$4"
	filename="$5"
	
	if [ -z "$pass" ]
	then
		mysqldump "-h$host" "-u$user"           $database > "$filename"
	else
		mysqldump "-h$host" "-u$user" "-p$pass" $database > "$filename"
	fi
}

#
# Compress files
#
compress_files() {
	directory="$1"
	name="$2"
	basename=$(basename $directory)
	base=$(dirname $directory)
	[ -d "$directory" ] || return 1
	[ -z "$name" ] && name=$basename.tgz
	tar czf $name -C $base $basename
}

#
# Main function
#
main() {

	if [ $# -ne 2 ]
	then
		help
		return 1
	fi
	
	mainfile="$1"
	backup_directory="$2"
	date=$(date "+%y%m%d.%H%M")

	if [ ! -f "$mainfile" ]
	then
		echo "mainfile.php not found: $mainfile"
		return 1
	fi
	
	if [ ! -r "$mainfile" ]
	then
		echo "mainfile.php not readable: $mainfile"
		return 1
	fi

	if [ ! -d "$backup_directory" ]
	then
		echo "Back up directory not found: $backup_directory"
		return 1
	fi
	
	if [ ! -w "$backup_directory" ]
	then
		echo "Back up directory not writable: $backup_directory"
		return 1
	fi

	$(export_xoops_info $mainfile)
	
	mysql_backup_filename="/tmp/$XOOPS_DB_NAME.sql"

	# Parallel processing
	make_mysql_dump "$XOOPS_DB_HOST" "$XOOPS_DB_USER" "$XOOPS_DB_PASS" "$XOOPS_DB_NAME" "$mysql_backup_filename" 
	tar czvf "$backup_directory/$XOOPS_DB_NAME.$date.tgz" \
		-C $(dirname "$mysql_backup_filename") $(basename "$mysql_backup_filename") \
		-C $(dirname "$XOOPS_ROOT_PATH")       $(basename "$XOOPS_ROOT_PATH") \
		-C $(dirname "$XOOPS_TRUST_PATH")      $(basename "$XOOPS_TRUST_PATH")
	rm -f "$mysql_backup_filename"
}

main $@

