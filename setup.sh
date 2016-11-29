#!/bin/bash
#
# Author : Fred Campos fredcamps/dev-env
# Script for installing my env apps
#

DISTRO="ubuntu-xenial"
USER_NAME="$(whoami)"
HOME_PATH="/home/${USER_NAME}"
VAGRANT_VERSION="1.8.7"
KERNEL="$(uname -s)"
ARCH="$(uname -m)"
CURL_VERSION="7.51.0"
TIMEZONE="America/Sao_Paulo"

# utils
echo "<< installing some utilities and deps"
sudo apt-get update
sudo apt-get install -y aptitude  \
    bison \
    autoconf \
    automake \
    build-essential \
    libssl-dev \
    git \
    htop \
    iotop \
    vim \
    libreoffice \
    tmux \
    tmuxinator \
    xclip \
    subversion \
    midori \
    python-software-properties \
    python-dev \
    ctags \
    tree \
    "linux-headers-$(uname -r)" \
    libxml2-dev \
    libbz2-dev \
    libmcrypt-dev \
    libreadline-dev \
    libxslt1-dev \
    libicu-dev \
    libstdc++6-4.7-dev \
    re2c \
    nfs-client \
    cups \
    libsmbclient \
    xfce4-whiskermenu-plugin \ 
    xfce4-indicator-plugin \
    xfce4-goodies \
    libmysqlclient-dev \
    galculator \ 
    chromium \ 
    flashplugin-installer \
    xchm \
    wget
echo "<< installing some utilities and deps  [end]"

# vim spf-13
sh <(curl https://j.mp/spf13-vim3 -L)

# db clients
echo "<< installing db clients"
sudo apt-get install -y sqlite3 \
    postgresql-client \
    redis-tools \
    mongodb-clients \
    mysql-client
echo "<< installing db clients [end]"

# shell
sudo apt-get install shellcheck
if [ ! -f "$(command which zsh)" ]; then
    echo "<< installing zsh"
    sudo apt-get install -y zsh
    echo "<< changing shell, maybe it will ask password"
    chsh -s /bin/zsh
    /bin/zsh
    echo "<< installing zsh [end]"
fi

# python
echo "<< installing python & tools"
sudo apt-get install -y python3-dev python3-pip
sudo pip3 install --upgrade pip
sudo pip3 install pylama pylama_pylint pylama_gjslint jedi autopep8 virtualenvwrapper radon isort pylint pylint-mccabe
echo "<< installing python & tools [end]"

# c/cpp
echo "<< installing clang"
sudo apt-get install -y clang uncrustify
echo "<< installing clang [end]"

#go
echo "<< installing goLang"
sudo apt-get install -y golang golang-go.tools
echo "<< installing goLang [end]"

# atom
if [ ! -f "$(which atom)" ]; then
    echo "<< installing atom editor & plugins"
    wget -O /tmp/atom.deb https://atom.io/download/deb
    sudo dpkg -i /tmp/atom.deb
    sudo apt-get -y -f install
    if [ ! -f "$(which apm)" ]; then
        echo "<< [error] apm not found"
        exit 0
    fi
    apm install atom-beautify
    apm install autocomplete-paths
    apm install autocomplete-python
    apm install autocomplete-clang
    apm install atom-jinja2
    apm install go-plus
    apm install dockblockr
    apm install language-docker
    apm install linter
    apm install linter-shellcheck
    apm install linter-pylama
    apm install linter-clang
    apm install go-plus
    apm install minimap
    apm install language-x86
    apm install language-r
    apm install autocomplete-R
    apm install linter-lintr
    echo "<< installing atom editor & plugins [end]"
fi

# docker
if [ ! -f "$(which docker)" ]; then
    echo "<< installing docker"
    sudo apt-key adv --keyserver hkp://p80.pool.sks-keyservers.net:80 --recv-keys 58118E89F3A912897C070ADBF76221572C52609D
    sudo touch /etc/apt/sources.list.d/docker.list
    sudo su -c "echo -e \"deb https://apt.dockerproject.org/repo ${DISTRO} main\" > /etc/apt/sources.list.d/docker.list"
    sudo apt-get update && sudo apt-get install docker-engine && sudo pip install docker-compose
    sudo gpasswd -a "${USER_NAME}" docker
    echo "<< installing docker [end]"
fi

# vagrant
if [ ! -f "$(which vagrant)" ]; then
    echo "<< installing vagrant & virtualbox"
    sudo apt-get install virtualbox -y
    wget -O "/tmp/vagrant_${VAGRANT_VERSION}_${ARCH}.deb" "https://dl.bintray.com/mitchellh/vagrant/vagrant_${VAGRANT_VERSION}_${ARCH}.deb"
    sudo dpkg -i "/tmp/vagrant_${VAGRANT_VERSION}_${ARCH}.deb" || {
        sudo apt-get install -y -f
    }
    echo "<< installing vagrant & virtualbox [end]"
fi

#curl
echo "<< installing curl"
sudo apt-get build-dep -y curl
git clone https://github.com/tatsuhiro-t/nghttp2.git ~/Downloads && cd ~/Downloads/nghttp2
autoreconf -i && automake && autoconf && ./configure && make && sudo make install && cd ~/Downloads
wget http://curl.haxx.se/download/curl-${CURL_VERSION}.tar.bz2 && tar -jxvf curl-${CURL_VERSION}.tar.bz2
cd curl-${CURL_VERSION} && ./configure --with-nghttp2=/usr/local --with-ssl && make && sudo make install
sudo ldconfig
echo "<< installing curl [end]"

echo "<< cleaning and removing old packages "
sudo apt-get autoremove -y
sudo apt-get autoclean -y
echo "<< cleaning and removing old packages [end]"
