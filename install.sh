#!/bin/bash
#
# Author : Fred Campos fredcamps/dev-env
# Script for installing my env apps
#
VENDOR="$(lsb_release -i | awk '{print $2}' | awk '{print tolower($0)}')"
CODENAME="$(lsb_release -cs)"
# DISTRO="${VENDOR}-${CODENAME}"
USER_NAME="$(whoami)"
# HOME_PATH="/home/${USER_NAME}"
CURL_VERSION="7.51.0"
# TIMEZONE="America/Sao_Paulo"
DIR="$(pwd)"

# utils
echo "<< installing some utilities and deps"
sudo apt-get update
sudo apt-get install -y aptitude	\
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
		chromium \
		flashplugin-installer \
		xchm \
		wget \
		silversearcher-ag \
		markdown \
		software-properties-common \
		playonlinux \
		dosbox
echo "<< installing some utilities and deps	 [end]"

# dot files
echo "<< reloading confs"
git submodule update --init
echo "<< reloading confs [end]"

# curl
echo "<< installing curl"
sudo apt-get build-dep -y curl
git clone https://github.com/tatsuhiro-t/nghttp2.git ~/Downloads || exit 1
cd "${HOME}/Downloads/nghttp2" || exit 1
autoreconf -i && automake && autoconf && ./configure && make && sudo make install
cd ~/Downloads || exit 1;
wget http://curl.haxx.se/download/curl-${CURL_VERSION}.tar.bz2 && tar -jxvf curl-${CURL_VERSION}.tar.bz2
cd curl-${CURL_VERSION} && ./configure --with-nghttp2=/usr/local --with-ssl && make && sudo make install
sudo ldconfig
sudo rm -rf ~/Downloads/nghttp2 ~/Downloads/curl-${CURL_VERSION}
which curl || { echo "<< ERROR when install curl" && exit 1; }
echo "<< installing curl [end]"

# vim spf-13
sh <(curl https://j.mp/spf13-vim3 -L)

# shell
sudo apt-get install shellcheck
if [ ! -f "$(which zsh)" ]; then
		echo "<< installing zsh"
		sudo apt-get install -y zsh
		echo "<< changing shell, maybe it will ask password"
		chsh -s /bin/zsh
		echo "<< installing zsh [end]"
fi

# http://python-3-patterns-idioms-test.readthedocs.io/en/latest/index.html
# python
echo "<< installing python & tools"
sudo apt-get install -y python-pip
pip install --upgrade pip
pip install virtualenvwrapper
echo "<< installing python & tools [end]"

# c/cpp
echo "<< installing clang"
sudo apt-get install -y clang clang-format libclang-dev libclang1 global cmake llvm-dev llvm-runtime
echo "<< installing clang [end]"

# golang
echo "<< installing golang"
sudo apt install golang
echo "<< installing golang [end]"

# node
if [ ! -f "$(which nvm)" ]; then
	 echo "<< installing nodejs"
	 wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.2/install.sh | bash
	 echo "<< installing nodejs [end]"
fi

# rubysha
if [ ! -f "$(which rvm)" ]; then
	 echo "<< installing ruby"
	 gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
	 curl https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer | bash -s stable --ruby=2.4.1 --gems=bundler,jekyll
	 echo "<< installing ruby [end]"
fi

# docker
if [ ! -f "$(which docker)" ]; then
		echo "<< installing docker"
		curl -fsSL https://download.docker.com/linux/${VENDOR}/gpg | sudo apt-key add -
		sudo add-apt-repository \
				"deb [arch=amd64] https://download.docker.com/linux/${VENDOR} ${CODENAME} stable"
		sudo apt-get update && sudo apt-get install docker-ce && pip install docker-compose
		sudo gpasswd -a "${USER_NAME}" docker
		echo "<< installing docker [end]"
fi

# vagrant
if [ ! -f /opt/vagrant/bin/vagrant ]; then
		echo "<< installing vagrant"
		sudo git clone https://github.com/mitchellh/vagrant.git /opt/vagrant/
		{ cd /opt/vagrant || exit 1; } && bundle install && { cd "${DIR}" || exit 1; }
		sudo ln -sf /opt/vagrant/bin/vagrant /usr/local/bin/vagrant
		echo "<< installing vagrant [end]"
fi

echo "<< cleaning and removing old packages "
sudo apt-get autoremove -y
sudo apt-get autoclean -y
echo "<< cleaning and removing old packages [end]"
