#!/bin/bash
### eos account check notify #####################################################
# 
# V 0.0.1 (c) 2018 Wildvest - GNU General Public License v3.0
#
# checking YOUREOSACCNT for changes (ram / staking / permissions) every X min.
# and get notified via the free pushover.net service (Android/IOS/Desktop) 
# if any changes happen. 
#
# set the error THRESHOLD to get notified for connection problems
#
# run it from your cron like this example (every 10 min on the N-59 min):
#
# 1-59/10 * * * * /opt/eoscheckaccount.sh YOUREOSACCNT >> /opt/YOUREOSACCNT.log
# 2-59/10 * * * * /opt/eoscheckaccount.sh YOUREOSACCN2 >> /opt/YOUREOSACCN2.log
# 3-59/10 * * * * /opt/eoscheckaccount.sh YOUREOSACCN3 >> /opt/YOUREOSACCN3.log
# 4-59/10 * * * * /opt/eoscheckaccount.sh YOUREOSACCN4 >> /opt/YOUREOSACCN4.log
#
# script needs curl & jq installed - tested on Ubuntu 18.04 
#
#################################################################################

ENDPOINT="https://api.cypherglass.com:443"	# your next best EOS endpoint, use https !
THRESHOLD="6" 					# connection error threshold, notify after N errors 
PUSHOVER_TOKEN="your_pushover_API_token"	# your pushover.net API token
PUSHOVER_USER="your_pushover_API_user"		# your pushover.net API user

### do not change anything below (unless you know what you're doing ;-) #########

TIMESTAMP="$(/bin/date "+%Y-%m-%d %H:%M:%S")"

if [[ $# -eq 0 ]] ; then
    echo 'ERROR: account_name missing'
    exit 1
fi
VAR1="$1"

OUTPUT="$(/usr/bin/curl -s $ENDPOINT/v1/chain/get_account -X POST -d "{\"account_name\":\"$VAR1\"}" | /usr/bin/jq '.account_name, .ram_quota, .permissions, .total_resources, .self_delegated_bandwidth, .refund_request')"
SHASUM="$(echo $OUTPUT |/usr/bin/shasum -a 256 | /usr/bin/cut -d " " -f 1)"
SHAFILE="$(</tmp/$VAR1.sha256)"
SENTFILE="/tmp/$VAR1.sent"
CONNERRFILE="/tmp/connection.err"
CONNERR="0"
[ -e $CONNERRFILE ] && CONNERR="$(< $CONNERRFILE)"

### lets go

if [ "${#OUTPUT}" -gt "700" ]; then

    [ -e $CONNERRFILE ] && /bin/rm $CONNERRFILE

    if [ "$SHASUM" == "$SHAFILE" ]; then 
	echo "${TIMESTAMP} ${SHAFILE} ${SHASUM}"
    else
	if [ -f $SENTFILE ]; then
	    echo "${TIMESTAMP} ${SHAFILE} ${SHASUM} sent already"
	else
	    OUTPUT2="$(/usr/bin/curl -s --form-string "token=$PUSHOVER_TOKEN" --form-string "user=$PUSHOVER_USER" --form-string "message=$VAR1" https://api.pushover.net/1/messages.json)"
	    echo "${TIMESTAMP} ${SHAFILE} ${SHASUM} ALERT"
	    echo "$OUTPUT $OUTPUT2" > $SENTFILE
        fi
    fi
    echo $SHASUM > /tmp/$VAR1.sha256

else

    echo "${TIMESTAMP} connection error $ENDPOINT"
    if [ "$CONNERR" -lt "$THRESHOLD" ]; then
	CONNERR=$((CONNERR + 1))
        echo $CONNERR > $CONNERRFILE
    else
	OUTPUT3="$(/usr/bin/curl -s --form-string "token=$PUSHOVER_TOKEN" --form-string "user=$PUSHOVER_USER" --form-string "message=connection error $ENDPOINT" https://api.pushover.net/1/messages.json)"
	[ -e $CONNERRFILE ] && /bin/rm $CONNERRFILE
    fi

fi
