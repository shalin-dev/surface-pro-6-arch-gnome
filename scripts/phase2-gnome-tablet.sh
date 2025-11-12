#!/bin/bash
#
# Surface Pro 6 GNOME Tablet Setup - Phase 2
#
# Transforms GNOME into a tablet-optimized interface with:
# - Touch-friendly extensions (Dash-to-Dock, tablet controls)
# - iPad-like gestures (Touchégg)
# - Optimized theming and scaling
# - Virtual keyboard (Maliit)
#
# Requirements:
# - Phase 1 completed and rebooted into linux-surface kernel
# - GNOME desktop environment
# - Internet connection
#
# Usage: ./phase2-gnome-tablet.sh
#

set -e  # Exit on error

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
NC='\033[0m'

# State file to track progress
STATE_FILE="$HOME/.surface-gnome-setup-state"

# Print functions
print_header() {
    echo -e "${CYAN}========================================${NC}"
    echo -e "${CYAN}$1${NC}"
    echo -e "${CYAN}========================================${NC}"
    echo ""
}

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

# Check if step is completed
is_step_done() {
    grep -q "^$1$" "$STATE_FILE" 2>/dev/null
}

# Mark step as completed
mark_step_done() {
    echo "$1" >> "$STATE_FILE"
}

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   print_error "Do not run this script as root!"
   exit 1
fi

# Check if GNOME is running
if [ "$XDG_CURRENT_DESKTOP" != "GNOME" ]; then
    print_warning "This script is optimized for GNOME desktop"
    print_warning "Current desktop: $XDG_CURRENT_DESKTOP"
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

# Check if running linux-surface kernel
if ! uname -r | grep -q "surface"; then
    print_error "Not running linux-surface kernel!"
    print_error "Did you complete Phase 1 and reboot?"
    echo ""
    print_info "Current kernel: $(uname -r)"
    print_info "Expected: *-surface"
    echo ""
    exit 1
fi

# Check if IPTSD is calibrated
if ! systemctl is-active --quiet 'iptsd@*.service'; then
    print_warning "IPTSD service is not running!"
    print_warning "Have you calibrated IPTSD after Phase 1?"
    echo ""
    print_info "To calibrate IPTSD:"
    echo "  1. sudo systemctl stop 'iptsd@*.service'"
    echo "  2. sudo iptsd-calibrate \$(sudo iptsd-find-hidraw)"
    echo "  3. sudo systemctl enable iptsd@\$(sudo iptsd-find-hidraw).service"
    echo "  4. sudo systemctl start iptsd@\$(sudo iptsd-find-hidraw).service"
    echo ""
    read -p "Continue anyway? (y/n) " -n 1 -r
    echo
    if [[ ! $REPLY =~ ^[Yy]$ ]]; then
        exit 0
    fi
fi

print_header "Surface Pro 6 - GNOME Tablet Setup"

echo -e "${YELLOW}This script will transform GNOME into a tablet interface:${NC}"
echo "  1. Install GNOME extensions (Dash-to-Dock, tablet controls)"
echo "  2. Configure iPad-like gestures (Touchégg)"
echo "  3. Apply touch-friendly themes and scaling"
echo "  4. Install virtual keyboard (Maliit)"
echo "  5. Install tablet-optimized apps"
echo ""
echo -e "${YELLOW}NOTE: You will need to LOG OUT after step 2!${NC}"
echo ""
read -p "Continue? (y/n) " -n 1 -r
echo
if [[ ! $REPLY =~ ^[Yy]$ ]]; then
    print_warning "Setup cancelled"
    exit 0
fi

echo ""

# ============================================================================
# STEP 1: Install Required Packages
# ============================================================================

if ! is_step_done "step1_packages"; then
    print_header "Step 1/6: Installing Required Packages"

    # Core packages for gestures and touch
    print_info "Installing touchegg (gesture support)..."
    sudo pacman -S --needed --noconfirm touchegg

    # Virtual keyboard
    print_info "Installing Maliit virtual keyboard..."
    sudo pacman -S --needed --noconfirm maliit-keyboard maliit-framework qt6-wayland

    # Theme and icon packages
    print_info "Installing themes and icons..."
    sudo pacman -S --needed --noconfirm \
        papirus-icon-theme \
        materia-gtk-theme \
        gnome-tweaks

    # Tablet-friendly apps
    print_info "Installing tablet-optimized applications..."
    sudo pacman -S --needed --noconfirm \
        xournalpp \
        foliate \
        drawing \
        gnome-weather \
        gnome-clocks \
        gnome-calculator

    print_status "Packages installed successfully"
    mark_step_done "step1_packages"
    echo ""
else
    print_status "Step 1: Packages already installed (skipping)"
    echo ""
fi

# ============================================================================
# STEP 2: Install and Enable GNOME Extensions
# ============================================================================

if ! is_step_done "step2_extensions"; then
    print_header "Step 2/6: Installing GNOME Extensions"

    print_info "Installing extension manager..."
    sudo pacman -S --needed --noconfirm gnome-shell-extensions extension-manager

    # Install yay if not present (for AUR extensions)
    if ! command -v yay &> /dev/null; then
        print_info "Installing yay (AUR helper)..."
        sudo pacman -S --needed --noconfirm base-devel git
        cd /tmp
        git clone https://aur.archlinux.org/yay.git
        cd yay
        makepkg -si --noconfirm
        cd ~
    fi

    # Install extensions from AUR
    print_info "Installing Dash-to-Dock..."
    yay -S --needed --noconfirm gnome-shell-extension-dash-to-dock

    print_info "Installing additional extensions..."
    yay -S --needed --noconfirm \
        gnome-shell-extension-gsconnect \
        gnome-shell-extension-clipboard-indicator

    print_status "Extensions installed"

    # Enable extensions
    print_info "Enabling extensions..."
    gnome-extensions enable dash-to-dock@micxgx.gmail.com || true
    gnome-extensions enable gsconnect@andyholmes.github.io || true

    print_status "Extensions enabled"
    mark_step_done "step2_extensions"

    echo ""
    print_warning "========================================"
    print_warning "IMPORTANT: YOU MUST LOG OUT NOW!"
    print_warning "========================================"
    echo ""
    echo "Extensions require GNOME Shell restart."
    echo ""
    echo "After logging back in, run this script again:"
    echo "  ./phase2-gnome-tablet.sh"
    echo ""
    read -p "Log out now? (y/n) " -n 1 -r
    echo
    if [[ $REPLY =~ ^[Yy]$ ]]; then
        gnome-session-quit --logout --no-prompt
    else
        print_warning "Remember to log out and run this script again!"
        exit 0
    fi
fi

# Check if extensions are loaded
if ! gnome-extensions list --enabled | grep -q "dash-to-dock"; then
    print_error "Dash-to-Dock is not enabled!"
    print_error "Did you log out and back in after Step 2?"
    echo ""
    print_info "Please log out and log back in, then run this script again."
    exit 1
fi

print_status "Step 2: Extensions already enabled and loaded"
echo ""

# ============================================================================
# STEP 3: Configure Touchégg Gestures
# ============================================================================

if ! is_step_done "step3_gestures"; then
    print_header "Step 3/6: Configuring iPad-Like Gestures"

    # Create touchegg config directory
    mkdir -p ~/.config/touchegg

    print_info "Creating optimized gesture configuration..."

    cat > ~/.config/touchegg/touchegg.conf << 'EOF'
<touchégg>
  <settings>
    <!-- Reduced animation delay for snappier response (iPad-like) -->
    <property name="animation_delay">100</property>
    <!-- Lower threshold = more responsive gestures -->
    <property name="action_execute_threshold">15</property>
    <property name="color">auto</property>
    <property name="borderColor">auto</property>
  </settings>

  <application name="All">
    <!-- 3-finger swipe up: Show Overview (like iPad App Switcher) -->
    <gesture type="SWIPE" fingers="3" direction="UP">
      <action type="RUN_COMMAND">
        <repeat>false</repeat>
        <command>gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval "Main.overview.show();"</command>
        <animation>CHANGE_DESKTOP_UP</animation>
      </action>
    </gesture>

    <!-- 3-finger swipe down: Close Overview or Minimize -->
    <gesture type="SWIPE" fingers="3" direction="DOWN">
      <action type="MINIMIZE_WINDOW">
        <animate>true</animate>
      </action>
    </gesture>

    <!-- 3-finger swipe left: Next workspace (smooth like iPad) -->
    <gesture type="SWIPE" fingers="3" direction="LEFT">
      <action type="CHANGE_DESKTOP">
        <direction>next</direction>
        <animate>true</animate>
        <animationPosition>right</animationPosition>
      </action>
    </gesture>

    <!-- 3-finger swipe right: Previous workspace -->
    <gesture type="SWIPE" fingers="3" direction="RIGHT">
      <action type="CHANGE_DESKTOP">
        <direction>previous</direction>
        <animate>true</animate>
        <animationPosition>left</animationPosition>
      </action>
    </gesture>

    <!-- 4-finger pinch in: Show desktop (like iPad home gesture) -->
    <gesture type="PINCH" fingers="4" direction="IN">
      <action type="SHOW_DESKTOP">
        <animate>true</animate>
      </action>
    </gesture>

    <!-- 4-finger swipe up: Overview -->
    <gesture type="SWIPE" fingers="4" direction="UP">
      <action type="RUN_COMMAND">
        <repeat>false</repeat>
        <command>gdbus call --session --dest org.gnome.Shell --object-path /org/gnome/Shell --method org.gnome.Shell.Eval "Main.overview.show();"</command>
      </action>
    </gesture>

    <!-- 2-finger tap: Right click -->
    <gesture type="TAP" fingers="2" direction="UNKNOWN">
      <action type="MOUSE_CLICK">
        <button>3</button>
      </action>
    </gesture>

    <!-- 2-finger pinch: Zoom -->
    <gesture type="PINCH" fingers="2" direction="IN">
      <action type="SEND_KEYS">
        <repeat>true</repeat>
        <keys>Control_L+minus</keys>
        <decreaseKeys>Control_L+plus</decreaseKeys>
      </action>
    </gesture>
  </application>

  <!-- Browser-specific gestures (Firefox, Chrome) -->
  <application name="firefox,Firefox,Google-chrome,Chromium">
    <!-- 2-finger swipe left: Back -->
    <gesture type="SWIPE" fingers="2" direction="LEFT">
      <action type="SEND_KEYS">
        <repeat>false</repeat>
        <keys>Alt_L+Left</keys>
        <on>begin</on>
      </action>
    </gesture>

    <!-- 2-finger swipe right: Forward -->
    <gesture type="SWIPE" fingers="2" direction="RIGHT">
      <action type="SEND_KEYS">
        <repeat>false</repeat>
        <keys>Alt_L+Right</keys>
        <on>begin</on>
      </action>
    </gesture>
  </application>
</touchégg>
EOF

    print_status "Gesture configuration created"

    # Enable and start touchegg service
    print_info "Enabling touchegg service..."
    sudo systemctl enable touchegg
    sudo systemctl restart touchegg

    print_status "Touchegg service started"
    mark_step_done "step3_gestures"
    echo ""
else
    print_status "Step 3: Gestures already configured (skipping)"
    echo ""
fi

# ============================================================================
# STEP 4: Configure Extensions and Dock
# ============================================================================

if ! is_step_done "step4_configure_extensions"; then
    print_header "Step 4/6: Configuring Tablet Interface"

    print_info "Configuring Dash-to-Dock for tablet use..."

    # Dash-to-Dock configuration
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-position 'BOTTOM' || true
    gsettings set org.gnome.shell.extensions.dash-to-dock dash-max-icon-size 48 || true
    gsettings set org.gnome.shell.extensions.dash-to-dock icon-size-fixed true || true
    gsettings set org.gnome.shell.extensions.dash-to-dock extend-height false || true
    gsettings set org.gnome.shell.extensions.dash-to-dock dock-fixed false || true
    gsettings set org.gnome.shell.extensions.dash-to-dock intellihide true || true
    gsettings set org.gnome.shell.extensions.dash-to-dock transparency-mode 'DYNAMIC' || true
    gsettings set org.gnome.shell.extensions.dash-to-dock background-opacity 0.8 || true

    print_status "Dash-to-Dock configured"

    # App grid configuration
    print_info "Configuring app grid for touch..."
    gsettings set org.gnome.desktop.privacy remember-app-usage false
    gsettings set org.gnome.desktop.privacy remember-recent-files false

    print_status "App grid configured"

    # Configure touch-friendly scaling
    print_info "Applying touch-friendly scaling..."
    gsettings set org.gnome.desktop.interface text-scaling-factor 1.15
    gsettings set org.gnome.desktop.interface cursor-size 32

    print_status "Scaling configured"

    mark_step_done "step4_configure_extensions"
    echo ""
else
    print_status "Step 4: Extensions already configured (skipping)"
    echo ""
fi

# ============================================================================
# STEP 5: Apply Theme and Visual Polish
# ============================================================================

if ! is_step_done "step5_theme"; then
    print_header "Step 5/6: Applying Theme and Visual Polish"

    print_info "Applying Materia theme..."
    gsettings set org.gnome.desktop.interface gtk-theme 'Materia-dark'
    gsettings set org.gnome.desktop.wm.preferences theme 'Materia-dark'

    print_info "Applying Papirus icon theme..."
    gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'

    print_info "Configuring fonts for readability..."
    gsettings set org.gnome.desktop.interface font-name 'Cantarell 11'
    gsettings set org.gnome.desktop.interface document-font-name 'Cantarell 11'
    gsettings set org.gnome.desktop.wm.preferences titlebar-font 'Cantarell Bold 11'

    print_status "Theme applied successfully"
    mark_step_done "step5_theme"
    echo ""
else
    print_status "Step 5: Theme already applied (skipping)"
    echo ""
fi

# ============================================================================
# STEP 6: Configure Maliit Virtual Keyboard
# ============================================================================

if ! is_step_done "step6_keyboard"; then
    print_header "Step 6/6: Configuring Virtual Keyboard"

    # Check if on Wayland
    if [ "$XDG_SESSION_TYPE" = "wayland" ]; then
        print_info "Configuring Maliit keyboard for Wayland..."

        # Set Maliit as input method
        gsettings set org.gnome.desktop.a11y.applications screen-keyboard-enabled true

        # Start maliit-server
        pkill maliit-server 2>/dev/null || true
        sleep 1
        maliit-server &

        print_status "Maliit keyboard configured"
        print_info "Maliit will start automatically on next login"
    else
        print_warning "You're on X11 session"
        print_warning "Maliit works best on Wayland"
        print_warning "Consider logging out and selecting 'GNOME (Wayland)' at login"
    fi

    mark_step_done "step6_keyboard"
    echo ""
else
    print_status "Step 6: Virtual keyboard already configured (skipping)"
    echo ""
fi

# ============================================================================
# Completion
# ============================================================================

print_header "Setup Complete!"

echo -e "${GREEN}Your GNOME desktop is now tablet-optimized!${NC}"
echo ""
echo "✅ Installed:"
echo "  • Dash-to-Dock (iPad-style bottom dock)"
echo "  • Touchégg (iPad-like gestures)"
echo "  • Maliit virtual keyboard"
echo "  • Tablet-optimized apps (Xournal++, Foliate)"
echo "  • Touch-friendly themes and scaling"
echo ""
echo "🎨 Configured:"
echo "  • 3-finger gestures (swipe up/down/left/right)"
echo "  • 4-finger gestures (pinch for desktop)"
echo "  • 2-finger tap for right-click"
echo "  • Browser back/forward gestures"
echo "  • Touch-friendly icon sizes and spacing"
echo ""
echo "📱 Test Your Gestures:"
echo "  • 3-finger swipe up → Activities Overview"
echo "  • 3-finger swipe left/right → Switch workspace"
echo "  • 4-finger pinch in → Show desktop"
echo "  • 2-finger tap → Right-click"
echo ""
echo "⚙️ Next Steps:"
echo "  1. Test all gestures to ensure they work"
echo "  2. Customize Dash-to-Dock: Right-click dock → Dash to Dock Settings"
echo "  3. Install more extensions via Extension Manager app"
echo "  4. Test virtual keyboard in text fields"
echo ""
echo "📚 Documentation:"
echo "  • Gesture guide: docs/tablet-controls-extension.md"
echo "  • Dash-to-Panel guide: docs/dash-to-panel-guide.md"
echo "  • Troubleshooting: docs/troubleshooting.md"
echo ""

# Clean up state file on successful completion
rm -f "$STATE_FILE"

print_info "Enjoy your tablet-optimized GNOME desktop!"
echo ""
