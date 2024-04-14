# Dotfiles
My Arch Linux .config files for Hyprland

# Install Dependencies
1. `sudo pacman -S zsh neofetch unzip waybar qt5ct qt6ct curl pcmanfm-gtk3`
2. `yay -S nwg-look visual-studio-code-bin google-chrome`

3. Install oh-my-zsh via curl `sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"`

4. Download and install Hack Nerd Font [here](https://www.nerdfonts.com/font-downloads).

    ```sh
    cd ~/Downloads
    unzip Hack.zip
    mv ~/Downloads/*.ttf ~/.local/share/fonts/
    ```

    If the parent directory does not exist:

    ```sh
    mkdir -p ~/.local/share/fonts/
    ```

5. Change shell to zsh `chsh -s /bin/zsh`

6. Install powerlevel10k [here](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#installation).

7. Install [zsh auto-suggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md) and [syntax highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md).
    ```sh
    plugins=( 
        # other plugins...
        zsh-autosuggestions zsh-syntax-highlighting
    )
    ```

# Pacman Customization

1. `nano /etc/pacman.conf`
2. In the Misc options section, uncomment `Color` and add `ILoveCandy` to the bottom of that section
