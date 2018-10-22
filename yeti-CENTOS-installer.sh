#!/bin/bash
#run this as root or i.e.  sudo su - and run it or sudo - /yeti-install.sh
#cabby docs https://cabby.readthedocs.io/en/stable/user.html

yum install vim curl wget net-tools nginx
cd /opt
git clone https://github.com/yeti-platform/yeti.git
pip install django libtaxii pyOpenSSL uwsgi cabby django-solo taxii_services python-dateutil
pip install -r requirements.txt
yarn install
cd yeti

PWD1=`pwd`
sudo chmod +x $PWD1/extras/centos_bootstrap.sh
sudo chmod +x $PWD1/extras/systemd/*
sed -i s'/\/usr\/local\/bin/\/bin/g' $PWD1/extras/systemd/*
sudo ln -s $PWD1/extras/systemd/* /lib/systemd/system/

nohup $PWD1/extras/centos_bootstrap.sh &


systemctl list-unit-files | grep yeti

sudo systemctl enable yeti_web.service
sudo systemctl enable yeti_analytics.service
sudo systemctl enable yeti_beat.service
sudo systemctl enable yeti_exports.service
sudo systemctl enable yeti_feeds.service
sudo systemctl enable yeti_oneshot.service
sudo systemctl enable yeti_uwsgi.servic

sudo systemctl restart yeti_web.service
sudo systemctl restart yeti_analytics.service
sudo systemctl restart yeti_beat.service
sudo systemctl restart yeti_exports.service
sudo systemctl restart yeti_feeds.service
sudo systemctl restart yeti_oneshot.service
sudo systemctl restart yeti_uwsgi.service


#sudo systemctl stop yeti_web.service
#sudo systemctl stop yeti_analytics.service
#sudo systemctl stop yeti_beat.service
#sudo systemctl stop yeti_exports.service
#sudo systemctl stop yeti_feeds.service
#sudo systemctl stop yeti_oneshot.service
#sudo systemctl stop yeti_uwsgi.service



#sudo systemctl start yeti_web.service
#sudo systemctl start yeti_analytics.service
#sudo systemctl start yeti_beat.service
#sudo systemctl start yeti_exports.service
#sudo systemctl start yeti_feeds.service
#sudo systemctl start yeti_oneshot.service
#sudo systemctl start yeti_uwsgi.service

ls plugins/feeds/public/ | sed s/\.pyc//g | sed s/\.py//g | sed s/^/python\ testfeeds.py\ /g > /opt/yeti/process-feeds.sh

grep "(Feed)"  plugins/feeds/public/*.py | awk -F : '{print $2}'| sed s/\class\ //g | sed s/\(Feed\)//g | sed s/^/python\ testfeeds.py\ /g > /opt/yeti/process-feeds.sh


chmod +x /opt/yeti/process-feeds.sh
cd /opt/yeti/
./process-feeds.sh

#cd /opt
#git clone //github.com/eclecticiq/cabby.git
#cd cabby

# Test using caby

taxii-poll --host hailataxii.com --collection guest.Abuse_ch --discovery /taxii-discovery-service > ~/guest.Abuse_ch

