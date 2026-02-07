#!/bin/bash

# Install MesloLGS NF font (required by powerlevel10k) into Windows fonts
WIN_FONTS_DIR="$(cmd.exe /C 'echo %LOCALAPPDATA%' 2>/dev/null | tr -d '\r')/Microsoft/Windows/Fonts"
if [ -d "$WIN_FONTS_DIR" ] && [ ! -f "$WIN_FONTS_DIR/MesloLGS NF Regular.ttf" ]; then
  echo "=> Installing MesloLGS NF fonts to Windows..."
  FONT_BASE="https://github.com/romkatv/powerlevel10k-media/raw/master"
  for style in "Regular" "Bold" "Italic" "Bold Italic"; do
    file="MesloLGS NF ${style}.ttf"
    curl -fsSL -o "$WIN_FONTS_DIR/$file" "$FONT_BASE/${file// /%20}" && echo "  Installed $file" || echo "  FAILED: $file"
  done
  echo ""
  echo "  NOTE: Set your Windows Terminal font to 'MesloLGS NF'"
  echo "  Settings > Profiles > Defaults > Appearance > Font face > MesloLGS NF"
else
  echo "=> MesloLGS NF fonts already installed (or not running in WSL)"
fi
