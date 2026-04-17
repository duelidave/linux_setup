#!/bin/bash
set -euo pipefail

# =============================================================================
# Setup-Script: Ubuntu nach Neuinstallation einrichten
# Voraussetzung: Ubuntu 24.04 LTS, frisch installiert, Internet vorhanden
# =============================================================================

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()  { echo -e "  ${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "  ${YELLOW}[!!]${NC} $1"; }
step()  { echo -e "\n${GREEN}=== $1 ===${NC}"; }

USER_HOME="$HOME"
BACKUP_DIR=""

# --- Backup-Pfad fragen ---
echo ""
echo "================================================"
echo " Ubuntu Setup"
echo "================================================"
echo ""
read -p "Pfad zum Backup-Ordner (z.B. /media/$USER/Bespin/ubuntu-migration-backup/2026-04-17): " BACKUP_DIR

if [ ! -d "$BACKUP_DIR" ]; then
    echo "Backup-Ordner nicht gefunden: $BACKUP_DIR"
    echo "Du kannst das Script auch ohne Backup laufen lassen (nur Pakete installieren)."
    read -p "Ohne Backup fortfahren? [j/N] " confirm
    [[ ! "$confirm" =~ ^[jJyY]$ ]] && exit 1
    BACKUP_DIR=""
fi

# ============================================================================
# TEIL 1: Pakete & Repos (braucht sudo)
# ============================================================================

step "System aktualisieren"
sudo apt update && sudo apt upgrade -y
info "System aktuell"

step "Grundpakete installieren"
sudo apt install -y \
    zsh tmux fzf htop bat curl wget git unzip \
    build-essential cmake pkg-config \
    libssl-dev libbz2-dev libreadline-dev libsqlite3-dev libffi-dev \
    liblzma-dev zlib1g-dev tk-dev \
    vlc mpv gimp inkscape libreoffice \
    keepassxc copyq terminator thunderbird \
    gnome-tweaks gnome-shell-extensions \
    flatpak gnome-software-plugin-flatpak \
    exfat-fuse ntfs-3g
info "Grundpakete"

step "Docker CE"
if ! command -v docker &>/dev/null; then
    sudo apt install -y ca-certificates gnupg
    sudo install -m 0755 -d /etc/apt/keyrings
    curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /etc/apt/keyrings/docker.gpg
    sudo chmod a+r /etc/apt/keyrings/docker.gpg
    echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.gpg] https://download.docker.com/linux/ubuntu $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
        sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
    sudo apt update
    sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
    sudo usermod -aG docker "$USER"
    info "Docker CE"
else
    info "Docker bereits installiert"
fi

step "Brave Browser"
if ! command -v brave-browser &>/dev/null; then
    sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg \
        https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
    echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg] https://brave-browser-apt-release.s3.brave.com/ stable main" | \
        sudo tee /etc/apt/sources.list.d/brave-browser-release.list > /dev/null
    sudo apt update
    sudo apt install -y brave-browser
    info "Brave Browser"
else
    info "Brave bereits installiert"
fi

step "GitHub CLI (gh)"
if ! command -v gh &>/dev/null; then
    (type -p wget >/dev/null || sudo apt install wget) \
        && sudo mkdir -p -m 755 /etc/apt/keyrings \
        && out=$(mktemp) && wget -nv -O"$out" https://cli.github.com/packages/githubcli-archive-keyring.gpg \
        && cat "$out" | sudo tee /etc/apt/keyrings/githubcli-archive-keyring.gpg > /dev/null \
        && sudo chmod go+r /etc/apt/keyrings/githubcli-archive-keyring.gpg \
        && echo "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
            sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
        && sudo apt update \
        && sudo apt install gh -y
    info "GitHub CLI"
else
    info "gh bereits installiert"
fi

step "Go (latest)"
GO_VERSION=$(curl -fsSL https://go.dev/VERSION?m=text | head -1 | sed 's/^go//')
if ! command -v /usr/local/go/bin/go &>/dev/null || ! /usr/local/go/bin/go version 2>/dev/null | grep -q "go${GO_VERSION} "; then
    echo "  Installiere Go ${GO_VERSION}..."
    sudo rm -rf /usr/local/go
    curl -fsSL "https://go.dev/dl/go${GO_VERSION}.linux-amd64.tar.gz" | sudo tar -C /usr/local -xz
    # PATH-Eintrag systemweit
    echo 'export PATH=$PATH:/usr/local/go/bin' | sudo tee /etc/profile.d/go.sh > /dev/null
    sudo chmod +x /etc/profile.d/go.sh
    info "Go ${GO_VERSION} (PATH nach Relogin aktiv, sofort: source /etc/profile.d/go.sh)"
else
    info "Go ${GO_VERSION} bereits installiert"
fi

step "Java (Temurin)"
if ! command -v java &>/dev/null; then
    sudo apt install -y wget apt-transport-https
    wget -qO - https://packages.adoptium.net/artifactory/api/gpg/key/public | \
        sudo gpg --dearmor -o /etc/apt/keyrings/adoptium.gpg
    echo "deb [signed-by=/etc/apt/keyrings/adoptium.gpg] https://packages.adoptium.net/artifactory/deb $(. /etc/os-release && echo "$VERSION_CODENAME") main" | \
        sudo tee /etc/apt/sources.list.d/adoptium.list > /dev/null
    sudo apt update
    sudo apt install -y temurin-25-jdk
    info "Java Temurin 25"
else
    info "Java bereits installiert"
fi

step "Flatpaks"
flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
flatpak install -y flathub com.discordapp.Discord || true
flatpak install -y flathub org.signal.Signal || true
flatpak install -y flathub com.spotify.Client || true
info "Flatpaks (Discord, Signal, Spotify)"

# ============================================================================
# TEIL 2: User-Tools (kein sudo)
# ============================================================================

step "zsh als Default-Shell"
if [ "$SHELL" != "/usr/bin/zsh" ]; then
    chsh -s /usr/bin/zsh
    info "zsh als Default-Shell gesetzt (wirkt nach erneutem Login)"
else
    info "zsh ist bereits Default-Shell"
fi

step "oh-my-zsh"
if [ ! -d "$USER_HOME/.oh-my-zsh" ]; then
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    info "oh-my-zsh installiert"
else
    info "oh-my-zsh bereits vorhanden"
fi

# zsh-autosuggestions Plugin
if [ ! -d "$USER_HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions" ]; then
    git clone https://github.com/zsh-users/zsh-autosuggestions "$USER_HOME/.oh-my-zsh/custom/plugins/zsh-autosuggestions"
    info "zsh-autosuggestions Plugin"
fi

step "pyenv"
if [ ! -d "$USER_HOME/.pyenv" ]; then
    curl -fsSL https://pyenv.run | bash
    export PYENV_ROOT="$USER_HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    info "pyenv installiert"
else
    export PYENV_ROOT="$USER_HOME/.pyenv"
    export PATH="$PYENV_ROOT/bin:$PATH"
    eval "$(pyenv init -)"
    info "pyenv bereits vorhanden"
fi

echo "  Python 3.10.4 installieren (dauert ein paar Minuten)..."
pyenv install -s 3.10.4
pyenv global 3.10.4
info "Python 3.10.4"

step "nvm + Node.js"
if [ ! -d "$USER_HOME/.nvm" ]; then
    curl -fsSL https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
    info "nvm installiert"
fi
export NVM_DIR="$USER_HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
nvm install node
nvm alias default node
info "Node.js (latest, via nvm)"

step "pnpm"
if ! command -v pnpm &>/dev/null; then
    curl -fsSL https://get.pnpm.io/install.sh | sh -
    info "pnpm"
else
    info "pnpm bereits installiert"
fi

step "Rust (rustup)"
if [ ! -d "$USER_HOME/.cargo" ]; then
    curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
    info "Rust/Cargo"
else
    info "Rust bereits vorhanden"
fi

step "tmux Plugin Manager (tpm)"
if [ ! -d "$USER_HOME/.tmux/plugins/tpm" ]; then
    git clone https://github.com/tmux-plugins/tpm "$USER_HOME/.tmux/plugins/tpm"
    info "tpm (nach tmux-Start: prefix + I zum Installieren der Plugins)"
else
    info "tpm bereits vorhanden"
fi

# ============================================================================
# TEIL 3: Dotfiles via linux_setup Repo
# ============================================================================

step "linux_setup Repo klonen + Symlinks"
REPO_DIR="$USER_HOME/dev/linux_setup"
if [ ! -d "$REPO_DIR" ]; then
    mkdir -p "$USER_HOME/dev"
    git clone https://github.com/duelidave/linux_setup.git "$REPO_DIR"
    info "Repo geklont (HTTPS — nach SSH-Key-Setup auf SSH remote wechseln)"
else
    info "Repo bereits vorhanden"
fi

# Symlinks setzen
ln -sf "$REPO_DIR/zsh/.zshrc" "$USER_HOME/.zshrc"
info ".zshrc → linux_setup"

ln -sf "$REPO_DIR/tmux/.tmux.conf" "$USER_HOME/.tmux.conf"
info ".tmux.conf → linux_setup"

mkdir -p "$USER_HOME/.config/nvim"
# nvim: alle Dateien/Ordner aus dem Repo verlinken
for item in "$REPO_DIR/nvim/"*; do
    name=$(basename "$item")
    ln -sf "$item" "$USER_HOME/.config/nvim/$name"
done
info "nvim config → linux_setup"

# ============================================================================
# TEIL 4: Daten aus Backup wiederherstellen
# ============================================================================

if [ -n "$BACKUP_DIR" ]; then
    step "Daten aus Backup wiederherstellen"

    # Datenordner (mit Excludes für Build-Artefakte / Caches)
    EXCLUDE_FILE="$(dirname "$0")/rsync-excludes.txt"
    RSYNC_EXCLUDE_OPT=""
    [ -f "$EXCLUDE_FILE" ] && RSYNC_EXCLUDE_OPT="--exclude-from=$EXCLUDE_FILE"
    # Ordner die NICHT kopiert werden (zu langsam via NTFS / lässt sich anders wiederherstellen)
    SKIP_FOLDERS=("dev")
    if [ -d "$BACKUP_DIR/home" ]; then
        for folder in "$BACKUP_DIR/home/"*; do
            name=$(basename "$folder")
            if [[ " ${SKIP_FOLDERS[*]} " =~ " ${name} " ]]; then
                warn "$name (übersprungen — siehe SKIP_FOLDERS)"
                continue
            fi
            rsync -a --info=progress2 $RSYNC_EXCLUDE_OPT "$folder/" "$USER_HOME/$name/"
            info "$name"
        done
    fi

    # Firefox-Profil
    if [ -d "$BACKUP_DIR/firefox" ]; then
        rsync -a "$BACKUP_DIR/firefox/" "$USER_HOME/.mozilla/"
        info "Firefox-Profil"
    fi

    # Thunderbird-Profil
    if [ -d "$BACKUP_DIR/thunderbird" ]; then
        rsync -a "$BACKUP_DIR/thunderbird/" "$USER_HOME/.thunderbird/"
        info "Thunderbird-Profil (beim ersten Start direkt einsatzbereit)"
    fi

    # SSH-Keys
    if [ -d "$BACKUP_DIR/ssh" ]; then
        mkdir -p "$USER_HOME/.ssh"
        cp -a "$BACKUP_DIR/ssh/"* "$USER_HOME/.ssh/"
        chmod 700 "$USER_HOME/.ssh"
        chmod 600 "$USER_HOME/.ssh/id_"* 2>/dev/null || true
        chmod 644 "$USER_HOME/.ssh/"*.pub 2>/dev/null || true
        chmod 600 "$USER_HOME/.ssh/config" 2>/dev/null || true
        info "SSH-Keys (alte Keys für Zugang zu Remote-Maschinen)"
    fi

    # .gitconfig
    [ -f "$BACKUP_DIR/config/.gitconfig" ] && cp -a "$BACKUP_DIR/config/.gitconfig" "$USER_HOME/" && info ".gitconfig"

    # Config-Verzeichnisse
    for dir in hcloud gh copyq terminator; do
        if [ -d "$BACKUP_DIR/config/$dir" ]; then
            mkdir -p "$USER_HOME/.config/$dir"
            cp -a "$BACKUP_DIR/config/$dir/"* "$USER_HOME/.config/$dir/" 2>/dev/null || true
            info ".config/$dir"
        fi
    done

    # Claude Code
    if [ -d "$BACKUP_DIR/claude" ]; then
        mkdir -p "$USER_HOME/.claude"
        rsync -a "$BACKUP_DIR/claude/" "$USER_HOME/.claude/"
        [ -f "$BACKUP_DIR/claude/.claude.json" ] && cp -a "$BACKUP_DIR/claude/.claude.json" "$USER_HOME/"
        info "Claude Code Config"
    fi
fi

# ============================================================================
# TEIL 5: GNOME Extensions
# ============================================================================

step "GNOME Extensions"
EXTENSIONS=(
    "dash-to-panel@jderose9.github.com"
    "blur-my-shell@aunetx"
    "Vitals@CoreCoding.com"
    "appindicatorsupport@rgcjonas.gmail.com"
    "user-theme@gnome-shell-extensions.gcampax.github.com"
    "drive-menu@gnome-shell-extensions.gcampax.github.com"
)
for ext in "${EXTENSIONS[@]}"; do
    if gnome-extensions info "$ext" &>/dev/null; then
        info "$ext (bereits vorhanden)"
    else
        # Extensions müssen über extensions.gnome.org oder manuell installiert werden
        warn "$ext → manuell über https://extensions.gnome.org installieren"
    fi
done

# ============================================================================
# Zusammenfassung
# ============================================================================

echo ""
echo "================================================"
echo -e " ${GREEN}Setup abgeschlossen!${NC}"
echo "================================================"
echo ""
echo " Noch manuell zu erledigen:"
echo ""
echo " 1. SSH-Key erstellen & deployen:"
echo "      ssh-keygen -t ed25519 -C \"david@myllers-online.de\""
echo "      ssh-copy-id nas"
echo "      ssh-copy-id mars"
echo "      (weitere Hosts: saturn, sol, hagrid, ...)"
echo "      Danach: alte Keys aus ~/.ssh/ löschen"
echo ""
echo " 2. GNOME Extensions installieren:"
echo "      https://extensions.gnome.org"
echo "      → Dash to Panel, Blur My Shell, Vitals, AppIndicator"
echo ""
echo " 3. Tools einrichten:"
echo "      gh auth login"
echo "      hcloud context activate mars"
echo ""
echo " 4. JetBrains Toolbox:"
echo "      https://www.jetbrains.com/toolbox-app/"
echo ""
echo " 5. Cursor:"
echo "      https://cursor.sh"
echo ""
echo " 6. Claude Code:"
echo "      npm install -g @anthropic-ai/claude-code"
echo ""
echo " 7. ProtonVPN:"
echo "      https://protonvpn.com/support/linux-vpn-setup/"
echo ""
echo " 8. tmux Plugins laden:"
echo "      tmux starten → prefix + I"
echo ""
echo " 9. Neu einloggen (für zsh als Default-Shell)"
echo ""
