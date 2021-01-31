#!/bin/bash

for entry in $(ls tasks/*.sh); do
	echo "Preparing $entry ..."
	echo "Removing old log file ..."
	rm -f ./tasks/${entry%.*}.log
	echo "Running task ..."
	$entry &> ${entry%.*}.log
	echo "Task done. Task log:"
	cat ${entry%.*}.log
	echo ""
	echo "Sending log via email"
	echo "The task log can be found from the attachment" | mutt -F muttrc-uptifier -s "Log of task $(basename ${entry%.*})" -a ${entry%.*}.log -e 'my_hdr From: Email logger <`cat /etc/nullmailer/forced-from`>' -- `cat /etc/nullmailer/adminaddr`
	echo ""
done


