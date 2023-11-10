#!/bin/bash

# set subscription-manager parameters
org_ID=11594663
act_KEY=tempkey

CNT=`sudo subscription-manager identity | grep ${org_ID} | wc -l`

# set os release
ver_ID=$(. /etc/os-release && echo $VERSION_ID)

if [ ${CNT} -ne 0 ]; then
echo registration already done
sudo insights-client --register
exit
fi
#sudo cp /etc/rhsm/rhsm.conf /etc/rhsm/rhsm.conf.sat-backup
#sudo cp /etc/rhsm/rhsm.conf.kat-backup /etc/rhsm/rhsm.conf
sudo subscription-manager remove --all
sudo subscription-manager unregister
sudo subscription-manager clean
sudo yum clean all
sudo rm -rf /var/cache/yum/*
sudo rm -rf /var/cache/dnf
sudo yum remove katello-ca-consumer-labsat.opentlc.com -y
sudo subscription-manager register --org=${org_ID} --activationkey=${act_KEY}
sudo subscription-manager release --set=${ver_ID}
sudo subscription-manager config --rhsm.manage_repos=1
sudo insights-client --register
