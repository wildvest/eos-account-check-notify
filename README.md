# eos-account-check-notify
## bash script to check your EOS account for changes (ram / staking / permissions) every X min. and notifies on changes via the FREE push message service pushover.net

get notified via the free pushover.net service (Android/IOS/Desktop) if any changes to your EOS account happen. 
set the error THRESHOLD to get notified for connection problems.

run it from your cron like this example (every 10 min on the N-59 min):

`1-59/10 * * * * /opt/eoscheckaccount.sh YOUREOSACCNT >> /opt/YOUREOSACCNT.log`

`2-59/10 * * * * /opt/eoscheckaccount.sh YOUREOSACCN2 >> /opt/YOUREOSACCN2.log`

`3-59/10 * * * * /opt/eoscheckaccount.sh YOUREOSACCN3 >> /opt/YOUREOSACCN3.log`

`4-59/10 * * * * /opt/eoscheckaccount.sh YOUREOSACCN4 >> /opt/YOUREOSACCN4.log`

`# remove sent lock once / day'
`0 0 * * * /opt/eosremovesent.sh`


#### this bash script needs ONLY curl & jq installed (default) no other APIs - tested on Ubuntu 16.04 & 18.04 

PS: the script is **not** checking for unstaked token balances (EOS, others)
