# Install Apache
apt update
apt install httpd httpd-devl

# Copy configuration files
cp httpd.conf /etc/httpd/conf/httpd.conf
cp httpd.vhosts /etc/httpd/conf/httpd-vhost.conf

# Start Apache and configure it to run at boot
service httpd Start
chkconfig httpd on