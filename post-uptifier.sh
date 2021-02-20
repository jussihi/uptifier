#!/bin/bash

SOURCE="${BASH_SOURCE[0]}"
while [ -h "$SOURCE" ]; do # resolve $SOURCE until the file is no longer a symlink
  DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"
  SOURCE="$(readlink "$SOURCE")"
  [[ $SOURCE != /* ]] && SOURCE="$DIR/$SOURCE" # if $SOURCE was a relative symlink, we need to resolve it relative to the path where the symlink file was located
done
DIR="$( cd -P "$( dirname "$SOURCE" )" && pwd )"

pushd "${DIR}"


echo "Main log for post-reboot tasks on $(date)" > post-reboot-tasks/body.txt
echo -e "Logs for failed tasks as attachments\n\n" >> post-reboot-tasks/body.txt
echo -e "\n\n" >> post-reboot-tasks/body.txt

successTasks=()
failTasks=()

for entry in $(ls post-reboot-tasks/*.sh); do
	echo "Preparing $entry ..."
	echo "Removing old log file ..."
	rm -f ${entry%.*}.log
	echo "Running task ..."
	if ! $entry &> ${entry%.*}.log; then
		failTasks+=(${entry%.*})
		echo "Task done. Task log:"
		cat ${entry%.*}.log
	else
		successTasks+=(${entry%.*})
		echo "Task done. Task log:"
		cat ${entry%.*}.log
		rm -rf ${entry%.*}.log
	fi
	echo ""; echo ""
done

echo "FAILED tasks: $(echo "${#failTasks[@]}")" >> post-reboot-tasks/body.txt
for i in ${!failTasks[@]}; do
  echo "${failTasks[$i]}" >> post-reboot-tasks/body.txt
done

echo -e "\n\n" >> post-reboot-tasks/body.txt

echo "SUCCEEDED tasks: $(echo "${#successTasks[@]}")" >> post-reboot-tasks/body.txt
for i in ${!successTasks[@]}; do
  echo "${successTasks[$i]}" >> post-reboot-tasks/body.txt
done

cat post-reboot-tasks/body.txt | mutt -F muttrc-uptifier -s "Log of task $(basename ${entry%.*})" ( printf -- '-a %q ' post-reboot-tasks/*.log ) -e 'my_hdr From: Email logger <`cat /etc/nullmailer/forced-from`>' -- `cat /etc/nullmailer/adminaddr`

popd
