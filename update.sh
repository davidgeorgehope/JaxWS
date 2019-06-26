#!/bin/bash
#
#
cmd=${1:-"1"}
TARGET_HOST="NONE"
TARGET_APP="NONE"


if [ $cmd == "1" ]; then
  TARGET_HOST="r-sys1"
  TARGET_APP="start-VMWARE_VMC_DEMO_1"

elif [ $cmd == "11" ]; then
  TARGET_HOST="r-sys6"
  TARGET_APP="start-VMWARE_VMC_1"

elif [ $cmd == "2" ]; then
  TARGET_HOST="r-sys4"
  TARGET_APP="start-VMWARE_VMC_2"

elif [ $cmd == "3" ]; then
  TARGET_HOST="r-sys5"
  TARGET_APP="start-VMWARE_VMC_10"
fi

PID_FILE="/tmp/APPD_update_$TARGET_APP.pid"

ssh $TARGET_HOST  "cd /home/ddr/APPD_BIZ_JOURNEY_1; ./ctl.sh app stop"

./sync.sh APPD_BIZ_JOURNEY_1

ssh $TARGET_HOST  "cd /home/ddr/APPD_BIZ_JOURNEY_1; ./ctl.sh app $TARGET_APP"  &
echo $! > $PID_FILE
ssh $TARGET_HOST  "cd /home/ddr/APPD_BIZ_JOURNEY_1; ./ctl.sh sddc start"
ssh $TARGET_HOST  "cd /home/ddr/APPD_BIZ_JOURNEY_1; ./ctl.sh health wait"
echo "---------------------------STARTED-----------------------------"

# Wait then close the ssh connection
sleep 900
echo "---------------------------CLOSING-----------------------------"
kill -9  `cat $PID_FILE`
rm -f $PID_FILE
sleep 5
echo

echo "---------------------------COMPLETE-----------------------------"
ssh $TARGET_HOST  "cd /home/ddr/APPD_BIZ_JOURNEY_1; ./ctl.sh health wait"

echo
