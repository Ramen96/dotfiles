# Dotfiles
My Arch Linux .config files for Hyprland

# Install Dependencies
1. `sudo pacman -S zsh neofetch unzip waybar qt5ct qt6ct curl`

2. Install oh-my-zsh via curl `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

3. Download and install Hack Nerd Font [here](https://www.nerdfonts.com/font-downloads).

    ```sh
    cd ~/Downloads
    unzip Hack.zip
    mv ~/Downloads/*.ttf ~/.local/share/fonts/
    ```

    If the parent directory does not exist:

    ```sh
    mkdir -p ~/.local/share/fonts/
    ```

4. Change shell to zsh `chsh -s /bin/zsh`

5. Install powerlevel10k [here](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#installation).

6. Install [zsh auto-suggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md) and [syntax highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md).
    ```sh
    plugins=( 
        # other plugins...
        zsh-autosuggestions zsh-syntax-highlighting
    )
    ```

# Pacman Customization

1. `nano /etc/pacman.conf`
2. In the Misc options section, uncomment `Color` and add `ILoveCandy` to the bottom of that section
