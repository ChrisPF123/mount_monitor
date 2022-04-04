# mount_monitor
mount monitor script for linux


This script is used to monitor any mount point in /etc/fstab to make sure the mount is available. If it is not available it will try and mount the broken mountpoint. If it cannot mount it will post a message to Slack
