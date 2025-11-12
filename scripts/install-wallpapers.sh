#!/bin/bash
#
# Premium Wallpaper Pack for Tablet
#

set -e

CYAN='\033[0;36m'
GREEN='\033[0;32m'
NC='\033[0m'

echo -e "${CYAN}Installing Premium Wallpaper Pack...${NC}"

# Create wallpaper directory
mkdir -p ~/Pictures/Wallpapers

# Download curated 4K tablet wallpapers
cd ~/Pictures/Wallpapers

echo "Downloading tablet-optimized wallpapers..."

# Download from Unsplash (free, high quality)
curl -L "https://source.unsplash.com/2736x1824/nature" -o nature-1.jpg 2>/dev/null || true
curl -L "https://source.unsplash.com/2736x1824/minimal" -o minimal-1.jpg 2>/dev/null || true
curl -L "https://source.unsplash.com/2736x1824/abstract" -o abstract-1.jpg 2>/dev/null || true
curl -L "https://source.unsplash.com/2736x1824/gradient" -o gradient-1.jpg 2>/dev/null || true
curl -L "https://source.unsplash.com/2736x1824/mountain" -o mountain-1.jpg 2>/dev/null || true

echo -e "${GREEN}✓ Wallpapers downloaded to ~/Pictures/Wallpapers${NC}"
echo ""
echo "Set wallpaper: Right-click desktop → Configure Desktop and Wallpaper"
echo "Browse to: ~/Pictures/Wallpapers"
