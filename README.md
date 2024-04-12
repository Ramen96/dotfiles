# Dotfiles
My arch linux .config files for hyprland

# Install dependencies
1. `sudo pacman -S zsh neofetch unzip`

2. Install oh-my-zsh via curl `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

3. Download and install Hack Nerd Font https://www.nerdfonts.com/font-downloads
   
  `cd ~/Downloads`
  
  `unzip Hack.zip`
  
  `mv ~/Downloads/*.ttf ~/.local/share/fonts/`
  
  If parrent directory dose not exist `mkdir -p ~/.local/share/fonts/`

4.Change shell to zsh `chsh -s /bin/zsh`

5.Install powerlevle 10K https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#installation

6.Install zsh auto-suggestions and syntax highlighting
  https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md
  https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md
  ```sh
    plugins=( 
        # other plugins...
        zsh-autosuggestions zsh-syntax-highlighting
    )
    ```
