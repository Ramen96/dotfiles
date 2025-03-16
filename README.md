# Dotfiles

# 1) Packages
1. ```
   sudo pacman -S zsh fastfetch dosfstools htop unzip waybar libsecret qt5-wayland qt6-wayland gnome-keyring libgnome-keyring vim nwg-look hyprland hyprpaper hypridle hyprlock kvantum nerd-fonts steam gamescope discord libreoffice-still dolphin wofi kitty ghostty acpi
   ```
2. ```
   yay -S visual-studio-code-bin brave-bin rog-control-center sddm-theme-tokyo-night-git
   ```
3. `flatpaks postman pgadmin4`

4. Install oh-my-zsh via curl
   ```
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```

6. Download and install Hack Nerd Font [here](https://www.nerdfonts.com/font-downloads).

    ```sh
    cd ~/Downloads
    unzip Hack.zip
    mv ~/Downloads/*.ttf ~/.local/share/fonts/
    ```

    If the parent directory does not exist:

    ```sh
    mkdir -p ~/.local/share/fonts/
    ```

7. Change shell to zsh `chsh -s /bin/zsh`

8. Install [powerlevel10k](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#installation). [zsh auto-suggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md) and [syntax highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md).
    ```sh
    plugins=( 
        # other plugins...
        zsh-autosuggestions zsh-syntax-highlighting
    )
    ```
    ```
    ZSH_THEME="powerlevel10k/powerlevel10k"
    ```

# 2) Pacman Customization

1. `nano /etc/pacman.conf`
2. In the Misc options section, uncomment `Color` and `ParallelDownloads`
3. Add `ILoveCandy` to the bottom of Misc options section

# 3) Dev Environment
1. node

# Install yay
1.
    ```
    sudo pacman -Syu
    sudo pacman -S git base-devel
    sudo pacman -S git
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si
    cd ..
    rm -rf yay
    ```
# Kvantum Themes
[WhiteSur Kvantum](https://store.kde.org/p/1398841)
