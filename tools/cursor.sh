#!/bin/bash

set -e

echo "🚀 Instalando Cursor via AppImage..."

# Define variáveis
APP_DIR="$HOME/Applications"
APPIMAGE_NAME="cursor.AppImage"
DESKTOP_FILE="$HOME/.local/share/applications/cursor.desktop"
ICON_PATH="$HOME/.local/share/icons/cursor-icon.svg"

# Cria pasta Applications
mkdir -p "$APP_DIR"

echo "📥 Baixando Cursor AppImage..."
echo "💡 Se você ainda não tem o AppImage, baixe de: https://cursor.com"
echo ""

# Step 1: Find the latest version of the .AppImage
LATEST_APPIMAGE=$(ls -t $HOME/Applications/cursor-*.AppImage 2>/dev/null | head -n 1)

if [ -z "$LATEST_APPIMAGE" ]; then
    echo "❌ Nenhum Cursor AppImage encontrado em $HOME/Applications/"
    echo "📥 Por favor, baixe o AppImage de https://cursor.com"
    echo "💡 Ou use: sudo snap install cursor"
    echo ""
    echo "🔧 Alternativas de instalação:"
    echo "   1. Snap: sudo snap install cursor"
    echo "   2. Flatpak: flatpak install flathub com.cursor.Cursor"
    echo "   3. Manual: Baixe de https://cursor.com"
    exit 1
fi

echo "✅ AppImage encontrado: $LATEST_APPIMAGE"

# Step 2: Update symlink to the latest version
SYMLINK_PATH="$HOME/Applications/$APPIMAGE_NAME"
ln -sf "$LATEST_APPIMAGE" "$SYMLINK_PATH"
echo "🔗 Symlink atualizado para: $SYMLINK_PATH"

# Step 3: Download the Cursor logo if not exists
if [ ! -f "$ICON_PATH" ]; then
    echo "🎨 Baixando ícone do Cursor..."
    mkdir -p "$(dirname "$ICON_PATH")"
    curl -o "$ICON_PATH" "https://www.cursor.so/brand/icon.svg"
    echo "✅ Ícone baixado para: $ICON_PATH"
else
    echo "✅ Ícone já existe: $ICON_PATH"
fi

# Step 4: Create or update the .desktop file
echo "📝 Criando/atualizando arquivo .desktop..."
mkdir -p "$(dirname "$DESKTOP_FILE")"

cat > "$DESKTOP_FILE" <<EOL
[Desktop Entry]
Name=Cursor
Exec=$SYMLINK_PATH
Terminal=false
Type=Application
Icon=$ICON_PATH
StartupWMClass=Cursor
X-AppImage-Version=latest
Comment=Cursor is an AI-first coding environment.
MimeType=x-scheme-handler/cursor;
Categories=Utility;Development
EOL

chmod +x "$DESKTOP_FILE"

# Atualiza cache
update-desktop-database ~/.local/share/applications &>/dev/null || true

echo "✅ Cursor instalado com sucesso!"
echo "🔧 Você pode rodar via: $SYMLINK_PATH"
echo "🎯 O Cursor agora aparece no menu de aplicações"
