# Troubleshooting Guide

Common issues and solutions for Surface Pro 6 on Linux.

## Touchscreen Not Working

**Symptom:** Touch input not responding after boot

**Solution:**
```bash
# Restart IPTSD service
sudo systemctl restart iptsd@*.service

# Check IPTSD status
sudo systemctl status iptsd@*.service
```

**If still not working:**
```bash
# Find device
sudo iptsd-find-hidraw

# Enable and start service with correct device
sudo systemctl enable iptsd@DEVICE.service
sudo systemctl start iptsd@DEVICE.service
```

## WiFi Not Connecting

**Symptom:** WiFi adapter not detected or cannot connect

**Solution:**
```bash
# Install Marvell firmware
sudo pacman -S linux-firmware-marvell

# Reboot required
sudo reboot
```

## Poor Battery Life

**Symptom:** Battery draining faster than expected

**Solutions:**
1. Check CPU governor:
```bash
cat /sys/devices/system/cpu/cpu*/cpufreq/scaling_governor
```

2. Ensure auto-cpufreq is running:
```bash
sudo auto-cpufreq --stats
```

3. Reduce screen brightness
4. Disable Bluetooth when not in use

## Sleep Battery Drain

**Symptom:** 20-30% battery loss overnight in sleep mode

**Solution:** Use hibernate instead of suspend
- Configure hibernate (see battery-optimization.md)
- Set lid close action to hibernate in KDE Power Management

## Stylus Not Pressure Sensitive

**Symptom:** Stylus works but no pressure sensitivity

**Solution:**
```bash
# Calibrate IPTSD
sudo systemctl stop 'iptsd@*.service'
sudo iptsd-calibrate $(sudo iptsd-find-hidraw)

# Follow calibration instructions
# Then restart IPTSD service
```

## Palm Rejection Issues

**Symptom:** Palm touches register as input while writing

**Solution:**
1. Ensure IPTSD is calibrated properly
2. Add `DisableOnStylus = true` to `/etc/iptsd.d/99-stylus.conf`:
```ini
[Touch]
DisableOnStylus = true
```
3. Restart IPTSD

## Screen Rotation Not Working

**Symptom:** Screen doesn't auto-rotate in tablet mode

**Solution:**
```bash
# Check if iio-sensor-proxy is running
systemctl status iio-sensor-proxy

# If not installed:
sudo pacman -S iio-sensor-proxy
```

## Getting Help

- linux-surface Matrix: https://matrix.to/#/#linux-surface:matrix.org
- r/SurfaceLinux: https://reddit.com/r/SurfaceLinux
- EndeavourOS Forums: https://forum.endeavouros.com/
- GitHub Issues: Report bugs specific to this setup
