#!/bin/bash

# --------------------------------------------------------------------------- #
#                                                                             #
#    This program is free software: you can redistribute it and/or modify     #
#    it under the terms of the GNU General Public License as published by     #
#    the Free Software Foundation, either version 3 of the License, or        #
#    (at your option) any later version.                                      #
#                                                                             #
#    This program is distributed in the hope that it will be useful,          #
#    but WITHOUT ANY WARRANTY; without even the implied warranty of           #
#    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the            #
#    GNU General Public License for more details.                             #
#                                                                             #
#    You should have received a copy of the GNU General Public License        #
#    along with this program.  If not, see <https://www.gnu.org/licenses/>.   #
#                                                                             #
#                                                                             #
# --------------------------------------------------------------------------- #

## Set Timezone to Asia/Manila
ln -fs /usr/share/zoneinfo/Asia/Manila /etc/localtime

## Install Resiquites
yum install wget curl nano -y

## Download Repositories
mkdir ~/repo/
cd ~/repo/
wget http://repo.iotti.biz/CentOS/7/noarch/lux-release-7-1.noarch.rpm
wget https://rpms.remirepo.net/enterprise/remi-release-7.rpm

## Install Release
rpm -ivh ~/repo/lux-release-7-1.noarch.rpm
rpm -ivh ~/repo/remi-release-7.rpm
yum install epel-release -y

## Update and Upgrade System
yum update -y
yum upgrade -y

## Initialize Variable
OS=`uname -p`;
MYIP=`curl -s ifconfig.me`;
MYIP2="s/xxxxxxxxx/$MYIP/g";

## Remove Unused Packages
yum remove sendmail httpd cyrus-sasl -y;
yum autoremove -y

## Install Authentication Packages
yum install pam_mysql libnss-mysql -y

## Install Server Packages
yum install dropbear squid -y

## Setup DropBear
wget -O /etc/sysconfig/dropbear "https://raw.githubusercontent.com/0DinZ/CentOS-7-AutoScript/master/conf/dropbear.conf"

## Setup Squid Proxy
wget -O /etc/squid/squid.conf "https://raw.githubusercontent.com/0DinZ/CentOS-7-AutoScript/master/conf/squid-centos.conf"
sed -i $MYIP2 /etc/squid/squid.conf

## Restart and Enable Services
systemctl restart squid
systemctl restart dropbear
systemctl restart sshd
systemctl enable squid
systemctl enable dropbear
