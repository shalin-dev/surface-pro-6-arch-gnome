# Tablet Mode Guide

Complete guide to using your Surface Pro 6 as a premium tablet after Phase 2 setup.

## Quick Start

### Switching Modes

**Tablet Mode** (Touch-optimized, larger UI):
```bash
surface-tablet-mode
```

**Desktop Mode** (Keyboard + mouse optimized):
```bash
surface-desktop-mode
```

### Automatic Switching (Optional)

To enable automatic mode switching when you attach/detach the Type Cover:

```bash
sudo cp /tmp/99-surface-typecover.rules /etc/udev/rules.d/
sudo udevadm control --reload-rules
```

## Gesture Controls

### 3-Finger Gestures

| Gesture | Action | Use Case |
|---------|--------|----------|
| 3-finger swipe up | Maximize/restore window | Full-screen apps |
| 3-finger swipe down | Minimize window | Quickly hide window |
| 3-finger swipe left | Next workspace | Switch between tasks |
| 3-finger swipe right | Previous workspace | Navigate workspaces |

### 4-Finger Gestures

| Gesture | Action | Use Case |
|---------|--------|----------|
| 4-finger pinch in | Show desktop | Quick access to desktop |
| 4-finger swipe up | Task switcher | Switch between apps |

### 2-Finger Gestures

| Gesture | Action | Use Case |
|---------|--------|----------|
| 2-finger tap | Right click | Context menu |

## Virtual Keyboard

### Enabling Virtual Keyboard

1. Open **System Settings**
2. Go to **Input Devices** → **Virtual Keyboard**
3. Select **Maliit**
4. Check "Enabled"

### Using the Keyboard

- **Auto-show**: Keyboard appears automatically when you tap a text field
- **Manual show**: Click the keyboard icon in system tray
- **Hide**: Tap the keyboard button or tap outside a text field
- **Floating mode**: Drag the keyboard to reposition it

### Keyboard Tips

- Swipe up from space bar for special characters
- Long-press keys for variants (e.g., hold 'a' for à, á, â, etc.)
- Two-finger swipe on keyboard to move cursor
- Use the clipboard button for paste history

## Tablet Mode Features

### What Changes in Tablet Mode

**UI Scaling:**
- 125% scale factor for larger touch targets
- Larger fonts (11pt → 16pt)
- Bigger panel (44px → 60px)

**Input:**
- Virtual keyboard auto-enabled
- Touch optimizations active
- Larger cursor size (32px)

**Layout:**
- Application Dashboard launcher (grid view)
- Bottom-aligned panel (iPad-style)
- Larger window controls
- Enhanced touch scrolling

### What Changes in Desktop Mode

**UI Scaling:**
- 100% scale factor
- Standard font sizes
- Normal panel height (44px)

**Input:**
- Virtual keyboard auto-disabled
- Mouse/trackpad optimizations
- Standard cursor size

**Layout:**
- Traditional desktop layout
- Top or side panel configurations
- Standard window controls

## Recommended Apps for Tablet Use

### Note-Taking
- **Xournal++**: Excellent stylus support, pressure sensitivity
- **Krita**: Drawing and painting with full Surface Pen support
- **KolourPaint**: Simple drawing app

### Web Browsing
- **Firefox**: Enable touch scroll in settings
- **Falkon**: KDE's lightweight browser with good touch support

### Document Reading
- **Okular**: PDF reader with touch gestures
- **Calibre**: E-book reader with tablet mode

### Media
- **Elisa**: Music player with touch-friendly controls
- **Haruna**: Video player with touch gestures

## Customization

### Changing Themes

**Global Theme:**
```bash
# System Settings → Appearance → Global Theme
# Recommended: Sweet, Breeze, or WhiteSur
```

**Icon Theme:**
```bash
# System Settings → Icons
# Recommended: Papirus-Dark, Tela, or Candy
```

### Adjusting Scaling

Manual scaling adjustment:
```bash
# Edit scaling factor (1.0 to 2.0)
kwriteconfig5 --file kdeglobals --group KScreen --key ScaleFactor 1.5
```

### Panel Configuration

**Bottom Dock (iPad-style):**
1. Right-click panel → Configure Panel
2. Click "Screen Edge" and select bottom
3. Set height to 60-80px
4. Add widgets: Application Launcher, Task Manager, System Tray

**App Launcher Grid:**
1. Right-click Application Menu → Configure
2. Select "Application Dashboard"
3. Increase icon size to 128px

### Gesture Customization

Edit gesture configuration:
```bash
nano ~/.config/touchegg/touchegg.conf
```

Restart Touchégg after changes:
```bash
sudo systemctl restart touchegg
```

## Troubleshooting

### Gestures Not Working

1. Check if Touchégg is running:
   ```bash
   systemctl status touchegg
   ```

2. Restart Touchégg:
   ```bash
   sudo systemctl restart touchegg
   ```

3. Verify config file exists:
   ```bash
   ls ~/.config/touchegg/touchegg.conf
   ```

### Virtual Keyboard Not Showing

1. Enable in System Settings:
   ```bash
   qdbus org.kde.plasmashell /PlasmaShell org.kde.PlasmaShell.evaluateScript 'loadLayout("org.kde.plasma.desktop")'
   ```

2. Check Maliit is installed:
   ```bash
   pacman -Q maliit-keyboard
   ```

3. Restart Plasma:
   ```bash
   killall plasmashell && plasmashell &
   ```

### Mode Switch Not Working

1. Check scripts are executable:
   ```bash
   ls -l ~/.local/bin/surface-*-mode
   ```

2. Make executable if needed:
   ```bash
   chmod +x ~/.local/bin/surface-tablet-mode
   chmod +x ~/.local/bin/surface-desktop-mode
   ```

3. Check kwriteconfig5 is installed:
   ```bash
   which kwriteconfig5
   ```

### Scaling Issues

Reset to default:
```bash
kwriteconfig5 --file kdeglobals --group KScreen --key ScaleFactor 1.0
killall plasmashell && plasmashell &
```

## Performance Tips

### Battery Life in Tablet Mode

1. Lower screen brightness to 40-50%
2. Disable Bluetooth when not in use
3. Use tablet mode only when needed (heavier animations)
4. Check power profile:
   ```bash
   sudo auto-cpufreq --stats
   ```

### Smooth Animations

If animations are laggy:
1. Reduce animation speed:
   ```bash
   kwriteconfig5 --file kwinrc --group Compositing --key AnimationSpeed 2
   ```

2. Or disable some effects:
   - System Settings → Desktop Effects
   - Disable "Blur", "Wobbly Windows" if laggy

### Touch Responsiveness

Optimize IPTSD for lower latency:
```bash
sudo systemctl stop 'iptsd@*.service'
sudo iptsd-calibrate $(sudo iptsd-find-hidraw)
# Collect 4000+ samples with quick taps
sudo systemctl start 'iptsd@*.service'
```

## Advanced Configuration

### Create Custom Modes

Create your own mode profile:
```bash
#!/bin/bash
# ~/.local/bin/surface-reading-mode
# Optimized for e-reading

kwriteconfig5 --file kdeglobals --group KScreen --key ScaleFactor 1.15
kwriteconfig5 --file kdeglobals --group General --key font "Noto Serif,13,-1,5,50,0,0,0,0,0"
killall plasmashell && plasmashell &
```

### Keyboard Shortcuts for Mode Switching

Add custom shortcuts:
1. System Settings → Shortcuts → Custom Shortcuts
2. Add new shortcut: `Meta+T` → `surface-tablet-mode`
3. Add new shortcut: `Meta+D` → `surface-desktop-mode`

### Auto-Rotate Screen

Screen rotation works automatically via `iio-sensor-proxy`.

Lock rotation:
```bash
# Lock in landscape
kwriteconfig5 --file kwinrc --group Windows --key RotationMode 0

# Lock in portrait
kwriteconfig5 --file kwinrc --group Windows --key RotationMode 1
```

## Tips and Tricks

### Quick Actions
- **Double-tap stylus button**: Right click
- **Hold stylus button + tap**: Open context menu
- **Palm while writing**: Automatically rejected with IPTSD

### Multitasking
- **Split screen**: Drag window to edge until overlay appears
- **Workspace overview**: 4-finger pinch or Meta+Tab
- **App launcher**: Meta key or swipe up from bottom

### Stylus Optimization
- Calibrate regularly for best palm rejection
- Adjust pressure curve in app settings (Krita, Xournal++)
- Use stylus-specific profiles in apps

### Edge Gestures (Optional)
Configure swipe from edges using Touchégg:
- **Swipe from left**: Back
- **Swipe from right**: Forward
- **Swipe from top**: Toggle maximize
- **Swipe from bottom**: Show app launcher

## Resources

- **Touchégg Documentation**: https://github.com/JoseExposito/touchegg
- **Maliit Keyboard**: https://maliit.github.io/
- **KDE Plasma Touch**: https://community.kde.org/Plasma/Mobile
- **linux-surface Wiki**: https://github.com/linux-surface/linux-surface/wiki

## Contributing

Found a useful tablet mode tip? Share it with the community!

Submit improvements: https://github.com/YOUR_USERNAME/surface-pro-6-linux-setup/issues
