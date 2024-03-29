#!/bin/sh

# Env variables
USER=ilan
FILE=/etc/samba/smb.conf

# Set up Samba
echo sudo cp ${FILE} ${FILE}.bak

# Add Code dir
sudo tee -a  ${FILE} > /dev/null << EOT

[code]
  comment = Code project directory
  path = ${HOME}/code
  read only = no
  browseable = yes
  valid user = ilan
  create mask = 0644
  directory mask = 0755
  follow symlinks = yes
  wide links = yes
EOT

# Auth user
sudo smbpasswd -L -a ${USER}
sudo smbpasswd -L -e ${USER}
sudo service smbd restart
sudo update-rc.d smbd enable
