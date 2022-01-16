#!/bin/sh
#make dir and cd
sudo mkdir /root/ca
cd /root/ca

#make pem
echo "fhem.SSL"
sudo openssl req -new -x509 -newkey rsa:2048 -keyout fhemSSL.pem -out cacert.pem -days 3650
sudo chmod 600 fhemSSL.pem

#generate rsa
echo "serverkey.pem"
sudo openssl genrsa -out serverkey.pem -aes128 2048


sudo openssl rsa -in serverkey.pem -out serverkey.pem

echo "Enter IP of PI in Common Name!!!!"
sudo openssl req -new -key serverkey.pem -out req.pem -nodes

# Changes to openssl.cnf
sudo rm -f /etc/ssl/openssl.cnf
sudo cp /home/pi/openssl.cnf.prefilled /etc/ssl/openssl.cnf
sudo chown root:root /etc/ssl/openssl.cnf


# new files 
sudo echo 01 > serial
sudo touch index.txt


# ca 
echo "ca req.pem"
openssl ca -in req.pem -notext -out servercert.pem

#new dir in /opt/fhem
sudo mkdir /opt/fhem/certs

sudo cp serverkey.pem /opt/fhem/certs/serverkey.pm
sudo cp servercert.pem /opt/fhem/certs/servercert.pm

sudo chown -R fhem:dialout /opt/fhem/certs/


sudo perl /opt/fhem/fhem.pl 7072 'attr WEB sslVersion TLSv12:!SSLv3'
sudo perl /opt/fhem/fhem.pl 7072 'attr WEB HTTPS 1'
sudo perl /opt/fhem/fhem.pl 7072 'save'

