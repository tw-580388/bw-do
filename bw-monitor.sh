#!/bin/sh

LOGFILE='log.csv'
MAINTFILE='/tmp/maintenance.txt'

DURATION='5min'
INTERVAL='5'

if [ ! -f "$LOGFILE" ]
then
	printf 'Date,Message\r\n' >> $LOGFILE
	# I'm assuming I can't use a csv utility for this assignment,
	# which is not what I'd do irl
fi


log()
{
	printf "$(date +%T),$1\r\n" >> $LOGFILE
}

check()
{
	if pgrep '^top$' > /dev/null
	then
		log "Top is running"
	elif [ -f $MAINTFILE ]
	then
		log "We are under maintenance mode!"
	else
		top -b 2>&1 1>/dev/null &
		log "Top was started"
	fi
}

END=$(date -d+$DURATION +%s)

while [ $(date +%s) -lt $END ]
do
	check
	sleep $INTERVAL
done

echo "$(grep -c 'maintenance' $LOGFILE) maintenance entries"
