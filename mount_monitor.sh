#!/bin/bash
#install in /usr/local/bin
mountpoints=( $(awk '!/^#/ && /mnt|docker/ {print $2}' /etc/fstab) )
hostname=$(hostname)
function my_ls {
for mount in ${mountpoints[@]};
do
    ls $mount
done
}



for mount in ${mountpoints[@]};
do
  echo "checking $mount"
        if ! findmnt "$mount" &> /dev/null; then
        # If above did not exit
                echo "${mount} has failed, remounting"
                mount ${mount}
                if [ $? -eq 0 ]; then
                        echo "${mount} has been mounted."
                else
        # Mounting failed, send slack
                curl -X POST -H 'Content-type: application/json' --data '{"text":"Mounting of '${mount}' failed on '$hostname'"}' ***enter slack webhook URL***
                fi
                else
                        export -f my_ls
                        timeout 10 bash -c my_ls
                        if [ $? -eq 0 ]; then
                                echo "cmd finished in time"
                        else
                                echo "cmd did NOT finish in time"
                                curl -X POST -H 'Content-type: application/json' --data '{"text":"Mount '${mount}' is hung on '$hostname'"}' ***enter slack webhook URL***
                        fi
                fi
done


exit
