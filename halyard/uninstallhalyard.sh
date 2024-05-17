#!/usr/bin/env bash

if [[ `/usr/bin/id -u` -ne 0 ]]; then
  echo "uninstall-halyard.sh  must be executed with root permissions; exiting"
  exit 1
fi

read -p "This script uninstalls Halyard and deletes all of its artifacts, are you sure you want to continue? (Y/n): " yes

if [ "$yes" != "y" ] && [ "$yes" != "Y" ]; then
  echo "Aborted"
  exit 0
fi

apt purge -y spinnaker-halyard

rm /opt/halyard -rf
rm /var/log/spinnaker/halyard -rf
rm -f /usr/bin/hal /usr/bin/update-halyard

echo "Deleting halconfig and artifacts"
rm /opt/spinnaker/config/halyard* -rf
rm /home/spinnaker/.hal -rf