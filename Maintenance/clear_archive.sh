. $HOME/.profile
rman target=/ log=/home/oracle/script/clear_archive.log << EOF
RUN {
delete noprompt archivelog until time 'sysdate-2' backed up 1 times to device type sbt_tape;
crosscheck archivelog all;
delete noprompt expired archivelog all;
}
EXIT;
EOF
