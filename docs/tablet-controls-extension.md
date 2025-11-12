# Surface Tablet Controls Extension

A GNOME Shell extension that provides quick touchscreen toggle and improved auto-rotation for Surface tablets.

## Features

### 🖐️ Touchscreen Toggle
- **Quick Access**: Click the touchscreen icon in the top bar
- **Enable/Disable**: Toggle touchscreen on or off instantly
- **Quick Disable**: Disable touchscreen for 30 seconds with one click (perfect for typing!)
- **Visual Feedback**: Icon changes color when touchscreen is disabled

### 🔄 Improved Auto-Rotation
- **Direct Sensor Monitoring**: Directly monitors `iio-sensor-proxy` for more reliable rotation
- **Toggle Lock**: Lock/unlock rotation from the menu
- **Automatic Rotation**: Supports all 4 orientations (normal, inverted, left, right)

## Installation

The extension is already installed at:
```
~/.local/share/gnome-shell/extensions/surface-tablet-controls@custom/
```

### Enable the Extension

1. **Restart GNOME Shell**:
   - Press `Alt+F2`
   - Type `r` and press Enter
   - OR log out and back in

2. **Verify**: You should see a touchscreen icon (📱) in your top bar

## Usage

### Touchscreen Control

**Toggle Touchscreen:**
1. Click the touchscreen icon in the top bar
2. Click "Touchscreen Enabled" to toggle on/off

**Quick Disable for Typing:**
1. Click the touchscreen icon
2. Select "Quick Disable (30s)"
3. Touchscreen will automatically re-enable after 30 seconds
4. Great for when you need to type without accidental touches!

### Auto-Rotation

**Enable/Disable Auto-Rotation:**
1. Click the touchscreen icon
2. Toggle "Auto-Rotate" on/off

**Lock Rotation:**
- Turn off "Auto-Rotate" to lock the current orientation
- Turn it back on to resume automatic rotation

## How It Works

### Touchscreen Toggle
The extension uses `xinput` to enable/disable the touchscreen device:
- **Enable**: `xinput enable 7`
- **Disable**: `xinput disable 7`

### Auto-Rotation
The extension:
1. Connects directly to `net.hadess.SensorProxy` via D-Bus
2. Claims the accelerometer sensor
3. Monitors `AccelerometerOrientation` property changes
4. Applies rotation using `xrandr` when orientation changes

This is more reliable than GNOME's built-in rotation because it:
- Directly monitors the sensor instead of relying on GNOME settings
- Immediately applies rotation changes
- Handles all 4 orientations (normal, inverted, left-up, right-up)

## Troubleshooting

### Extension Not Showing

**Check if extension is installed:**
```bash
ls ~/.local/share/gnome-shell/extensions/surface-tablet-controls@custom/
```

**Restart GNOME Shell:**
```bash
# Press Alt+F2, type 'r', press Enter
# Or:
killall -3 gnome-shell
```

**Check logs:**
```bash
journalctl -f -o cat /usr/bin/gnome-shell
```

### Touchscreen Not Toggling

**Check device name:**
```bash
xinput list | grep -i touch
```

If the device name is different from `xwayland-touch:16`, edit the extension:
```bash
nano ~/.local/share/gnome-shell/extensions/surface-tablet-controls@custom/extension.js
# Change line: const TOUCHSCREEN_DEVICE = 'xwayland-touch:16';
```

### Auto-Rotation Not Working

**Verify sensor proxy is running:**
```bash
sudo systemctl status iio-sensor-proxy
```

**Test sensor manually:**
```bash
monitor-sensor
# Rotate the device and watch for orientation changes
```

**Check D-Bus connection:**
```bash
busctl introspect net.hadess.SensorProxy /net/hadess/SensorProxy
```

### Rotation is Jerky or Delayed

The extension applies rotation immediately when the sensor reports a change. If rotation is delayed:

1. **Check sensor response time:**
   ```bash
   monitor-sensor
   # Should show orientation changes within 1 second
   ```

2. **Verify xrandr works:**
   ```bash
   xrandr --output eDP-1 --rotate left
   xrandr --output eDP-1 --rotate normal
   ```

## Customization

### Change Quick Disable Duration

Edit `/home/dev/.local/share/gnome-shell/extensions/surface-tablet-controls@custom/extension.js`:

```javascript
// Find this line (around line 113):
GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 30, () => {

// Change 30 to your preferred duration in seconds
GLib.timeout_add_seconds(GLib.PRIORITY_DEFAULT, 60, () => {  // 60 seconds
```

### Change Icon

Edit the icon name in `extension.js`:

```javascript
// Find this line:
icon_name: 'input-touchscreen-symbolic',

// Change to any icon from:
// /usr/share/icons/Adwaita/symbolic/
```

### Add Keyboard Shortcuts

You can add keyboard shortcuts in GNOME Settings:
1. Settings → Keyboard → Custom Shortcuts
2. Add shortcut for: `xinput disable 7` (disable touch)
3. Add shortcut for: `xinput enable 7` (enable touch)

## Uninstallation

Remove the extension:
```bash
rm -rf ~/.local/share/gnome-shell/extensions/surface-tablet-controls@custom/
```

Restart GNOME Shell:
```bash
# Alt+F2, type 'r', press Enter
```

## Technical Details

### Files Structure
```
~/.local/share/gnome-shell/extensions/surface-tablet-controls@custom/
├── metadata.json          # Extension metadata
├── extension.js           # Main extension code
└── stylesheet.css         # Icon styling
```

### D-Bus Interface
The extension uses the following D-Bus interface:
- **Service**: `net.hadess.SensorProxy`
- **Object Path**: `/net/hadess/SensorProxy`
- **Methods**: `ClaimAccelerometer`, `ReleaseAccelerometer`
- **Properties**: `AccelerometerOrientation`, `HasAccelerometer`

### Dependencies
- `gnome-shell` (45, 46, or 47)
- `iio-sensor-proxy` (for auto-rotation)
- `xinput` (for touchscreen toggle)
- `xrandr` (for rotation)

## Contributing

Found a bug or want to add a feature?

Edit the extension files and restart GNOME Shell to test changes.

## Resources

- [GNOME Shell Extension Docs](https://gjs.guide/extensions/)
- [iio-sensor-proxy](https://gitlab.freedesktop.org/hadess/iio-sensor-proxy)
- [xinput Manual](https://www.x.org/releases/current/doc/man/man1/xinput.1.xhtml)
