# Dotfiles  

## 1) Packages  

1. **Pacman**  
   ```sh
   sudo pacman -S zsh fastfetch dosfstools dysk man-db man-pages wl-clipboard swaync rofi-wayland htop nerd-fonts unzip waybar libsecret qt5-wayland qt6-wayland celluloid gnome-keyring libgnome-keyring vim nwg-look hyprland hyprpaper hypridle hyprlock kvantum nerd-fonts steam gamescope discord libreoffice-still nautilus wlsunset adwaita-icon-theme gnome-themes-extra wofi kitty ghostty acpi imagemagick ghostscript tectonic
   ```  

2. **AUR (yay)**  
   ```sh
   yay -S visual-studio-code-bin brave-bin rog-control-center sddm-theme-tokyo-night-git
   ```  

3. **Flatpaks**  
   - postman  
   - pgadmin4  

4. **Oh-My-Zsh**  
   ```sh
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```  

5. **Fonts**  
Download and install Hack Nerd Font [here](https://www.nerdfonts.com/font-downloads).  
   ```sh
   cd ~/Downloads
   unzip Hack.zip
   mv ~/Downloads/*.ttf ~/.local/share/fonts/
   ```  
   If the parent directory does not exist:  
   ```sh
   mkdir -p ~/.local/share/fonts/
   ```  

6. **Shell**  
   ```sh
   chsh -s /bin/zsh
   ```  

7. **Zsh Plugins**  
   - [powerlevel10k](https://github.com/romkatv/powerlevel10k?tab=readme-ov-file#installation)  
   - [zsh-autosuggestions](https://github.com/zsh-users/zsh-autosuggestions/blob/master/INSTALL.md)  
   - [zsh-syntax-highlighting](https://github.com/zsh-users/zsh-syntax-highlighting/blob/master/INSTALL.md)  

   ```sh
   plugins=( 
   # other plugins...
   zsh-autosuggestions zsh-syntax-highlighting
   )
   ZSH_THEME="powerlevel10k/powerlevel10k"
   ```  

---

## 2) Pacman Customization  
1. `nano /etc/pacman.conf`  
2. In the Misc options section, uncomment `Color` and `ParallelDownloads`  
3. Add `ILoveCandy` to the bottom of Misc options section  

---

## 3) Dev Environment  
- node (installed manually from [Node.js website](https://nodejs.org/))  
- npm global packages:  
  ```sh
  npm install -g neovim @mermaid-js/mermaid-cli
  ```  
- Python pip packages:  
  ```sh
  pip install pynvim
  ```  

---

## 4) Install yay  
```sh
sudo pacman -Syu
sudo pacman -S git base-devel
git clone https://aur.archlinux.org/yay.git
cd yay
makepkg -si
cd ..
rm -rf yay
```  

---

## Kvantum Themes  
[WhiteSur Kvantum](https://store.kde.org/p/1398841)  

