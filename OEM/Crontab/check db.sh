DBALIST="lamberg.nicolasbani@midasteknologi.com"

result=$(sqlplus -s DBSNMP/DbsnmpBMI#2023 <<EOF
set pagesize 0
set feedback off
set echo off
set verify off
set heading off
set serveroutput off
set termout off
SELECT name FROM v\$database;
exit
EOF
)

echo "$result" | mail -s "Database Name" "$DBALIST"