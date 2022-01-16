#!/bin/sh

#Installing FHEM as by the Step-by-Step Guide.
#Gruppe 2 - WWI2019D - DHBW Stuttgart


# Dependencies 
sudo apt update -y
sudo apt upgrade -y 
sudo apt install wget -y
sudo apt install libfuse2


#Perl Dependencies

sudo apt -y install perl-base libdevice-serialport-perl libwww-perl libio-socket-ssl-perl libcgi-pm-perl libjson-perl sqlite3 libdbd-sqlite3-perl libtext-diff-perl libtimedate-perl libmail-imapclient-perl libgd-graph-perl libtext-csv-perl libxml-simple-perl liblist-moreutils-perl fonts-liberation libimage-librsvg-perl libgd-text-perl libsocket6-perl libio-socket-inet6-perl libmime-base64-perl libimage-info-perl libusb-1.0-0-dev libnet-server-perl
sudo apt -y install libdate-manip-perl libhtml-treebuilder-xpath-perl libmojolicious-perl libxml-bare-perl libauthen-oath-perl libconvert-base32-perl libmodule-pluggable-perl libnet-bonjour-perl libcrypt-urandom-perl nodejs npm libnet-dbus-perl
sudo apt-get install -y libio-socket-ssl-perl

#Installing FHEM

sudo wget http://fhem.de/fhem-6.1.deb
sudo dpkg -i fhem-6.1.deb
sudo useradd --system --home /opt/fhem --gid dialout --shell /bin/false fhem
sudo cp /opt/fhem/contrib/init-scripts/fhem.service /etc/systemd/system/
sudo systemctl daemon-reload



#evil magic
sudo systemctl stop fhem

sudo echo "define tPort telnet 7072 global" >> /opt/fhem/fhem.cfg
sudo echo "setuuid tPort 61df18fe-f33f-7a16-f5f4-dcf9c8671780f74c" >> /opt/fhem/fhem.cfg
sudo echo "define allowed_tPort allowed" >> /opt/fhem/fhem.cfg
sudo echo "setuuid allowed_tPort 61df1914-f33f-7a16-56cd-03382e3488cf2648" >> /opt/fhem/fhem.cfg

sudo echo "attr allowed_tPort globalpassword start123" >> /opt/fhem/fhem.cfg
sudo echo "attr allowed_tPort validFor tPort" >> /opt/fhem/fhem.cfg

sudo systemctl start fhem

#end of evil magic

# FTUI Setup 
sleep 5s

sudo perl /opt/fhem/fhem.pl 7072 'update all https://raw.githubusercontent.com/knowthelist/fhem-tablet-ui/master/controls_fhemtabletui.txt'
sudo perl /opt/fhem/fhem.pl 7072 'define TABLETUI HTTPSRV ftui/ ./www/tablet/ Tablet-UI' 
sudo perl /opt/fhem/fhem.pl 7072 'attr WEB longpoll websocket'

sudo perl /opt/fhem/fhem.pl 7072 'save'
sudo perl /opt/fhem/fhem.pl 7072 'shutdown restart'

# Install FTUI Files 
sudo systemctl stop fhem 

sudo rm -rf /opt/fhem/www/tablet
#cd /opt/fhem/www
#sudo git clone https://github.com/tabascoel/tablet.git
#cd -
#sudo systemctl start fhem 


