# eos-account-check-notify
## bash script to check your EOS account for changes (ram / staking / permissions) every X min. and notifies on changes via the FREE push message service pushover.net

get notified via the free pushover.net service (Android/IOS) if any changes to your EOS account happen. 
set the error THRESHOLD to get notified for connection problems.

run it from your cron like this example (every 10 min on the 3 rd min):

`3-59/10 * * * * /opt/eoscheckaccount.sh YOUREOSACCNT >> /opt/YOUREOSACCNT.log`

script needs ONLY curl & jq installed no other APIs - tested on Ubuntu 18.04 

PS: the script is not checking for unstaked balances
