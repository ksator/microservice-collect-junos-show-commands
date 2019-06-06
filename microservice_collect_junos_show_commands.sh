# cd /
echo "Collect Junos show commands"

if [ -f "inputs/hosts" ]
then
	ansible-playbook playbook.yml -i inputs/hosts
else
	echo "No inventory file found, aborting"
fi

