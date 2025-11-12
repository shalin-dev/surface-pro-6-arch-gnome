# Dash to Panel Customization Guide

## Quick Setup

Run this script from your terminal (after logging in as user):
```bash
~/customize-dash-to-panel.sh
```

Then **log out and log back in** for the extension to activate.

## What Gets Configured

### iPad/One UI Style Settings:
- Panel at bottom of screen
- 64px panel height (easy to touch)
- 48px app icons (large for fingers)
- Centered dock layout
- Semi-transparent background (80% opacity)
- Blur effect for modern look
- Shows running apps + favorites
- Hover animations (ripple effect)

## Manual Customization

After the script runs, you can further customize by:

1. **Right-click on panel** → **Dash to Panel Settings**

### Recommended Tweaks

#### Position & Size
- **Position**: Bottom (iPad), Top (One UI), or Left/Right
- **Panel height**: 48-72px (64px is good for touch)
- **Icon size**: 40-56px (48px recommended)

#### Style
- **Style**:
  - METRO: Flat, modern (like Windows 11)
  - DOTS: iOS-style dot indicators
  - DASHES: Material style underlines

- **Transparency**:
  - Fixed: Always same opacity
  - Dynamic: Changes based on content
  - Recommended: 70-85% for modern look

#### Behavior
- **Click action**:
  - TOGGLE: Click to minimize/restore (recommended)
  - CYCLE: Click to cycle through windows
  - QUIT: Click to close

- **Scroll action**:
  - Cycle windows
  - Volume control
  - None (recommended for tablet)

#### Appearance
- **Show Activities button**: OFF (cleaner look)
- **Show App Menu**: Your choice
- **Isolate workspaces**: OFF (see all apps)
- **Show window previews**: ON (like iPad multitasking)

## Preset Configurations

### iPad Style
```bash
gsettings set org.gnome.shell.extensions.dash-to-panel panel-positions '{"0":"BOTTOM"}'
gsettings set org.gnome.shell.extensions.dash-to-panel panel-sizes '{"0":72}'
gsettings set org.gnome.shell.extensions.dash-to-panel appicon-icon-size 52
gsettings set org.gnome.shell.extensions.dash-to-panel dot-style-focused 'METRO'
gsettings set org.gnome.shell.extensions.dash-to-panel trans-panel-opacity 0.9
```

### Samsung One UI Style
```bash
gsettings set org.gnome.shell.extensions.dash-to-panel panel-positions '{"0":"BOTTOM"}'
gsettings set org.gnome.shell.extensions.dash-to-panel panel-sizes '{"0":64}'
gsettings set org.gnome.shell.extensions.dash-to-panel appicon-icon-size 48
gsettings set org.gnome.shell.extensions.dash-to-panel dot-style-focused 'DASHES'
gsettings set org.gnome.shell.extensions.dash-to-panel trans-panel-opacity 0.75
gsettings set org.gnome.shell.extensions.dash-to-panel trans-bg-color '#1a1a1a'
```

### Windows 11 Style
```bash
gsettings set org.gnome.shell.extensions.dash-to-panel panel-positions '{"0":"BOTTOM"}'
gsettings set org.gnome.shell.extensions.dash-to-panel panel-sizes '{"0":56}'
gsettings set org.gnome.shell.extensions.dash-to-panel appicon-icon-size 44
gsettings set org.gnome.shell.extensions.dash-to-panel dot-style-focused 'METRO'
gsettings set org.gnome.shell.extensions.dash-to-panel show-apps-icon-side-padding 12
```

## All Available Settings

### Panel Configuration
```bash
# Position: TOP, BOTTOM, LEFT, RIGHT
gsettings set org.gnome.shell.extensions.dash-to-panel panel-positions '{"0":"BOTTOM"}'

# Size in pixels
gsettings set org.gnome.shell.extensions.dash-to-panel panel-sizes '{"0":64}'

# Multi-monitor setup
# {"0":"BOTTOM", "1":"TOP"}  # Monitor 0 bottom, Monitor 1 top
```

### Icon Settings
```bash
# Icon size (24-64px)
gsettings set org.gnome.shell.extensions.dash-to-panel appicon-icon-size 48

# Icon margins and padding
gsettings set org.gnome.shell.extensions.dash-to-panel appicon-margin 8
gsettings set org.gnome.shell.extensions.dash-to-panel appicon-padding 8

# Show app labels on hover
gsettings set org.gnome.shell.extensions.dash-to-panel show-tooltip true
```

### Visual Effects
```bash
# Running app indicator style
# Options: DOTS, SQUARES, DASHES, METRO, BINARY, SEGMENTED, SOLID, CILIORA
gsettings set org.gnome.shell.extensions.dash-to-panel dot-style-focused 'METRO'
gsettings set org.gnome.shell.extensions.dash-to-panel dot-style-unfocused 'DOTS'

# Hover animation
gsettings set org.gnome.shell.extensions.dash-to-panel animate-appicon-hover true
gsettings set org.gnome.shell.extensions.dash-to-panel animate-appicon-hover-animation-type 'RIPPLE'
# Options: RIPPLE, SIMPLE
```

### Transparency
```bash
# Enable custom transparency
gsettings set org.gnome.shell.extensions.dash-to-panel trans-use-custom-opacity true

# Opacity (0.0 = transparent, 1.0 = solid)
gsettings set org.gnome.shell.extensions.dash-to-panel trans-panel-opacity 0.8

# Background color (hex)
gsettings set org.gnome.shell.extensions.dash-to-panel trans-bg-color '#000000'

# Dynamic transparency
gsettings set org.gnome.shell.extensions.dash-to-panel trans-use-dynamic-opacity true
```

### Behavior
```bash
# What to show
gsettings set org.gnome.shell.extensions.dash-to-panel show-favorites true
gsettings set org.gnome.shell.extensions.dash-to-panel show-running-apps true

# Click behavior
gsettings set org.gnome.shell.extensions.dash-to-panel click-action 'TOGGLE-SHOWPREVIEW'
# Options: TOGGLE, TOGGLE-SHOWPREVIEW, CYCLE, QUIT, SKIP, RAISE

# Middle-click
gsettings set org.gnome.shell.extensions.dash-to-panel middle-click-action 'LAUNCH'

# Shift+Click
gsettings set org.gnome.shell.extensions.dash-to-panel shift-click-action 'MINIMIZE'
```

### Panel Elements
```bash
# Show/hide elements
gsettings set org.gnome.shell.extensions.dash-to-panel show-activities-button false
gsettings set org.gnome.shell.extensions.dash-to-panel show-show-apps-button true
gsettings set org.gnome.shell.extensions.dash-to-panel show-appmenu false

# Clock position
gsettings set org.gnome.shell.extensions.dash-to-panel location-clock 'STATUSRIGHT'
# Options: STATUSLEFT, STATUSRIGHT, NATURAL

# System menu
gsettings set org.gnome.shell.extensions.dash-to-panel show-status-menu-all-monitors false
```

## Troubleshooting

### Extension not showing after login
```bash
# Check if enabled
gnome-extensions list --enabled | grep dash-to-panel

# Enable manually
gnome-extensions enable dash-to-panel@jderose9.github.com

# Restart GNOME (on Wayland, log out/in)
```

### Panel looks wrong
```bash
# Reset to defaults
dconf reset -f /org/gnome/shell/extensions/dash-to-panel/

# Re-run customization script
~/customize-dash-to-panel.sh
```

### Settings not saving
- Make sure you're running commands as your user (not sudo)
- Log out and back in after changes
- Check for conflicts with other extensions

## Pinning Apps to Panel

1. Open the app
2. Right-click its icon in panel
3. Click "Pin to Dash"

Or set favorites:
```bash
gsettings set org.gnome.shell favorite-apps "['firefox.desktop', 'org.gnome.Console.desktop', 'org.gnome.Nautilus.desktop', 'rnote.desktop']"
```

## Advanced: Import/Export Settings

### Export current settings
```bash
dconf dump /org/gnome/shell/extensions/dash-to-panel/ > ~/dash-to-panel-backup.conf
```

### Import settings
```bash
dconf load /org/gnome/shell/extensions/dash-to-panel/ < ~/dash-to-panel-backup.conf
```

## Color Schemes

### Dark Material Theme
```bash
gsettings set org.gnome.shell.extensions.dash-to-panel trans-bg-color '#1E1E1E'
gsettings set org.gnome.shell.extensions.dash-to-panel trans-panel-opacity 0.85
```

### One UI Dark
```bash
gsettings set org.gnome.shell.extensions.dash-to-panel trans-bg-color '#0A0A0A'
gsettings set org.gnome.shell.extensions.dash-to-panel trans-panel-opacity 0.75
```

### iOS/iPadOS
```bash
gsettings set org.gnome.shell.extensions.dash-to-panel trans-bg-color '#F5F5F5'
gsettings set org.gnome.shell.extensions.dash-to-panel trans-panel-opacity 0.9
gsettings set org.gnome.shell.extensions.dash-to-panel trans-use-custom-bg true
```

## Summary

✓ Run: `~/customize-dash-to-panel.sh`
✓ Log out and back in
✓ Right-click panel for more settings
✓ Enjoy your iPad/One UI style dock!
