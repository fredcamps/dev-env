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
NVM_VERSION="v0.25.1"
NODE_VERSION="stable"
PHP_VERSION="5.6.9"
PHP_VARIANTS="+default +fpm +phpdbg"
PHP_PATH="${HOME_PATH}/.phpbrew/php/php-${PHP_VERSION}"

TIMEZONE="America/Sao_Paulo"

# utils
echo "<< installing some utilities and deps"
sudo apt-get update 2> /dev/null
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
    #terminator \
    tmux \
    firefox \
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
    re2c 2> /dev/null
echo "<< installing some utilities and deps  [end]"

# google-chrome
if [ ! -f "$(command which google-chrome)" ]; then
    echo "<< installing google chrome"
    wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | sudo apt-key add -
    sudo sh -c 'echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list'
    sudo apt-get update 2> /dev/null
    sudo apt-get install -y google-chrome-stable 2> /dev/null
    echo "<< installing google chrome [end]"
fi

# db clients
echo "<< installing db clients"
sudo apt-get install -y sqlite3 \
    postgresql-client \
    redis-tools \
    mongodb-clients 2> /dev/null
echo "<< installing db clients [end]"

# shell
if [ ! -f "$(command which zsh)" ]; then
    echo "<< installing zsh & shell tools"
    sudo apt-get install -y zsh shellcheck 2> /dev/null
    echo "<< changing shell, maybe it will ask password"
    chsh -s /bin/zsh
    /bin/zsh
    echo "<< installing zsh & shell tools [end]"
fi

# node
echo "<< installing nodejs"
source "${SHELL_PROFILE_FILE}"
if [ ! -f "$(command which nvm)" ]; then
    curl "https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh" | sh
fi
if [ ! -f "$(command which jshint)" ]; then
    nvm install "${NODE_VERSION}"
    nvm use "${NODE_VERSION}"
    curl https://npmjs.org/install.sh | sh
    npm config set python /usr/bin/python2 -g
    npm install -g jshint 2> /dev/null
fi
echo "<< installing nodejs [end]"

# python
echo "<< installing python & tools"
sudo apt-get install -y python-dev python-pip 2> /dev/null
sudo pip install --upgrade pip 2> /dev/null
sudo pip install flake8 jedi autopep8 virtualenvwrapper supervisor 2> /dev/null
if [ ! -d "${HOME_PATH}/.pyenv" ]; then
    curl -L https://raw.githubusercontent.com/yyuu/pyenv-installer/master/bin/pyenv-installer | bash
fi
pyenv update
echo "<< installing python & tools [end]"

# c/cpp
echo "<< installing clang"
sudo apt-get install -y clang uncrustify 2> /dev/null
echo "<< installing clang [end]"

#ruby
echo "<< installing ruby"
sudo apt-get install -y ruby ruby-dev rubygems-integration ruby-bundler 2> /dev/null
sudo gem install rubocop tmuxinator 2> /dev/null
echo "<< installing ruby [end]"

#go
echo "<< installing goLang"
sudo apt-get install -y golang 2> /dev/null
sudo go get -u github.com/golang/lint/golint 2> /dev/null
echo "<< installing goLang [end]"

#php
echo "<< installing php & tools"
sudo apt-get install -y php5-cli php5-dev php5-curl php5-intl 2> /dev/null
#if [ ! -d "${HOME_PATH}/.phpbrew" ]; then
#    sudo wget -O /usr/local/bin/phpbrew https://github.com/phpbrew/phpbrew/raw/master/phpbrew
#    sudo chmod +x /usr/local/bin/phpbrew
#    phpbrew init
#    phpbrew update
#    sed -i "s/BIN=$(which phpbrew)/BIN=$(command -p which phpbrew)/g" "${HOME_PATH}/.phpbrew/bashrc"
#    phpbrew install "${PHP_VERSION}" "${PHP_VARIANTS}"
#    source "${HOME_PATH}/.phpbrew/bashrc"
#    phpbrew switch "php-${PHP_VERSION}"
#    sed -i 's/^\[Date\].*//g' "${PHP_PATH}/etc/php.ini"
#    sed -i 's/^date.*//g' "${PHP_PATH}/etc/php.ini"
#    {
#        echo ""
#        echo "[Date]"
#        echo "date.timezone=\"${TIMEZONE}\""
#    } >> "${PHP_PATH}/etc/php.ini"
#    sed -i 's/^listen = 127.0.0.1:9000/listen = 127.0.0.1:9007/g' "${PHP_PATH}/etc/php-fpm.conf"
#    phpbrew fpm restart
#    sudo gpasswd -a "${USER_NAME}" www-data
#fi
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
    sudo dpkg -i /tmp/atom.deb 2> /dev/null
    sudo apt-get -y -f install 2> /dev/null
    if [ ! -f "$(which apm)" ]; then
        echo "<< [error] apm not found"
        exit 0
    fi
    apm install term2 \
    minimap \
    script \
    atom-beautify \
    autocomplete-php \
    autocomplete-plus-python-jedi \
    autocomplete-paths \
    docblockr \
    emmet \
    language-docker \
    linter \
    linter-clang \
    linter-flake8 \
    linter-jshint \
    linter-php \
    linter-phpcs \
    linter-phpmd \
    linter-ruby \
    linter-rubocop \
    linter-shellcheck \
    linter-golint \
    symbol-gen \
    language-x86asm
    echo "<< installing atom editor & plugins [end]"
fi

# docker
if [ ! -f "$(which docker)" ]; then
    echo "<< installing docker"
    sudo curl -sSL https://get.docker.com/ | sh
    sudo su -c "curl -L https://github.com/docker/compose/releases/download/${DOCKER_COMPOSE_VER}/docker-compose-${KERNEL}-${ARCH} > /usr/local/bin/docker-compose"
    sudo chmod +x /usr/local/bin/docker-compose
    sudo gpasswd -a "${USER_NAME}" docker
    echo "<< installing docker [end]"
fi

# vagrant
if [ ! -f "$(which vagrant)" ]; then
    echo "<< installing vagrant & virtualbox"
    sudo apt-get install virtualbox -y 2> /dev/null
    wget -O "/tmp/vagrant_${VAGRANT_VERSION}_${ARCH}.deb" "https://dl.bintray.com/mitchellh/vagrant/vagrant_${VAGRANT_VERSION}_${ARCH}.deb"
    sudo dpkg -i "/tmp/vagrant_${VAGRANT_VERSION}_${ARCH}.deb" 2> /dev/null || {
        sudo apt-get install -y -f 2> /dev/null
    }
    echo "<< installing vagrant & virtualbox [end]"
fi

echo "<< cleaning and removing old packages "
sudo apt-get autoremove -y 2> /dev/null
sudo apt-get autoclean -y 2> /dev/null
echo "<< cleaning and removing old packages [end]"
