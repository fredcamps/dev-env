#!/bin/bash
#
# Author : Fred Campos fredcamps/dev-env
# Script for installing my env apps
#
VENDOR="$(lsb_release -i | awk '{print $3}' | awk '{print tolower($0)}')"
CODENAME="$(lsb_release -cs)"
# DISTRO="${VENDOR}-${CODENAME}"
USER_NAME="$(whoami)"
# HOME_PATH="/home/${USER_NAME}"
# CURL_VERSION="7.58.0"
# TIMEZONE="America/Sao_Paulo"
DIR="$(pwd)"

NVM_VERSION="v0.34.0"

# utils
echo "<< installing some utilities and deps"
sudo apt-get update
sudo apt-get install -y -q aufs-tools \
    bison \
    autoconf \
    automake \
    build-essential \
    libssl-dev \
    git \
    git-flow \
    htop \
    iotop \
    vim \
    libreoffice \
    tmux \
    tmuxinator \
    fonts-powerline \
    powerline \
    xclip \
    subversion \
    python-dev \
    ctags \
    tree \
    curl \
    "linux-headers-$(uname -r)" \
    libdbus-1-dev \
    libnotify-dev \
    libvirt-dev \
    libvirt-bin \
    libxml2-dev \
    libbz2-dev \
    libmcrypt-dev \
    libreadline-dev \
    libxslt1-dev \
    libicu-dev \
    re2c \
    nfs-client \
    cups \
    libsmbclient \
    xfce4-whiskermenu-plugin \
    xfce4-indicator-plugin \
    xfce4-goodies \
    libmysqlclient-dev \
    flashplugin-installer \
    xchm \
    wget \
    silversearcher-ag \
    markdown \
    playonlinux \
    dosbox \
    snapcraft \
    screen \
    chromium-browser \
    gimp \
    direnv \
    gnupg2
echo "<< installing some utilities and deps	 [end]"

# firefox
# sudo add-apt-repository ppa:mozillateam/ppa
# sudo apt-get update && apt-get install -y -q firefox-esr

# emacs
sudo add-apt-repository ppa:kelleyk/emacs && apt-get update && apt-get install emacs26-nox

# dot files
echo "<< reloading confs"
git submodule update --init
rsync -rv --exclude=.git "${DIR}/dotfiles/"  "${HOME}" || { exit 1; }
rsync -rv --exclude=.git "${DIR}/dotfolders/" "${HOME}" || { exit 1; }
[ -d "${HOME}/dotfolders" ] && rm -rf "${HOME}/dotfolders"
systemctl --user start emacsd
echo "<< reloading confs [end]"

# c/cpp
echo "<< installing clang"
sudo apt-get install -y libncurses5-dev clang-7 clang-format-7 libclang-7-dev libclang1-7 global cmake llvm-dev llvm-runtime cde
sudo git clone --depth=1 --recursive https://github.com/MaskRay/ccls /opt/ccls
sudo chown $(whoami):$(whoami) -R /opt/ccls
cd /opt/ccls
wget -c http://releases.llvm.org/7.0.1/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-18.04.tar.xz
tar -vxf clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-18.04.tar.xz
cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$PWD/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04
cmake --build Release
sudo cmake --build Release --target install
cd "${DIR}"
echo "<< installing clang [end]"

# curl
# echo "<< installing curl"
# sudo apt-get build-dep -y curl
# git clone https://github.com/tatsuhiro-t/nghttp2.git "${HOME}/Downloads/nghttp2" || echo "nghttp is already cloned";
# cd "${HOME}/Downloads/nghttp2" || exit 1;
# if [ -f "$(which curl)" ]; then
#     rm -rf "$(which curl)"
#     sudo apt-get purge -y curl
# fi
# autoreconf -i && automake && autoconf && ./configure && make && sudo make install
# cd "${HOME}/Downloads" || exit 1;
# wget "http://curl.haxx.se/download/curl-${CURL_VERSION}.tar.bz2" && tar -jxvf "curl-${CURL_VERSION}.tar.bz2"
# cd "curl-${CURL_VERSION}" && ./configure --with-nghttp2=/usr/local --with-ssl && make && sudo make install
# sudo ldconfig
# sudo rm -rf "${HOME}/Downloads/nghttp2" "${HOME}/Downloads/curl-${CURL_VERSION}"
# if [ ! -f "$(which curl)" ]; then
# 	echo "<< ERROR when install curl" && exit 1;
# fi
# cd "${DIR}"
# echo "<< installing curl [end]"

# vim spf-13
# sh <(curl https://j.mp/spf13-vim3 -L)

# shell
sudo apt-get install shellcheck
# if [ ! -f "$(which zsh)" ]; then
#    echo "<< installing zsh"
#    sudo apt-get install -y zsh
#    echo "<< changing shell, maybe it will ask password"
#    chsh -s /bin/zsh
#   echo "<< installing zsh [end]"
# fi
if [ ! -f "$(which fish)" ]; then
    echo "<< installing fish"
    sudo apt-get install -y fish
    echo "<< changing shell, maybe it will ask password"
    chsh -s /usr/bin/fish
    curl -L https://get.oh-my.fish | fish
    omf install cbjohnson
    omf install colored-man-pages
    omf install grc
    omf install notify
    omf install nvm
    omf install pyenv
    omf install rvm
    omf install sdk
    omf install z
    wget https://gitlab.com/kyb/fish_ssh_agent/raw/master/functions/fish_ssh_agent.fish -P ~/.config/fish/functions/
    curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
    fisher add franciscolourenco/done
    wget http://kassiopeia.juls.savba.sk/~garabik/software/grc/grc_1.11.3-1_all.deb ; sudo dpkg -i grc_1.11.3-1_all.deb
    echo "<< installing fish [end]"
fi

# http://python-3-patterns-idioms-test.readthedocs.io/en/latest/index.html
# python
echo "<< installing python & tools"
sudo apt-get install -y python-pip
sudo pip install --upgrade pip
sudo pip install virtualenvwrapper pipenv
git clone git@github.com:pyenv/pyenv.git "${HOME}/.pyenv"
echo "<< installing python & tools [end]"

# golang
echo "<< installing golang"
git clone https://github.com/syndbg/goenv.git ~/.goenv
echo "<< installing golang [end]"

# markdown
sudo apt-get install -y libmarkdown2-dev libmarkdown2 markdown

# node
if [ ! -f "$(which nvm)" ]; then
    echo "<< installing nodejs"
    mkdir -p "${HOME}/.nvm"
    wget -qO- "https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh" | bash
    nvm install v11.9.0
    nvm use 11.9.0
    npm i -g typescript-language-server
    npm i -g bash-language-server # language server for bash
    echo "<< installing nodejs [end]"
fi

# rubysha
if [ ! -f "$(which rvm)" ]; then
    echo "<< installing ruby"]
    gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
	curl https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer | bash -s stable --ruby=2.4.1 --gems=bundler,jekyll
    echo "<< installing ruby [end]"
fi

# java
curl -s "https://get.sdkman.io" | bash

# docker
if [ ! -f "$(which docker)" ]; then
    echo "<< installing docker"
    curl -fsSL https://download.docker.com/linux/${VENDOR}/gpg | sudo apt-key add -
    sudo add-apt-repository \
            "deb [arch=amd64] https://download.docker.com/linux/${VENDOR} ${CODENAME} stable"
    sudo apt-get update ; sudo apt-get install docker-ce ; sudo pip install docker-compose
    sudo gpasswd -a "${USER_NAME}" docker
    echo "<< installing docker [end]"
fi

# vagrant
if [ ! -f /opt/vagrant/bin/vagrant ]; then
    echo "<< installing vagrant"
    wget -q -O - http://download.virtualbox.org/virtualbox/debian/oracle_vbox_2016.asc | sudo apt-key add -
    sudo sh -c 'echo "deb http://download.virtualbox.org/virtualbox/debian disco non-free contrib" >> /etc/apt/sources.list.d/virtualbox.org.list' 
    sudo git clone https://github.com/mitchellh/vagrant.git /opt/vagrant/
    sudo chown -R $(whoami):$(whoami) /opt/vagrant
    cd /opt/vagrant ; bundle install ; cd "${DIR}"
    sudo ln -sf /opt/vagrant/bin/vagrant /usr/local/bin/vagrant
    echo "<< installing vagrant [end]"
fi

#keylock indicator
sudo add-apt-repository ppa:tsbarnes/indicator-keylock
sudo apt-get install -y indicator-keylock

echo "<< cleaning and removing old packages "
sudo apt-get autoremove -y
sudo apt-get autoclean -y
echo "<< cleaning and removing old packages [end]"
