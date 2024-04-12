# Dotfiles
My arch linux config dotfiles 

# Dependencies
`sudo pacman -S zsh neofetch unzip`
Install oh-my-zsh via curl `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`
Download and install Hack Nerd Font https://www.nerdfonts.com/font-downloads
  `cd ~/Downloads`
  `unzip Hack.zip`
  `mv ~/Downloads/*.ttf ~/.local/share/fonts/`
  If parrent directory dose not exist `mkdir -p ~/.local/share/fonts/`
Change shell to zsh `chsh -s /bin/zsh`
Install powerlevle 10K https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#installation
Install zsh auto-suggestions and syntax highlighting
  https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
  https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
  ```sh
    plugins=( 
        # other plugins...
        zsh-autosuggestions zsh-syntax-highlighting
    )
    ```
