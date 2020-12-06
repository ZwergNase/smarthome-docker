#!/bin/bash

if [[ $# -ne 3 ]]; then
    echo "usage: initDB.sh username password database"
    exit 2
fi

read -r -d '' sql <<EOF
CREATE DATABASE "$3" DEFAULT CHARACTER SET = 'utf8';

CREATE USER '$1'@'%' IDENTIFIED BY '$2';

REVOKE CREATE ROUTINE, CREATE VIEW, CREATE USER, ALTER, SHOW VIEW, CREATE, ALTER ROUTINE, EVENT, SUPER, INSERT, RELOAD, SELECT, DELETE, FILE, SHOW DATABASES, TRIGGER, SHUTDOWN, REPLICATION CLIENT, GRANT OPTION, PROCESS, REFERENCES, UPDATE, DROP, REPLICATION SLAVE, EXECUTE, LOCK TABLES, CREATE TEMPORARY TABLES, INDEX ON *.* FROM '$1'@'%';

UPDATE mysql.user SET max_questions = 0, max_updates = 0, max_connections = 0 WHERE User = '$1' AND Host = '%';

GRANT CREATE ROUTINE, CREATE VIEW, ALTER, SHOW VIEW, CREATE, ALTER ROUTINE, EVENT, INSERT, SELECT, DELETE, TRIGGER, GRANT OPTION, REFERENCES, UPDATE, DROP, EXECUTE, LOCK TABLES, CREATE TEMPORARY TABLES, INDEX ON "$3".* TO '$1'@'%';

USE "$3";

CREATE TABLE "history" (
    "TIMESTAMP" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    "DEVICE" varchar(64) DEFAULT NULL,
    "TYPE" varchar(64) DEFAULT NULL,
    "EVENT" varchar(512) DEFAULT NULL,
    "READING" varchar(64) DEFAULT NULL,
    "VALUE" varchar(255) DEFAULT NULL,
    "UNIT" varchar(32) DEFAULT NULL,
    KEY "IDX_HISTORY" ("DEVICE","READING","TIMESTAMP","VALUE"),
    KEY "DEVICE" ("DEVICE","READING")
);

CREATE TABLE "current" (
    "TIMESTAMP" timestamp NOT NULL DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    "DEVICE" varchar(64) DEFAULT NULL,
    "TYPE" varchar(64) DEFAULT NULL,
    "EVENT" varchar(512) DEFAULT NULL,
    "READING" varchar(64) DEFAULT NULL,
    "VALUE" varchar(255) DEFAULT NULL,
    "UNIT" varchar(32) DEFAULT NULL
);
EOF

sql=${sql//\"/\`}
mysql -h 127.0.0.1 -u root -e "$sql"

if [ $? -eq 0 ]
then
	echo "Successfully created LogDB!"
	echo ""
	echo "db.conf:"
	echo "===================="
	echo "%dbconfig= ("
	echo "  connection => \"mysql:database=$3;host=XXX.XXX.XXX.XXX;port=3306\","
	echo "  user => \"$1\","
	echo "  password => \"$2\","
	echo ");"
	echo "===================="
	echo ""
	echo "Replace XXX.XXX.XXX.XXX by correct ip!"
else
	echo "Error creating LogDB!" >&2
fi
