# Test Your Setup - Quick Guide

## Problem Found & Fixed ✓

The extension directory was owned by **root** instead of **dev**. This has been fixed!

## Step 1: Restart GNOME Shell

**IMPORTANT: You MUST restart GNOME Shell for the extension to load!**

### If you're on X11:
```bash
# Press Alt+F2
# Type: r
# Press Enter
```

### If you're on Wayland:
```bash
# Log out and log back in
```

### Don't know which one?
```bash
echo $XDG_SESSION_TYPE
# If it shows "x11" = use Alt+F2 + r
# If it shows "wayland" = log out/in
```

## Step 2: Check for Icon

After restarting GNOME Shell:

1. Look at your **top bar** (top right area)
2. You should see a **tablet icon** 📱
3. Click it to see the menu with:
   - Touchscreen Enabled (toggle)
   - Auto-Rotate (toggle)
   - Quick Disable (30s)

## Step 3: Test Gestures

Try these gestures one by one:

### Basic Gestures (Work Everywhere)

**3-finger swipe up:**
- Place 3 fingers on screen
- Swipe up quickly
- Should show **Activities Overview** (all your windows)

**2-finger tap:**
- Tap screen with 2 fingers at once
- Should show **right-click menu**

**4-finger pinch in:**
- Start with 4 fingers spread apart
- Pinch them together
- Should show **desktop** (minimize all windows)

### Workspace Gestures (Need Multiple Workspaces)

**3-finger swipe left/right:**
- Swipe left = next workspace
- Swipe right = previous workspace
- (You need to create workspaces first in Activities Overview)

## Step 4: Test Touchscreen Toggle

1. **Click the tablet icon** in top bar
2. **Select "Quick Disable (30s)"**
3. **Try touching the screen** - it should NOT respond
4. **Wait 30 seconds** - you should see a notification
5. **Touch screen again** - should work now!

## Troubleshooting

### Icon Still Not Showing

**Check if extension loaded:**
```bash
journalctl -n 100 --no-pager | grep -i "surface"
```

**Try enabling it manually:**
```bash
gnome-extensions enable surface-tablet-controls@custom
```

**Check extension status:**
```bash
gnome-extensions list
gnome-extensions info surface-tablet-controls@custom
```

### Gestures Not Responding

**Test if touchegg is working:**
```bash
systemctl status touchegg
# Should show "active (running)"
```

**Restart touchegg:**
```bash
sudo systemctl restart touchegg
```

**Check touchegg log:**
```bash
journalctl -u touchegg -n 50 --no-pager
```

**Test touch input is being detected:**
```bash
libinput debug-events
# Touch the screen and you should see events
# Press Ctrl+C to exit
```

### Still Not Working?

**Verify files:**
```bash
# Extension files
ls -la ~/.local/share/gnome-shell/extensions/surface-tablet-controls@custom/
# Should show: extension.js, metadata.json, stylesheet.css
# Owner should be: dev dev (NOT root root)

# Gesture config
cat ~/.config/touchegg/touchegg.conf | head -20
# Should show animation_delay: 100
```

**Check GNOME version compatibility:**
```bash
gnome-shell --version
# Should be 45.x, 46.x, 47.x, 48.x, or 49.x
```

**Enable debug logging:**
```bash
journalctl -f | grep -i "surface\|touchegg"
# Then try gestures and watch for errors
```

## What Should Work

### ✅ Gestures (via touchegg)
- 3-finger swipe up = Overview
- 3-finger swipe down = Minimize
- 3-finger swipe left/right = Switch workspace
- 4-finger pinch in = Show desktop
- 4-finger swipe up = Overview
- 2-finger tap = Right click
- 2-finger pinch = Zoom (in apps that support it)

**Browser-only gestures:**
- 2-finger swipe left/right = Back/Forward

### ✅ Extension (via top bar icon)
- Toggle touchscreen on/off
- Toggle auto-rotation on/off
- Quick disable for 30 seconds

## Quick Fix Commands

```bash
# Fix permissions (if icon not showing)
sudo chown -R dev:dev ~/.local/share/gnome-shell/extensions/surface-tablet-controls@custom/

# Restart touchegg (if gestures not working)
sudo systemctl restart touchegg

# Enable extension manually
gnome-extensions enable surface-tablet-controls@custom

# Restart GNOME Shell (X11 only)
# Alt+F2, type 'r', press Enter
```

## Test Each Feature

- [ ] Restarted GNOME Shell
- [ ] See tablet icon in top bar
- [ ] Clicked icon and see menu
- [ ] Tested "Quick Disable (30s)" - touch stops working
- [ ] Touch re-enabled after 30s
- [ ] 3-finger swipe up shows overview
- [ ] 2-finger tap shows right-click menu
- [ ] 4-finger pinch shows desktop
- [ ] Browser: 2-finger swipe back/forward works

Check off each item as you test it!
