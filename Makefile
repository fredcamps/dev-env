setup:
		./setup.sh
load:
		@test -e $(command which git) || sudo apt-get install git -y 2> /dev/null ;
		@git submodule update --init && gitsubmodule update
		@cp -R .atom ~/
		@cp -R .fonts ~/
		@cp -R .ssh ~/
		@cp -R .zgen ~/
		@cp -R .vim ~/
		@cp  .vimrc ~/.vimrc
		@cp  .gitconfig ~/.gitconfig
		@cp  .zsh_profile ~/.zsh_profile
		@cp  .zsh_aliases ~/.zsh_aliases
		@cp  .zshrc ~/.zshrc
		@vim +NeoBundleInstall +qall

save:
		@cp  ~/.atom/config.cson .atom/config.cson
		@cp  ~/.atom/keymap.cson .atom/keymap.cson
		@cp -R ~/.fonts/* .fonts
		@cp -R ~/.ssh/config .ssh
		@cp -R ~/.zgen/* .zgen
		@cp -R ~/.vim/* .vim
		@cp  ~/.vimrc .vimrc
		@cp  ~/.gitconfig .gitconfig
		@cp  ~/.zsh_profile .zsh_profile
		@cp  ~/.zsh_aliases .zsh_aliases
		@cp  ~/.zshrc .zshrc
		@vim +NeoBundleInstall +qall
