# Power Management & Battery Optimization Guide

## Overview
Your Surface Pro 6 is now configured with intelligent power management that balances performance and battery life.

## What's Configured

### TLP Power Management
TLP automatically manages all power settings based on whether you're plugged in or on battery.

**On AC Power (Plugged In):**
- CPU: Performance mode for smooth UI
- Turbo Boost: Enabled
- GPU: Full speed (1100 MHz)
- WiFi: Full power
- Result: Maximum performance, no lag

**On Battery:**
- CPU: Power saving mode (max 2.4 GHz instead of 3.4 GHz)
- Turbo Boost: Disabled
- GPU: Reduced speed (800 MHz)
- WiFi: Power saving enabled
- Result: Extended battery life

### Screen Auto-Rotation
- ✓ Accelerometer enabled
- ✓ Screen rotates automatically when tablet is rotated
- ✓ Ambient light sensor adjusts brightness
- Toggle rotation lock: Quick settings panel (top-right)

### Sleep & Suspend Settings
- Screen dims: 5 minutes of inactivity
- Suspend on battery: 10 minutes
- Suspend on AC: 15 minutes
- Lid close: Instant suspend
- Power button: Suspend
- Auto-suspend: 30 minutes complete idle

## TLP Configuration Files

### Main Config
`/etc/tlp.d/01-surface-tablet.conf` - Custom Surface Pro 6 settings

Key settings:
```
CPU_SCALING_GOVERNOR_ON_AC=performance
CPU_SCALING_GOVERNOR_ON_BAT=powersave
CPU_BOOST_ON_AC=1
CPU_BOOST_ON_BAT=0
WIFI_PWR_ON_BAT=on
```

### System Power
`/etc/systemd/logind.conf.d/tablet-power.conf` - Lid/button behavior

## TLP Commands

### Check Status
```bash
sudo tlp-stat -s    # System status
sudo tlp-stat -b    # Battery info
sudo tlp-stat -p    # Power settings
sudo tlp-stat -t    # Temperatures
sudo tlp-stat       # Full report
```

### Manual Mode Switching
```bash
# Force AC mode (performance)
sudo tlp ac

# Force battery mode (power saving)
sudo tlp bat

# Apply settings immediately
sudo tlp start
```

### Check Current Settings
```bash
# CPU governor
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_governor

# CPU frequency
cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq

# Turbo boost status
cat /sys/devices/system/cpu/intel_pstate/no_turbo
```

## Battery Life Tips

### Expected Battery Life
- **Light use** (web browsing, reading): 6-8 hours
- **Medium use** (note-taking, documents): 5-6 hours
- **Heavy use** (video, drawing): 3-4 hours

### Maximize Battery
1. **Lower screen brightness** - biggest battery drain
   ```bash
   # Set to 50% brightness
   brightnessctl set 50%
   ```

2. **Enable night light** - reduces power consumption
   - Already enabled in settings

3. **Close unused apps** - free up CPU/RAM

4. **Disable Bluetooth when not in use**
   - Quick settings toggle

5. **Use power saving manually**
   ```bash
   sudo tlp bat  # Force battery mode even on AC
   ```

### Monitor Battery Health
```bash
# Battery capacity and health
sudo tlp-stat -b

# Check wear level
upower -i /org/freedesktop/UPower/devices/battery_BAT0
```

## Performance vs Battery Balance

If you experience lag on battery, you can adjust:

### Option 1: Less Aggressive Power Saving
Edit `/etc/tlp.d/01-surface-tablet.conf`:
```bash
# Increase max frequency on battery (from 2.4 to 3.0 GHz)
CPU_SCALING_MAX_FREQ_ON_BAT=3000000

# Use balanced policy instead of power saving
CPU_ENERGY_PERF_POLICY_ON_BAT=balance_performance
```

Then apply:
```bash
sudo tlp start
```

### Option 2: Disable TLP Temporarily
```bash
# Disable TLP
sudo systemctl stop tlp

# Re-enable
sudo systemctl start tlp
```

## Rotation Lock

### Toggle via GUI
- Click top-right corner (Quick Settings)
- Click rotation lock icon
- Or: Settings → Displays → Orientation Lock

### Toggle via Command
```bash
# Lock rotation
gsettings set org.gnome.settings-daemon.peripherals.touchscreen orientation-lock true

# Unlock rotation (auto-rotate)
gsettings set org.gnome.settings-daemon.peripherals.touchscreen orientation-lock false
```

## Power Button Behavior

Current configuration:
- **Short press**: Suspend
- **Long press**: Power off menu

To change:
```bash
# Short press does nothing
gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'nothing'

# Short press shows power menu
gsettings set org.gnome.settings-daemon.plugins.power power-button-action 'interactive'
```

## Troubleshooting

### Battery draining too fast
```bash
# Check what's using power
sudo powertop

# Auto-tune all settings (run once)
sudo powertop --auto-tune
```

### Screen not rotating
```bash
# Check sensor
monitor-sensor

# Restart sensor service
sudo systemctl restart iio-sensor-proxy

# Verify orientation lock is off
gsettings get org.gnome.settings-daemon.peripherals.touchscreen orientation-lock
```

### Lag on battery
```bash
# Check current CPU speed
watch -n 1 cat /sys/devices/system/cpu/cpu0/cpufreq/scaling_cur_freq

# Temporarily boost performance
sudo tlp ac
```

### TLP not working
```bash
# Check TLP status
sudo systemctl status tlp

# Restart TLP
sudo systemctl restart tlp

# Check for conflicts
sudo tlp-stat -s | grep -i conflict
```

## Advanced: Custom Power Profiles

Create custom profiles in `/etc/tlp.d/`:

**Example - Maximum Battery Life:**
`/etc/tlp.d/02-max-battery.conf`
```
CPU_SCALING_MAX_FREQ_ON_BAT=1600000
INTEL_GPU_MAX_FREQ_ON_BAT=600
WIFI_PWR_ON_AC=on
RUNTIME_PM_ON_AC=auto
```

**Example - Maximum Performance:**
`/etc/tlp.d/03-max-performance.conf`
```
CPU_SCALING_GOVERNOR_ON_BAT=performance
CPU_BOOST_ON_BAT=1
WIFI_PWR_ON_BAT=off
```

Note: Higher numbered files override lower ones. Rename to enable/disable.

## Comparison: Before vs After

| Metric | Before (Performance Mode) | After (TLP) |
|--------|--------------------------|-------------|
| Battery Life | 3-4 hours | 6-8 hours |
| CPU (AC) | Performance | Performance |
| CPU (Battery) | Performance | Power saving |
| Turbo Boost (Battery) | Always on | Disabled |
| WiFi Power | Full | Adaptive |
| UI Lag | None | None (AC), Minimal (Battery) |

## Resources

- TLP Documentation: https://linrunner.de/tlp/
- TLP FAQ: https://linrunner.de/tlp/faq/
- Power saving tips: https://wiki.archlinux.org/title/Power_management

## Summary

✓ Auto-rotation enabled
✓ Intelligent power management (TLP)
✓ Performance mode on AC
✓ Battery saving mode on battery
✓ Auto-suspend configured
✓ Ambient light sensor active

Your Surface Pro 6 will now last significantly longer on battery while maintaining smooth performance when plugged in!
