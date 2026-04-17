# Migration Fedora → Ubuntu

## Überblick

Fedora 43 auf einer 931G NVMe-SSD (LUKS + LVM) wird durch Ubuntu 24.04 LTS ersetzt.
Alle wichtigen Daten werden auf die externe Bespin-Platte (1,8 TB NTFS) gesichert.
Dotfiles (zsh, tmux, nvim) liegen im Git-Repo `duelidave/linux_setup` und werden per Symlinks eingerichtet.

## Aktuelles Setup (Stand: 2026-04-17)

### System
- Desktop: GNOME (Dark Mode, Ant-Nebula Theme)
- Shell: zsh + oh-my-zsh (half-life Theme), Plugins: git, sudo, pyenv, zsh-autosuggestions
- Terminal: Terminator
- Editor: Neovim (Haupteditor), Cursor, JetBrains Toolbox (IntelliJ, RustRover)
- Keyboard: de + us Layout

### Sprachen & Versionen
- Python 3.10.4 via pyenv (auch 3.9.13 installiert)
- Node.js via nvm (v15, v18, v20, v21, v22), Default: latest
- Rust 1.92.0 via rustup, Cargo-Tools: trunk, tarpaulin
- Go 1.25.9
- Java: OpenJDK 25 (Temurin)
- pnpm als zusätzlicher Paketmanager

### Pakete & Apps
- APT-Äquivalente: zsh, tmux, fzf, htop, bat, curl, wget, git, build-essential, docker-ce, gh, vlc, mpv, gimp, inkscape, libreoffice, keepassxc, copyq, terminator, thunderbird, gnome-tweaks
- Flatpaks: Discord, Signal, Spotify
- Manuell: Brave Browser, JetBrains Toolbox, Cursor, Claude Code, ProtonVPN

### GNOME Extensions (enabled)
- dash-to-panel@jderose9.github.com
- blur-my-shell@aunetx
- Vitals@CoreCoding.com
- appindicatorsupport@rgcjonas.gmail.com
- user-theme@gnome-shell-extensions.gcampax.github.com
- drive-menu@gnome-shell-extensions.gcampax.github.com

### Favoriten-Leiste
Firefox, Thunderbird, KeePassXC, Nemo (Dateimanager), Terminator

### Wichtige Remote-Hosts (SSH)
- `nas` — NAS im lokalen Netz
- `mars` / `newmars` — Hetzner Cloud Instanz (hcloud Context: mars)
- `saturn`, `sol`, `hagrid` — weitere Maschinen
- `mail.myllers-online.de` — Mailserver
- `h2781264.stratoserver.net` — Strato Server

### Dotfiles-Repo
- GitHub: https://github.com/duelidave/linux_setup (Clone via HTTPS, nach SSH-Setup auf SSH remote wechseln)
- Enthält: zsh/.zshrc, tmux/.tmux.conf, nvim/ (komplette Config)
- Setup via Symlinks (siehe README im Repo)

## Ablauf

### Schritt 1: Backup auf Fedora
```bash
cd ~/setup
./backup.sh
```
Sichert auf `/run/media/dmueller/Bespin/ubuntu-migration-backup/DATUM/`:
- Datenordner: Documents, Downloads, dev, mars, Pictures, Videos, fb (~60 GB)
- Firefox-Profil (~776 MB)
- Thunderbird-Profil (~8,2 GB) — wird automatisch wiederhergestellt, sofort einsatzbereit
- SSH-Keys (alte, für Zugang zu Remote-Maschinen)
- Configs: .gitconfig, hcloud, gh, copyq, terminator
- Claude Code Config
- GNOME dconf-Export
- Diesen setup/ Ordner (Scripts + Plan)

### Schritt 2: Ubuntu installieren
- Ubuntu 24.04 LTS auf NVMe-SSD
- LUKS-Verschlüsselung aktivieren
- Minimale Installation

### Schritt 3: Setup auf Ubuntu
```bash
# Bespin mounten, Setup-Ordner kopieren
cp -r /media/$USER/Bespin/ubuntu-migration-backup/DATUM/setup ~/setup
cd ~/setup
./setup-ubuntu.sh
```
Das Script macht:
1. APT-Pakete + Repos (Docker, Brave, gh, Go, Java Temurin)
2. Flatpaks (Discord, Signal, Spotify)
3. zsh + oh-my-zsh + zsh-autosuggestions
4. pyenv + Python 3.10.4, nvm + Node LTS, rustup, pnpm
5. tmux Plugin Manager (tpm)
6. Klont linux_setup Repo → Symlinks für .zshrc, .tmux.conf, nvim
7. Stellt Daten aus Backup wieder her (Ordner, Firefox, SSH, Configs, Claude)

### Schritt 4: Manuell nacharbeiten
- [ ] Neuen SSH-Key erstellen: `ssh-keygen -t ed25519 -C "david@myllers-online.de"`
- [ ] Alten Key nutzen um neuen auf Remote-Maschinen zu deployen:
  - `ssh-copy-id nas`
  - `ssh-copy-id mars`
  - `ssh-copy-id saturn` / `sol` / `hagrid` / etc.
  - Danach alte Keys löschen
- [ ] linux_setup Repo auf SSH remote umstellen: `cd ~/dev/linux_setup && git remote set-url origin git@github.com:duelidave/linux_setup.git`
- [ ] GNOME Extensions über https://extensions.gnome.org installieren
- [ ] `gh auth login`
- [ ] `hcloud context activate mars`
- [ ] JetBrains Toolbox installieren (https://www.jetbrains.com/toolbox-app/)
- [ ] Cursor installieren (https://cursor.sh)
- [ ] Claude Code: `npm install -g @anthropic-ai/claude-code`
- [ ] ProtonVPN einrichten
- [ ] tmux starten → `prefix + I` für Plugin-Installation
- [ ] Seafile-Client einrichten
- [ ] Neu einloggen (für zsh als Default-Shell)
