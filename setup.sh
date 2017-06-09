#!/bin/bash
#
# Author : Fred Campos fredcamps/dev-env
# Script for installing my env apps
#
VENDOR="$(lsb_release -i | awk '{print $2}' | awk '{print tolower($0)}')"
CODENAME="$(lsb_release -cs)"
DISTRO="${VENDOR}-${CODENAME}"
USER_NAME="$(whoami)"
HOME_PATH="/home/${USER_NAME}"
CURL_VERSION="7.51.0"
TIMEZONE="America/Sao_Paulo"

# utils
echo "<< installing some utilities and deps"
sudo apt-get update
sudo apt-get install -y aptitude  \
    aufs-tools \
    bison \
    autoconf \
    automake \
    build-essential \
    libssl-dev \
    git \
    htop \
    iotop \
    vim \
    emacs-nox \
    libreoffice \
    tmux \
    tmuxinator \
    xclip \
    subversion \
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
    wget \
    silversearcher-ag
echo "<< installing some utilities and deps  [end]"

# vim spf-13
sh <(curl https://j.mp/spf13-vim3 -L)

# shell
sudo apt-get install shellcheck
if [ ! -f "$(command which zsh)" ]; then
    echo "<< installing zsh"
    sudo apt-get install -y zsh
    echo "<< changing shell, maybe it will ask password"
    chsh -s /bin/zsh
    echo "<< installing zsh [end]"
fi

# python
echo "<< installing python & tools"
sudo apt-get install -y python-pip
pip install --upgrade pip
pip install virtualenvwrapper
pip install jedi \
            autopep8 \
            pycodestyle \
            pydocstyle \
            radon \
            pylint \ 
            flake8 \
            radon
echo "<< installing python & tools [end]"

# c/cpp
echo "<< installing clang"
sudo apt-get install -y clang clang-format libclang-dev libclang1 global cmake llvm-dev llvm-runtime
echo "<< installing clang [end]"

#curl
echo "<< installing curl"
sudo apt-get build-dep -y curl
git clone https://github.com/tatsuhiro-t/nghttp2.git ~/Downloads && cd ~/Downloads/nghttp2
autoreconf -i && automake && autoconf && ./configure && make && sudo make install && cd ~/Downloads
wget http://curl.haxx.se/download/curl-${CURL_VERSION}.tar.bz2 && tar -jxvf curl-${CURL_VERSION}.tar.bz2
cd curl-${CURL_VERSION} && ./configure --with-nghttp2=/usr/local --with-ssl && make && sudo make install
sudo ldconfig
echo "<< installing curl [end]"

# docker
if [ ! -f "$(which docker)" ]; then
    echo "<< installing docker"
    
    sudo su -c \
        "echo deb [arch=amd64] https://download.docker.com/linux/${VENDOR} ${CODENAME} stable >> /etc/apt/sources.list.d/docker.list"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo apt-get update && sudo apt-get install docker-ce && sudo pip install docker-compose
    sudo gpasswd -a "${USER_NAME}" docker
    echo "<< installing docker [end]"
fi

echo "<< cleaning and removing old packages "
sudo apt-get autoremove -y
sudo apt-get autoclean -y
echo "<< cleaning and removing old packages [end]"
