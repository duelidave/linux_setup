#!/bin/bash
set -euo pipefail

# =============================================================================
# Backup-Script: Fedora → Ubuntu Migration
# Sichert alle wichtigen Daten auf die Bespin-Platte
# =============================================================================

BACKUP_BASE="/run/media/dmueller/Bespin/ubuntu-migration-backup"
TIMESTAMP=$(date +%Y-%m-%d)
BACKUP_DIR="${BACKUP_BASE}/${TIMESTAMP}"

GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

info()  { echo -e "  ${GREEN}[OK]${NC} $1"; }
warn()  { echo -e "  ${YELLOW}[!!]${NC} $1"; }
error() { echo -e "  ${RED}[FEHLER]${NC} $1"; exit 1; }

# --- Prüfung ---
if ! mount | grep -q "Bespin"; then
    error "Bespin ist nicht gemountet. Bitte erst mounten."
fi

mkdir -p "$BACKUP_DIR"
echo ""
echo "================================================"
echo " Backup nach: $BACKUP_DIR"
echo "================================================"

# --- 1. Datenordner ---
echo ""
echo "=== Datenordner ==="
for folder in Documents Downloads dev mars Pictures Videos fb; do
    src="$HOME/$folder"
    if [ -d "$src" ]; then
        mkdir -p "$BACKUP_DIR/home/$folder"
        rsync -a --info=progress2 "$src/" "$BACKUP_DIR/home/$folder/"
        info "$folder"
    else
        warn "$folder nicht gefunden, überspringe"
    fi
done

# --- 2. Firefox-Profil ---
echo ""
echo "=== Firefox ==="
echo "  WICHTIG: Firefox vorher schließen!"
read -p "  Firefox geschlossen? [j/N] " confirm
if [[ "$confirm" =~ ^[jJyY]$ ]]; then
    rsync -a "$HOME/.mozilla/" "$BACKUP_DIR/firefox/"
    info "Firefox-Profil"
else
    warn "Firefox übersprungen"
fi

# --- 3. Thunderbird-Profil ---
echo ""
echo "=== Thunderbird ==="
echo "  WICHTIG: Thunderbird vorher schließen!"
read -p "  Thunderbird geschlossen? [j/N] " confirm
if [[ "$confirm" =~ ^[jJyY]$ ]]; then
    rsync -a "$HOME/.thunderbird/" "$BACKUP_DIR/thunderbird/"
    info "Thunderbird-Profil"
else
    warn "Thunderbird übersprungen"
fi

# --- 4. SSH-Keys (alte Keys für Zugang zu Remote-Maschinen) ---
echo ""
echo "=== SSH ==="
mkdir -p "$BACKUP_DIR/ssh"
for f in id_ed25519 id_rsa id_rsa.pub config; do
    if [ -f "$HOME/.ssh/$f" ]; then
        cp -a "$HOME/.ssh/$f" "$BACKUP_DIR/ssh/"
        info "$f"
    fi
done

# --- 4. Configs die nicht im linux_setup Repo sind ---
echo ""
echo "=== Configs ==="
mkdir -p "$BACKUP_DIR/config"

# .gitconfig
cp -a "$HOME/.gitconfig" "$BACKUP_DIR/config/" 2>/dev/null && info ".gitconfig"

# hcloud (Hetzner CLI)
if [ -d "$HOME/.config/hcloud" ]; then
    cp -a "$HOME/.config/hcloud" "$BACKUP_DIR/config/"
    info "hcloud"
fi

# gh (GitHub CLI)
if [ -d "$HOME/.config/gh" ]; then
    cp -a "$HOME/.config/gh" "$BACKUP_DIR/config/"
    info "gh"
fi

# CopyQ
if [ -d "$HOME/.config/copyq" ]; then
    cp -a "$HOME/.config/copyq" "$BACKUP_DIR/config/"
    info "copyq"
fi

# Terminator
if [ -d "$HOME/.config/terminator" ]; then
    cp -a "$HOME/.config/terminator" "$BACKUP_DIR/config/"
    info "terminator"
fi

# --- 5. Claude Code ---
echo ""
echo "=== Claude Code ==="
if [ -d "$HOME/.claude" ]; then
    rsync -a --exclude='projects/*/tool-results' --exclude='.cache' "$HOME/.claude/" "$BACKUP_DIR/claude/"
    info ".claude/"
fi
[ -f "$HOME/.claude.json" ] && cp -a "$HOME/.claude.json" "$BACKUP_DIR/claude/" && info ".claude.json"

# --- 6. Setup-Ordner (Scripts + Plan) ---
echo ""
echo "=== Setup-Ordner ==="
rsync -a "$HOME/setup/" "$BACKUP_DIR/setup/"
info "setup/ (Scripts + PLAN.md)"

# --- 7. GNOME Settings ---
echo ""
echo "=== GNOME ==="
mkdir -p "$BACKUP_DIR/gnome"
dconf dump / > "$BACKUP_DIR/gnome/dconf-full.ini" 2>/dev/null && info "dconf Export"
gnome-extensions list --enabled > "$BACKUP_DIR/gnome/extensions-enabled.txt" 2>/dev/null && info "Extensions-Liste"

# --- Zusammenfassung ---
echo ""
echo "================================================"
TOTAL=$(du -sh "$BACKUP_DIR" | awk '{print $1}')
echo -e " Fertig! Gesamt: ${GREEN}${TOTAL}${NC}"
echo " Ort: $BACKUP_DIR"
echo "================================================"
echo ""
echo " Nächste Schritte:"
echo "   1. Ubuntu installieren (LUKS aktivieren!)"
echo "   2. Bespin mounten"
echo "   3. setup-ubuntu.sh ausführen"
