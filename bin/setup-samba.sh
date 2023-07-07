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
  browseable = yes
  writeable = yes
  guest ok = no
  write list = ilan
  create mask = 0644
  directory mask = 0755
EOT

# Auth user
sudo smbpasswd -L -a ${USER}
sudo smbpasswd -L -e ${USER}
sudo service smbd restart
sudo update-rc.d smbd enable
