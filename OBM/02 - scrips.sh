#!/bin/bash
# This unsupported script will archive and delete events from 90 days until 10 days
# with a 60 second sleep between running each command
for ((i=90; i>=10; i--))
do
  # Calculate the date ${i} days ago
  target_date=$(date -d "$i days ago" +"%Y-%m-%dT%H-%M-%S")
  echo "Processing events from $target_date (i=$i)..."
  if [ $i -lt 90 ]; then
    # Run the archive command with the date and save output to /tmp/date.xml
    /opt/HP/BSM/bin/opr-archive-events.sh -a -t "${i}D" -force -o /tmp/opr-event-download.$target_date.xml
    archive_exit_code=$?
    # Check if the archive command succeeded
    if [ $archive_exit_code -eq 0 ]; then
      echo "Archive successful for $target_date (i=$i) see /tmp/opr-event-download.$target_date.xml"
    else
      echo "Archive failed for $target_date (i=$i) with exit code $archive_exit_code"
    fi
    sleep 60
    # Run the delete command with the date
    /opt/HP/BSM/bin/opr-archive-events.sh -d -t "${i}D" -force
    delete_exit_code=$?
    # Check if the delete command succeeded
    if [ $delete_exit_code -eq 0 ]; then
      echo "Delete successful for $target_date (i=$i)"
    else
      echo "Delete failed for $target_date (i=$i) with exit code $delete_exit_code"
    fi
    sleep 60
  fi
done

echo "Process complete."