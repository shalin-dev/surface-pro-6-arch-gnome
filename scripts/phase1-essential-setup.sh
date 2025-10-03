#!/bin/bash
#
# Surface Pro 6 Linux Setup - Phase 1: Essential Setup
#
# This script installs the core components needed for Surface Pro 6
# to function properly on EndeavourOS (Arch-based distributions)
#
# Requirements:
#   - EndeavourOS or Arch-based distribution
#   - Internet connection
#   - sudo privileges
#
# Usage: sudo ./phase1-essential-setup.sh
#

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}Error: Do not run this script as root. Run with sudo when prompted.${NC}"
   exit 1
fi

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}Surface Pro 6 - Phase 1 Essential Setup${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

# Function to print status messages
print_status() {
    echo -e "${GREEN}[✓]${NC} $1"
}

print_warning() {
    echo -e "${YELLOW}[!]${NC} $1"
}

print_error() {
    echo -e "${RED}[✗]${NC} $1"
}

print_info() {
    echo -e "${BLUE}[i]${NC} $1"
}

# Confirm before proceeding
echo -e "${YELLOW}This script will:${NC}"
echo "  1. Add linux-surface repository"
echo "  2. Install linux-surface kernel and headers"
echo "  3. Install IPTSD (touchscreen/stylus support)"
echo "  4. Install Wacom/stylus drivers"
echo "  5. Install thermal management (thermald)"
echo "  6. Install power management (auto-cpufreq)"
echo "  7. Install Bluetooth support"
echo "  8. Install Intel graphics drivers"
echo "  9. Install screen rotation support"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Installation cancelled."
    exit 0
fi

echo ""
print_info "Starting installation..."
echo ""

# Step 1: Add linux-surface repository
print_info "Step 1/9: Adding linux-surface repository..."

if ! grep -q "\[linux-surface\]" /etc/pacman.conf; then
    print_info "Importing linux-surface GPG key..."
    curl -s https://raw.githubusercontent.com/linux-surface/linux-surface/master/pkg/keys/surface.asc | sudo pacman-key --add -
    sudo pacman-key --lsign-key 56C464BAAC421453

    print_info "Adding repository to /etc/pacman.conf..."
    echo -e "\n[linux-surface]\nServer = https://pkg.surfacelinux.com/arch/" | sudo tee -a /etc/pacman.conf > /dev/null

    print_status "linux-surface repository added"
else
    print_status "linux-surface repository already configured"
fi

# Update package database
print_info "Updating package database..."
sudo pacman -Sy

echo ""

# Step 2: Install linux-surface kernel
print_info "Step 2/9: Installing linux-surface kernel and headers..."
sudo pacman -S --needed --noconfirm linux-surface linux-surface-headers
print_status "linux-surface kernel installed"

echo ""

# Step 3: Install IPTSD
print_info "Step 3/9: Installing IPTSD (touchscreen/stylus support)..."
sudo pacman -S --needed --noconfirm iptsd linux-firmware-marvell
print_status "IPTSD installed"

echo ""

# Step 4: Install Wacom/stylus support
print_info "Step 4/9: Installing Wacom and stylus drivers..."
sudo pacman -S --needed --noconfirm libwacom xf86-input-wacom
print_status "Wacom drivers installed"

echo ""

# Step 5: Install thermal management
print_info "Step 5/9: Installing thermal management (thermald)..."
sudo pacman -S --needed --noconfirm thermald
sudo systemctl enable thermald
print_status "thermald installed and enabled"

echo ""

# Step 6: Install power management - auto-cpufreq
print_info "Step 6/9: Installing power management (auto-cpufreq)..."

# Check if TLP is installed and warn
if pacman -Qq tlp &> /dev/null; then
    print_warning "TLP is installed. It conflicts with auto-cpufreq."
    read -p "Remove TLP and install auto-cpufreq? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        sudo pacman -R --noconfirm tlp
        print_status "TLP removed"
    else
        print_warning "Skipping auto-cpufreq installation"
    fi
fi

if ! command -v auto-cpufreq &> /dev/null; then
    # Install base-devel if not present
    sudo pacman -S --needed --noconfirm base-devel git

    # Clone and install auto-cpufreq
    TEMP_DIR=$(mktemp -d)
    cd "$TEMP_DIR"
    git clone https://github.com/AdnanHodzic/auto-cpufreq.git
    cd auto-cpufreq
    sudo ./auto-cpufreq-installer --install
    cd ~
    rm -rf "$TEMP_DIR"

    print_status "auto-cpufreq installed"
else
    print_status "auto-cpufreq already installed"
fi

# Install powertop for additional monitoring
sudo pacman -S --needed --noconfirm powertop
print_status "powertop installed"

echo ""

# Step 7: Install Bluetooth
print_info "Step 7/9: Installing Bluetooth support..."
sudo pacman -S --needed --noconfirm bluez bluez-utils
sudo systemctl enable bluetooth
print_status "Bluetooth installed and enabled"

echo ""

# Step 8: Install Intel graphics drivers
print_info "Step 8/9: Installing Intel graphics drivers..."
sudo pacman -S --needed --noconfirm mesa vulkan-intel intel-media-driver
print_status "Intel graphics drivers installed"

echo ""

# Step 9: Install screen rotation support
print_info "Step 9/9: Installing screen rotation support..."
sudo pacman -S --needed --noconfirm iio-sensor-proxy
print_status "iio-sensor-proxy installed"

echo ""
echo -e "${BLUE}========================================${NC}"
echo -e "${GREEN}Phase 1 Installation Complete!${NC}"
echo -e "${BLUE}========================================${NC}"
echo ""

print_warning "IMPORTANT NEXT STEPS:"
echo ""
echo "  1. REBOOT to load the linux-surface kernel"
echo "     $ sudo reboot"
echo ""
echo "  2. After reboot, calibrate IPTSD for optimal stylus/touch:"
echo "     $ sudo systemctl stop 'iptsd@*.service'"
echo "     $ sudo iptsd-calibrate \$(sudo iptsd-find-hidraw)"
echo "     Follow on-screen instructions (3000-4000 samples)"
echo ""
echo "  3. Enable IPTSD service:"
echo "     $ sudo systemctl enable iptsd@\$(sudo iptsd-find-hidraw).service"
echo "     $ sudo systemctl start iptsd@\$(sudo iptsd-find-hidraw).service"
echo ""
echo "  4. Check installed kernel:"
echo "     $ uname -r"
echo "     Should show: linux-surface"
echo ""
echo "  5. Run Phase 2 setup for advanced customizations"
echo ""

print_info "Installation log saved to: /var/log/surface-pro-6-setup.log"

# Save completion timestamp
echo "Phase 1 completed at $(date)" | sudo tee -a /var/log/surface-pro-6-setup.log > /dev/null

echo ""
read -p "Reboot now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    print_info "Rebooting..."
    sudo reboot
else
    print_warning "Remember to reboot before using Surface-specific features!"
fi
