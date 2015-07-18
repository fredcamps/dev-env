#!/bin/bash
#
# Author : Fred Campos fredcamps/dev-env
# Script for installing my env apps
#

USER_NAME="$(whoami)"
HOME_PATH="/home/${USER_NAME}"

SHELL_PROFILE_FILE="${HOME_PATH}/.zsh_profile"

VAGRANT_VERSION="1.7.2"
KERNEL="$(uname -s)"
ARCH="$(uname -m)"
DOCKER_COMPOSE_VER="1.2.0"
NODE_VERSION="0.12.4"
PHP_VERSION="5.6.9"
PHP_VARIANTS="+default +fpm +phpdbg"
PHP_PATH="${HOME_PATH}/.phpbrew/php/php-${PHP_VERSION}"

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
    curl \
    htop \
    iotop \
    vim \
    ttf-mscorefonts-installer \
    meld \
    libreoffice \
    tmux \
    xclip \
    subversion \
    midori \
    python-software-properties \
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
    xfce4-indicator-plugin
echo "<< installing some utilities and deps  [end]"

# vim spf-13
sh <(curl https://j.mp/spf13-vim3 -L)

# google-chrome
if [ ! -f "$(command which google-chrome)" ]; then
    echo "<< installing google chrome"
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    sudo apt-get update
    sudo apt-get install -y google-chrome-stable
    echo "<< installing google chrome [end]"
fi

# db clients
echo "<< installing db clients"
sudo apt-get install -y sqlite3 \
    postgresql-client \
    redis-tools \
    mongodb-clients \
    mysql-client
echo "<< installing db clients [end]"

# shell
if [ ! -f "$(command which zsh)" ]; then
    echo "<< installing zsh & shell tools"
    sudo apt-get install -y zsh shellcheck
    echo "<< changing shell, maybe it will ask password"
    chsh -s /bin/zsh
    /bin/zsh
    echo "<< installing zsh & shell tools [end]"
fi

# node
if [ ! -d /opt/node ] || [ ! -f "$(command which npm)" ]; then
    echo "<< installing nodejs"
    wget -O "/tmp/node-v${NODE_VERSION}-linux-x64.tar.gz" "http://nodejs.org/dist/v${NODE_VERSION}/node-v${NODE_VERSION}-linux-x64.tar.gz"
    sudo tar -zxvf "/tmp/node-v${NODE_VERSION}-linux-x64.tar.gz" -C /opt
    sudo mv "/opt/node-v${NODE_VERSION}-linux-x64" /opt/node
    sudo /opt/node/bin/npm config set python /usr/bin/python2 -g
    sudo /opt/node/bin/npm install -g jshint
    echo "<< installing nodejs [end]"
fi

# python
echo "<< installing python & tools"
sudo apt-get install -y python-dev python-pip
sudo pip install --upgrade pip
sudo pip install flake8 jedi autopep8 virtualenvwrapper supervisor
source "${SHELL_PROFILE_FILE}"
if [ ! -d "${HOME_PATH}/.pyenv" ]; then
    curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
fi
pyenv update
echo "<< installing python & tools [end]"

# c/cpp
echo "<< installing clang"
sudo apt-get install -y clang uncrustify
echo "<< installing clang [end]"

#ruby
echo "<< installing ruby"
sudo apt-get install -y ruby ruby-dev rubygems-integration
sudo gem install rubocop bundler tmuxinator
echo "<< installing ruby [end]"

#go
echo "<< installing goLang"
sudo apt-get install -y golang golang-go.tools
echo "<< installing goLang [end]"

#php
echo "<< installing php & tools"
sudo apt-get install -y php5-cli php5-dev php5-curl php5-intl
if [ ! -f /usr/local/bin/composer ]; then
    curl -sS https://getcomposer.org/installer | php
    chmod +x "${PWD}/composer.phar" ; sudo mv "${PWD}/composer.phar" /usr/local/bin/composer
fi
if [ ! -f /usr/local/bin/phpcs ]; then
    sudo wget -O /usr/local/bin/phpcs https://squizlabs.github.io/PHP_CodeSniffer/phpcs.phar
    sudo chmod +x /usr/local/bin/phpcs
fi
if [ ! -f /usr/local/bin/phpcbf ]; then
    sudo wget -O /usr/local/bin/phpcbf https://squizlabs.github.io/PHP_CodeSniffer/phpcbf.phar
    sudo chmod +x /usr/local/bin/phpcbf
fi
if [ ! -f /usr/local/bin/php-cs-fixer ]; then
    sudo wget -O /usr/local/bin/php-cs-fixer http://get.sensiolabs.org/php-cs-fixer.phar
    sudo chmod +x /usr/local/bin/php-cs-fixer
fi
if [ ! -f /usr/local/bin/phpmd ]; then
    sudo wget -O /usr/local/bin/phpmd http://static.phpmd.org/php/latest/phpmd.phar
    sudo chmod +x /usr/local/bin/phpmd
fi
if [ ! -f /usr/local/bin/phpdox ]; then
    sudo wget -O /usr/local/bin/phpdox http://phpdox.de/releases/phpdox.phar
    chmod +x /usr/local/bin/phpdox
fi
echo "<< installing php & tools [end]"

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
    apm install atom-beautify \
    autocomplete-paths \
    autocomplete-plus-python-jedi \
    autocomplete-php \
    autocomplete-phpunit \
    autocomplete-clang \
    go-plus \
    dockblockr \
    language-docker \
    linter \
    linter-jshint \
    linter-php \
    linter-phpcs \
    linter-phpmd \
    linter-shellcheck \
    linter-flake8 \
    linter-golinter \
    linter-gotype \
    linter-govet \
    linter-rubocop \
    linter-ruby \
    linter-clang \
    script \
    emmet \
    minimap \
    language-x86
    echo "<< installing atom editor & plugins [end]"
fi

# docker
if [ ! -f "$(which docker)" ]; then
    echo "<< installing docker"
    sudo curl -sSL https://get.docker.com/ | sh
    sudo su -c "curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VER}/docker-compose-${KERNEL}-${ARCH} > /usr/local/bin/docker-compose"
    sudo chmod +x /usr/local/bin/docker-compose
    sudo gpasswd -a "${USER_NAME}" docker
    sudo update-rc.d docker defaults
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

echo "<< cleaning and removing old packages "
sudo apt-get autoremove -y
sudo apt-get autoclean -y
echo "<< cleaning and removing old packages [end]"
