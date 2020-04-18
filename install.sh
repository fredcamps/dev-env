#!/bin/bash
#
# Author : Fred Campos fredcamps/dev-env
# Script for installing my env apps
#
VAGRANT_VERSION="2.2.7"
NVM_VERSION="v0.35.3"
USER_NAME="$(whoami)"
DIR="$(pwd)"

sudo apt-get update
sudo apt-get install linux-lowlatency \
     linux-tools-lowlatency \
     xserver-xorg-core \
     git \
     software-properties-common \
     bison \
     autoconf \
     automake \
     build-essential \
     libssl-dev \
     htop \
     iotop \
     xclip \
     tmux \
     htop \
     iotop \
     silversearcher-ag \
     xchm \
     snapcraft \
     snapd \
     markdown \
     gimp \
     ctags \
     tree \
     libxml2-dev \
     libbz2-dev \
     libmcrypt-dev \
     libreadline-dev \
     libxslt1-dev \
     libicu-dev \
     libdbus-1-dev
echo "<< installing some utilities and deps  [end]"

# clipboard history for gnome and derivatives
sudo apt-get install -y libgpaste-dev

# autoload env vars from .envrc
sudo apt-get install -y direnv

# brave
curl -s https://brave-browser-apt-release.s3.brave.com/brave-core.asc | sudo apt-key --keyring /etc/apt/trusted.gpg.d/brave-browser-release.gpg add -
echo "deb [arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main" | sudo tee /etc/apt/sources.list.d/brave-browser-release.list
sudo apt update
sudo apt install brave-browser

# emacs
sudo add-apt-repository ppa:kelleyk/emacs && sudo apt-get update && sudo apt-get install emacs26-nox

echo "<< reloading confs"
git submodule update --init
git submodule update --recursive --remote
rsync -rv --exclude=.git "${DIR}/dotfiles/"  "${HOME}" || { exit 1; }
rsync -rv --exclude=.git "${DIR}/dotfolders/" "${HOME}" || { exit 1; }
[ -d "${HOME}/dotfolders" ] ; rm -rf "${HOME}/dotfolders"
systemctl --user enable emacsd ; systemctl --user status emacsd.service
echo "<< reloading confs [end]"

# c/cpp
echo "<< installing clang"
sudo apt-get install -y libncurses5-dev clang-7 clang-format-7 libclang-7-dev libclang1-7 global cmake llvm-dev llvm-runtime cde
sudo git clone --depth=1 --recursive https://github.com/MaskRay/ccls /opt/ccls
sudo chown "${USER_NAME}:${USER_NAME}" -R /opt/ccls
cd /opt/ccls
wget -c http://releases.llvm.org/7.0.1/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-18.04.tar.xz
tar -vxf clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-18.04.tar.xz
cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=$PWD/clang+llvm-7.0.1-x86_64-linux-gnu-ubuntu-16.04
cmake --build Release
sudo cmake --build Release --target install
cd "${DIR}"
echo "<< installing clang [end]"

# rust
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh

# java
curl -s "https://get.sdkman.io" | bash

# python
echo "<< installing python & tools"
sudo apt-get install --reinstall python3-dev python3-pip python3-setuptools python3-wheel
sudo pip3 install --upgrade virtualenvwrapper virtualfish pipenv pip
git clone git@github.com:pyenv/pyenv.git "${HOME}/.pyenv"
echo "<< installing python & tools [end]"

# golang
echo "<< installing golang"
git clone https://github.com/syndbg/goenv.git ~/.goenv
echo "<< installing golang [end]"

# javascript
if [ ! -f "$(which nvm)" ]; then
    echo "<< installing nodejs"
    mkdir -p "${HOME}/.nvm"
    wget -qO- "https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh" | bash
    source "${HOME}/.bashrc"
    nvm install "$(nvm ls-remote  | grep -i lts | tail -n 1 | awk '{ print $1 }')"
    nvm use "$(nvm ls-remote  | grep -i lts | tail -n 1 | awk '{ print $1 }')"
    npm i -g typescript-language-server
    npm i -g bash-language-server # language server for bash
    echo "<< installing nodejs [end]"
fi

# rubysha
if [ ! -f "$(which rvm)" ]; then
    echo "<< installing ruby"]
    gpg --keyserver hkp://pool.sks-keyservers.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3 7D2BAF1CF37B13E2069D6956105BD0E739499BDB
    curl -sSL https://rvm.io/mpapis.asc | gpg2 --import -
    curl https://raw.githubusercontent.com/rvm/rvm/master/binscripts/rvm-installer | bash -s stable --gems=bundler
    source "${HOME}/.rvm/scripts/rvm" && rvm use
    echo "<< installing ruby [end]"
fi

# shell
sudo apt-get install shellcheck

# if [ ! -f "$(which zsh)" ]; then
#    echo "<< installing zsh"
#    sudo apt-get install -y zsh
#    echo "<< installing zsh [end]"
# fi

# fish shell
if [ ! -f "$(which fish)" ]; then
    echo "<< installing fish"
    sudo apt-get install -y fish
    curl -L https://get.oh-my.fish | fish
    fish -c 'omf install cbjohnson'
    fish -c 'omf install colored-man-pages'
    fish -c 'omf install grc'
    fish -c 'omf install license'
    fish -c 'omf install notify'
    fish -c 'omf install nvm'
    fish -c 'omf install pyenv'
    fish -c 'omf install sdk'
    fish -c 'omf install sudope'
    fish -c 'omf install z'
    curl -L --create-dirs -o ~/.config/fish/functions/rvm.fish https://raw.github.com/lunks/fish-nuggets/master/functions/rvm.fish
    echo "rvm default" >> ~/.config/fish/conf.d/rvm.fish
    wget https://gitlab.com/kyb/fish_ssh_agent/raw/master/functions/fish_ssh_agent.fish -P ~/.config/fish/functions/
    curl https://git.io/fisher --create-dirs -sLo ~/.config/fish/functions/fisher.fish
    curl -L --create-dirs -o ~/.config/fish/completions/nvm.fish https://raw.githubusercontent.com/FabioAntunes/fish-nvm/master/completions/nvm.fish
    # curl -L --create-dirs -o ~/.config/fish/completions/rvm.fish https://
    fish -c 'fisher add franciscolourenco/done'
    fish -c 'fisher add edc/bass'
    wget http://kassiopeia.juls.savba.sk/~garabik/software/grc/grc_1.11.3-1_all.deb && sudo dpkg -i grc_1.11.3-1_all.deb && rm -rf grc_1.11.3-1_all.deb
    echo "<< installing fish [end]"
fi

# docker
if [ ! -f "$(which docker)" ]; then
    echo "<< installing docker"
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
    sudo su -c "echo \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(. /etc/os-release; echo $UBUNTU_CODENAME) stable\" > \
               /etc/apt/sources.list.d/docker-releases.list"
    # sudo su -c "echo \"deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable\" > \
    #          /etc/apt/sources.list.d/docker-releases.list"
    sudo apt-get update ; sudo apt-get install docker-ce ;
    sudo gpasswd -a "${USER_NAME}" docker
    sudo pip3 install docker-compose
    echo "<< installing docker [end]"
fi

# vagrant
if [ ! -f "$(which vagrant)" ]; then
    echo "<< installing vagrant"
    sudo apt-get install -y \
     virtualbox virtualbox-ext-pack virtualbox-dkms virtualbox-guest-x11 virtualbox-guest-source virtualbox-guest-utils virtualbox-qt
    wget "https://releases.hashicorp.com/vagrant/${VAGRANT_VERSION}/vagrant_${VAGRANT_VERSION}_$(uname -p).deb" && \
    sudo dpkg -i "vagrant_${VAGRANT_VERSION}_$(uname -p).deb" && rm -rf "vagrant_${VAGRANT_VERSION}_$(uname -p).deb"
    echo "<< installing vagrant [end]"
fi

#keylock indicator
sudo add-apt-repository ppa:tsbarnes/indicator-keylock
sudo apt-get install -y indicator-keylock

echo "<< cleaning and removing old packages "
sudo apt-get autoremove -y
sudo apt-get autoclean -y
echo "<< cleaning and removing old packages [end]"
