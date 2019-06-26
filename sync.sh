#!/bin/bash
#
#
SRC_DIR=${1:-"NONE"}
#SRC_DIR=${PWD}

# RSYNC_EXCLUDE_1=""
#--exclude="$RSYNC_EXCLUDE_1"

if [ ! -d $SRC_DIR ]; then
    echo "Source dir is missing: "$SRC_DIR
    pwd
    exit 1
fi

_rsync_to_target() {
  echo ""
  echo "Synching $SRC_DIR to $TARGET_HOST at $TARGET_DIR using $SSH_KEY"
  VERBOSE_OPT="q"
  VERBOSE_OPT="p"
  VERBOSE_OPT="v"
  VERBOSE_OPT=""

  # Check $TARGET_HOST is available
  for i in $(seq 6 )
  do
    RESPONSE_STR=`ssh -i $SSH_KEY $TARGET_USER@$TARGET_HOST date +%Y-%m-%d-%H:%M:%S`
    EXIT_CODE=$?
    echo "Target host: "$TARGET_HOST $RESPONSE_STR $EXIT_CODE
    [ $EXIT_CODE = "0" ] && { echo "Host OK"; break; }
  	sleep 5
  done

  if [ $EXIT_CODE = "0" ]; then
    # -"$VERBOSE_OPT"raH $SRC_DIR -e ssh -i "$SSH_KEY $TARGET_USER"@"$TARGET_HOST:$TARGET_DIR"
    rsync -vraH  -e """ssh -i $SSH_KEY""" $SRC_DIR $TARGET_USER@$TARGET_HOST:$TARGET_DIR

  else
    echo "Target host is not available "$TARGET_HOST $RESPONSE_STR $EXIT_CODE
  fi
}

#
TARGET_SYS2=ddryderk8s1-dryderks8demo1-d7gk0agg.srv.ravcloud.com
TARGET_SYS3=k8s-dryderks8demo1-wkdapalx.srv.ravcloud.com
TARGET_SYS4=drydersys3apps-dryderdockk8senv1-731k3c4v.srv.ravcloud.com
TARGET_SYS5=sys5apps-dryderenv1-tjvahlcy.srv.ravcloud.com
TARGET_SYS6=sys6apps-dryderenv1-hnvdayrt.srv.ravcloud.com
TARGET_USER=ddr
TARGET_DIR=/home/ddr/
SSH_KEY=~/.ssh/ddr-04012018

TARGET_HOST=$TARGET_SYS3
#_rsync_to_target

TARGET_HOST=$TARGET_SYS4
#_rsync_to_target

TARGET_HOST=$TARGET_SYS5
#_rsync_to_target


TARGET_HOST=$TARGET_SYS6
SSH_KEY=~/.ssh/ddr-02052019
_rsync_to_target
