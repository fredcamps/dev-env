#
# My ZSHRC
#

# [ -e "${HOME}/.zsh_aliases" ] && source "${HOME}/.zsh_aliases"
# [ -e "${HOME}/.zsh_profile" ] && source "${HOME}/.zsh_profile"
source "${HOME}/.zsh_aliases"
source "${HOME}/.zsh_profile"
source "${HOME}/.zsh_inputrc"

source "${HOME}/.zgen/zgen.zsh"

if ! zgen saved; then
    zgen oh-my-zsh
    zgen load zsh-users/zsh-syntax-highlighting
    zgen load zsh-users/zsh-history-substring-search
    zgen load zsh-users/zsh-completions src
    zgen load tarruda/zsh-autosuggestions
    zgen load chrissicool/zsh-256color
    zgen load marzocchi/zsh-notify
    zgen load voronkovich/mysql.plugin.zsh

    zgen oh-my-zsh plugins/z
    zgen oh-my-zsh plugins/urltools
    zgen oh-my-zsh plugins/redis-cli
    zgen oh-my-zsh plugins/git
    zgen oh-my-zsh plugins/gitfast
    zgen oh-my-zsh plugins/git-extras
    zgen oh-my-zsh plugins/command-not-found
    zgen oh-my-zsh plugins/celery
    zgen oh-my-zsh plugins/composer
    zgen oh-my-zsh plugins/compleat
    zgen oh-my-zsh plugins/pip
    zgen oh-my-zsh plugins/vagrant
    zgen oh-my-zsh plugins/docker
    zgen oh-my-zsh plugins/supervisor
    zgen oh-my-zsh plugins/virtualenvwrapper
    zgen oh-my-zsh plugins/fabric
    zgen oh-my-zsh plugins/tmuxinator
    zgen oh-my-zsh plugins/ssh-agent
    zgen oh-my-zsh plugins/yii
    zgen oh-my-zsh plugins/django
    zgen oh-my-zsh plugins/bundler
    zgen oh-my-zsh plugins/rake
    zgen oh-my-zsh plugins/gem
    zgen oh-my-zsh plugins/golang
    zgen oh-my-zsh plugins/colored-man
    zgen oh-my-zsh plugins/colorize
    zgen oh-my-zsh plugins/nmap
    zgen oh-my-zsh plugins/postgres
    zgen oh-my-zsh plugins/web-search
    zgen oh-my-zsh plugins/npm
    zgen oh-my-zsh plugins/catimg
    zgen oh-my-zsh plugins/themes
    zgen oh-my-zsh themes/gentoo
    zgen save
fi

# Enable autosuggestions automatically.
zle-line-init() {
    zle autosuggest-start
}
zle -N zle-line-init

source /usr/local/bin/virtualenvwrapper.sh
