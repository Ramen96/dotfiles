# Dotfiles  

## 1) Packages  

1. **Pacman**  
   ```sh
   sudo pacman -S zsh fastfetch dosfstools dysk man-db man-pages wl-clipboard htop nerd-fonts unzip libsecret celluloid vim nerd-fonts steam gamescope discord libreoffice-still ghostty acpi imagemagick ghostscript tectonic power-profiles-daemon noto-fonts gnome-tweaks gnome-shell-extensions extension-manager
   ```  

2. **AUR (yay)**  
   ```sh
   yay -S visual-studio-code-bin brave-bin gnome-shell-extension-pop-shell
   ```  

3. **Flatpaks**  
   - postman  
   - pgadmin4  

4. **Oh-My-Zsh**  
   ```sh
   sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
   ```  

5. **Shell**  
   ```sh
   chsh -s /bin/zsh
   ```  

6. **Zsh Plugins**  
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