# Tablet UI Customization Guide - Material/One UI/iPad Style

## Overview
This guide transforms your GNOME desktop into a modern tablet interface inspired by Samsung One UI, Material Design, and iPadOS.

## What's Installed

### Themes
- **Materia GTK Theme** - Material Design inspired theme
- **Papirus Dark Icons** - Modern, colorful icon set
- Text scaling: 1.15x for better touch targets
- Cursor size: 32px for visibility

### GNOME Extensions
- **Dash to Panel** - iPad-like bottom dock
- **Arc Menu** - Modern app launcher
- **AppIndicator** - System tray icons

### Apps (GNOME Alternatives)
- Calculator, Weather, Clocks, Calendar
- Console (touch-friendly terminal)
- All standard GNOME apps

## Apply Theme Settings

Run the automated script:
```bash
~/surface-pro-6-linux-setup/scripts/apply-tablet-theme.sh
```

Or manually enable extensions:
```bash
# Enable Dash to Panel (iPad-like dock)
gnome-extensions enable dash-to-panel@jderose9.github.com
```

## Recommended Extensions (Install Manually)

Visit https://extensions.gnome.org/ and install:

### Essential for Tablet Feel
1. **Blur my Shell** - iOS-like blur effects
   - Blurs background of panels and overview
   - Makes UI feel more modern and polished

2. **Rounded Window Corners** - Smooth rounded corners
   - Matches One UI and iPadOS design language
   - Configurable corner radius

3. **GSConnect** - Samsung Flow/iOS Continuity alternative
   - Phone integration (Android)
   - Share files, clipboard, notifications

### Nice to Have
4. **Tactile** - Haptic feedback simulation
   - Provides visual feedback for actions

5. **Quick Settings Tweaker** - Customize quick settings
   - Like iOS/One UI control center
   - Rearrange toggles

6. **Big Sur Status Area** - macOS/iOS-style status bar
   - Clean, minimal top bar design

## Gesture Configuration

GNOME has built-in touchscreen gestures:

### Default Gestures
- **3-finger swipe up**: Show Activities overview (like iPad multitasking)
- **3-finger swipe left/right**: Switch workspaces (like app switching)
- **2-finger scroll**: Scroll content
- **Pinch to zoom**: In supported apps (Firefox, etc.)

### Configure Workspaces
```bash
# Set to 4 workspaces (iPad-like)
gsettings set org.gnome.desktop.wm.preferences num-workspaces 4
gsettings set org.gnome.mutter dynamic-workspaces false
```

## Material You / One UI Style Tweaks

### Color Scheme
The Materia theme provides Material Design colors. For dynamic colors based on wallpaper (like Material You):

1. Use solid color wallpapers or gradients
2. Match your favorite apps' accent colors
3. Papirus icons adapt to dark theme automatically

### One UI Inspired Layout
- **Bottom Panel**: Dash to Panel at bottom (like One UI)
- **Large Icons**: 56px panel size for easy touch
- **Rounded Corners**: Install extension for Samsung-style rounded UI
- **Dark Mode**: Reduces eye strain, modern look

### iPadOS Features
- **App Library**: Press Super key (Activities) - similar to App Library
- **Widgets**: Add GNOME extensions for weather, calendar widgets
- **Control Center**: Quick settings in top-right corner
- **Dock**: Dash to Panel with running apps + favorites

## Customization Commands

### Change Theme
```bash
# Available themes
ls /usr/share/themes

# Apply different theme
gsettings set org.gnome.desktop.interface gtk-theme 'Materia-light'
```

### Change Icons
```bash
# Available icon themes
ls /usr/share/icons

# Papirus has multiple variants
gsettings set org.gnome.desktop.interface icon-theme 'Papirus'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Dark'
gsettings set org.gnome.desktop.interface icon-theme 'Papirus-Light'
```

### Adjust Text Size
```bash
# Range: 1.0 (normal) to 1.5 (very large)
gsettings set org.gnome.desktop.interface text-scaling-factor 1.25
```

### Panel Position (Dash to Panel)
```bash
# BOTTOM (iPad-style), TOP, or LEFT/RIGHT
gsettings set org.gnome.shell.extensions.dash-to-panel panel-position 'BOTTOM'

# Panel height
gsettings set org.gnome.shell.extensions.dash-to-panel panel-size 64
```

## Wallpaper Recommendations

For Material/One UI look:
- Solid colors with gradients
- Abstract geometric shapes
- Nature photos with strong color themes
- Download from: https://unsplash.com or https://www.reddit.com/r/wallpapers

Set wallpaper:
```bash
gsettings set org.gnome.desktop.background picture-uri 'file:///path/to/wallpaper.jpg'
gsettings set org.gnome.desktop.background picture-uri-dark 'file:///path/to/dark-wallpaper.jpg'
```

## Night Light (Blue Light Filter)

Like iOS Night Shift or One UI Eye Comfort:
```bash
# Enable night light
gsettings set org.gnome.settings-daemon.plugins.color night-light-enabled true

# Temperature (1000-10000, lower = warmer)
gsettings set org.gnome.settings-daemon.plugins.color night-light-temperature 3700

# Schedule: sunset to sunrise
gsettings set org.gnome.settings-daemon.plugins.color night-light-schedule-automatic true
```

## Touch Keyboard Customization

GNOME keyboard is minimal. For more features:
- Keyboard auto-shows on text field tap
- For emoji: Long-press keys (if supported)
- For dictation: Install `gnome-shell-extension-espresso` for voice typing

## Performance Tips

Keep tablet UI smooth:
```bash
# Enable animations (smooth feel)
gsettings set org.gnome.desktop.interface enable-animations true

# Reduce animation speed (optional, for snappier feel)
gsettings set org.gnome.desktop.interface gtk-enable-animations false
```

## Troubleshooting

### Extensions not working after install
```bash
# Restart GNOME Shell (on Xorg)
Alt + F2, type 'r', press Enter

# On Wayland (you need to log out/in)
```

### Theme not applying
```bash
# Reload settings
gsettings reset org.gnome.desktop.interface gtk-theme
gsettings set org.gnome.desktop.interface gtk-theme 'Materia-dark-compact'
```

### Dash to Panel not showing
```bash
# Check if enabled
gnome-extensions list --enabled

# Enable manually
gnome-extensions enable dash-to-panel@jderose9.github.com
```

## Additional Resources

- GNOME Extensions: https://extensions.gnome.org/
- GNOME Tweaks: Installed, find in apps menu
- GTK Themes: https://www.gnome-look.org/
- Icon Themes: https://www.pling.com/

## Comparison to Other Tablet UIs

| Feature | iPadOS | One UI | This Setup |
|---------|--------|--------|------------|
| Bottom Dock | ✓ | ✓ | ✓ Dash to Panel |
| Gestures | ✓ | ✓ | ✓ 3-finger swipe |
| Dark Mode | ✓ | ✓ | ✓ Materia Dark |
| App Library | ✓ | ✓ | ✓ Activities |
| Widgets | ✓ | ✓ | ~ Extensions |
| Rounded UI | ✓ | ✓ | ✓ Extension |
| Material You | - | ✓ | ~ Manual |
| On-Screen Keyboard | ✓ | ✓ | ✓ Native |

## Next Steps

1. Run `apply-tablet-theme.sh`
2. Log out and log back in
3. Visit extensions.gnome.org for more customization
4. Experiment with different themes and layouts
5. Set your favorite wallpaper
6. Enjoy your tablet!
