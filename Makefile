install:
		./setup.sh
		@mkdir -p .vim/bundle
		@git submodule update --init
		@cp .gitconfig ~/.gitconfig
		@cp .atom/config.cson ~/.atom/config.cson
		@cp .atom/keymap.cson ~/.atom/keymap.cson
		@cp -r .config/* ~/.config
		@cp -r .fonts/* ~/.fonts
		@cp -r .ssh/* ~/.ssh
		@cp -r .vim/* ~/.vim
		@cp .vimrc ~/.vimrc
		@vim +NeoBundleInstall +qall

self-update:
		@cp ~/.gitconfig .gitconfig
		@cp ~/.atom/config.cson .atom/config.cson
		@cp ~/.atom/keymap.cson .atom/keymap.cson
		@cp -r ~/.config/terminator .config
		@cp -r ~/.fonts/* .fonts
		@cp -r ~/.ssh/config .ssh
		@cp -r ~/.vim/* .vim
		@cp ~/.vimrc .vimrc
