#!/bin/bash

if ! [ -x "$(command -v ruby)" ]; then
  apt update
  apt install -y ruby-full ruby-bundler build-essential
fi

systemctl list-unit-files | grep mongod 1>/dev/null
if [ $? -eq 1 ]; then 
  apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv d68fa50fea312927
  echo "deb http://repo.mongodb.org/apt/ubuntu xenial/mongodb-org/3.2 multiverse" > /etc/apt/sources.list.d/mongodb-org-3.2.list
  apt update
  apt install -y mongodb-org
  systemctl start mongod
  systemctl enable mongod 
fi

if [ ! -f /reddit/app.rb ]; then 
  git clone -b monolith https://github.com/express42/reddit.git
  cd reddit && bundle install
fi


ps aux | grep puma | grep 9292 1>/dev/null
if [ $? -eq 1 ]; then
  cd /reddit
  puma -d
fi
