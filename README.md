# Dotfiles
i3-wm

# 1) Install Dependencies
1. `sudo pacman -S zsh neofetch unzip polybar lxappearance qt5ct picom pcmanfm flatpak arc-gtk-theme rofi kitty dmenu`
2. `yay -S visual-studio-code-bin google-chrome`

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

6. Install [powerlevel10k](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#installation). [zsh auto-suggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md) and [syntax highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md).
    ```sh
    plugins=( 
        # other plugins...
        zsh-autosuggestions zsh-syntax-highlighting
    )
    ```
    ```
    ZSH_THEME="powerlevel10k/powerlevel10k"
    ```

# 2) Install config files
Copy the dirctories and files from this repo to your ~/.config file.

# 3) Pacman Customization

1. `nano /etc/pacman.conf`
2. In the Misc options section, uncomment `Color` and `ParallelDownloads`
3. Add `ILoveCandy` to the bottom of Misc options section

# 4) Dev Environment
1. Install [nodejs](https://nodejs.org/en/download/package-manager)
2. Install [anaconda](https://www.anaconda.com/)
3. Install Angular cli `npm install -g @angular/cli`
4. Install Yarn `npm install --global yarn`

# Install yay
1.
    ```
    sudo pacman -Syu
    sudo pacman -S base-devel
    ```
2. 
    ```
    sudo pacman -S git
    git clone https://aur.archlinux.org/yay.git
    ```
3.
    ```
    cd yay
    makepkg -si
    ```
