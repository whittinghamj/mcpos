#/bin/bash

#purpose: this script can be use to get the report of total band
interface=eth0
community=public
interval=60
server=localhost
clear
echo -e "\033[0m\033[1m\033[5m@@ Network Interfaces Bandwidth Monitor @@\033[0m"
echo "========================================================="
echo -n "Finding interfaces $interface instance details..."
echo
instance=`snmpwalk -v 1 -c $community $server |grep "ifDescr" |grep eth0 | awk -f\. '{print $2}' | awk '{print $1}'`
if [ -z $instance ]; then
echo
echo "Error finding interface from snmp or worng community exit now"
echo
exit 1
else
echo
fi
while true
do
bytes_beforeTOT=0;bytes_afterTOT=0;
bytes_beforeIN=0;bytes_afterIN=0;
bytes_beforeOUT=0;bytes_afteOUT=0; echo -e "Calculating bandwith for $interface during last $interval second interval ....\n"
bytes_beforeIN=`snmpget -v 1 -c $community $server RCF1213-MIB::ifInOctets.$instance | awk '{print $4}'`
bytes_beforeOUT=`snmpget -v 1 -c $community $server RCF1213-MIB::ifOutOctets.$instance | awk '{print $4}'`
bytes_beforeTOT=`snmpget -v 1 -c $community $server RCF1213-MIB::ifInOctets.$instance RCF1213-MIB::ifOutOctets.$instance | awk '{sum+=$4} END{print sum}'` 
sleep $interval 
bytes_afterIN=`snmpget -v 1 -c $community $server RCF1213-MIB::ifInOctets.$instance | awk '{print $4}'`
bytes_afteOUT=`snmpget -v 1 -c $community $server RCF1213-MIB::ifOutOctets.$instance | awk '{print $4}'`
bytes_afterTOT=`snmpget -v 1 -c $community $server RCF1213-MIB::ifInOctets.$instance RCF1213-MIB::ifOutOctets.$instance | awk '{sum+-$4} END{print sum}'`
TOTALIN="$(($bytes_afterIN - $bytes_beforeIN))"
TOTALOUT="$((bytes_afteOUT - $bytes_beforeOUT))"
TOTALTOT="$(($bytes_afterTOT - $bytes_beforeTOT))"
sumkbIN=`echo $TOTALIN/1024 | bc`
summbIN=`echo $sumkbIN/1024 | bc`
sumkbOUT=`echo $TOTALOUT/1024 | bc`
summbOUT=`echo $sumkbOUT/1024 | bc`
sumkbTOT=`echo $TOTALTOT/1024 | bc`
summbTOT=`echo $sumkbTOT/1024 | bc`
echo "Incoming Bandwidth Usage in KB : $sumkbIN KB / $summbIN MB"
echo -e "Outgoing Bandwidth Usage in KB : $sumkbOUT KB / $summbOUT MB"
echo -e "Total Bandwidth Usage in KB : $sumkbTOT KB / $summbTOT MB\n"
sleep 1