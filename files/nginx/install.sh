#! /bin/sh
echo "---- 1 Installing Prerequisites"
sudo apt-get install dpkg-dev debhelper
sudo apt-get install libpcre3-dev libxslt-dev libgd2-xpm libgd2-xpm-dev libgeoip-dev libpam0g-dev libluajit-5.1-dev libperl-dev

echo "---- 2 Creating build env"
cp -r /vagrant/files/nginx /home/vagrant/
cd /home/vagrant/nginx

echo "---- 3 Building"
dpkg-source -x nginx_1.4.1-1.dsc
cd nginx-1.4.1/
patch -p1  < ../nginx-1.3.14-no_buffer-v7.patch
fakeroot debian/rules build
fakeroot debian/rules binary

echo "---- 4 Installing"
cd ..
sudo dpkg --install nginx_1.4.1-1_all.deb nginx-common_1.4.1-1_all.deb nginx-doc_1.4.1-1_all.deb nginx-full_1.4.1-1_amd64.deb

