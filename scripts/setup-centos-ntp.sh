#!/bin/bash
#http://serverfault.com/questions/368602/how-do-i-update-a-centos-servers-time-from-an-authoritative-time-server
source "/vagrant/scripts/common.sh"

function setupNTPCronJob {
    echo "add hourly cron job of ntpupdate"
    yum -y install ntp
    echo '#!/bin/sh' > /etc/cron.hourly/ntpdate
    echo 'ntpdate time.apple.com' >> /etc/cron.hourly/ntpdate
    chmod 755 /etc/cron.hourly/ntpdate
}

echo "setup ntp cron job"

setupNTPCronJob