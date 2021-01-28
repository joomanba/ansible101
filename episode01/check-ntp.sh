if ! dpkg -l | grep -qw ntp; then
	apt install ntp
else
	echo "ntp is installed"
fi
