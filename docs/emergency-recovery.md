# Emergency Recovery Guide

What to do if Phase 1 or Phase 2 breaks your graphics/login screen.

## Quick Recovery Checklist

If you can't see graphics or can't log in:

1. ✅ **Access TTY** (text-only terminal)
2. ✅ **Boot old kernel** (fallback)
3. ✅ **Restore GRUB backup**
4. ✅ **Rollback graphics drivers**
5. ✅ **Reset KDE configs**

---

## Step 1: Access TTY (Text Terminal)

When you can't see the login screen:

**Press:** `Ctrl + Alt + F2` (or F3, F4, F5, F6)

You'll see a black screen with white text login prompt:
```
Arch Linux 6.x.x-arch1-1 (tty2)

hostname login: _
```

**Login with your username and password** (text only, no graphics)

---

## Step 2: Boot Old Kernel (If New Kernel Breaks)

### At GRUB Boot Menu

1. **Power on** Surface Pro 6
2. **Immediately press and hold** `Shift` or `Esc` during boot
3. You'll see the GRUB menu with kernel options
4. **Use arrow keys** to select your old kernel (NOT linux-surface)
   - Look for entries like "Linux" or "Linux (fallback)"
   - Avoid "linux-surface" if it's broken
5. **Press Enter** to boot

### If GRUB Doesn't Show

Force GRUB menu to show every boot:
```bash
# In TTY (Ctrl+Alt+F2)
sudo nano /etc/default/grub

# Find this line:
GRUB_TIMEOUT_STYLE=hidden

# Change to:
GRUB_TIMEOUT_STYLE=menu
GRUB_TIMEOUT=10

# Save (Ctrl+O, Enter, Ctrl+X)
sudo grub-mkconfig -o /boot/grub/grub.cfg
sudo reboot
```

---

## Step 3: Restore GRUB Backup

If Phase 1 broke GRUB config:

```bash
# In TTY (Ctrl+Alt+F2)
# Restore backup created by Phase 1
sudo cp /boot/grub/grub.cfg.backup /boot/grub/grub.cfg

# Or regenerate fresh GRUB config
sudo grub-mkconfig -o /boot/grub/grub.cfg

sudo reboot
```

---

## Step 4: Rollback Graphics Drivers

If Mesa/Intel drivers broke SDDM:

### Option A: Downgrade Mesa
```bash
# In TTY (Ctrl+Alt+F2)
# Check Mesa version
pacman -Q mesa

# Downgrade to previous version
sudo pacman -U /var/cache/pacman/pkg/mesa-<old-version>.pkg.tar.zst

# Example:
# sudo pacman -U /var/cache/pacman/pkg/mesa-24.1.0-1-x86_64.pkg.tar.zst
```

### Option B: Remove linux-surface Kernel
```bash
# In TTY (Ctrl+Alt+F2)
sudo pacman -R linux-surface linux-surface-headers

# Regenerate GRUB
sudo grub-mkconfig -o /boot/grub/grub.cfg

sudo reboot
```

### Option C: Force Software Rendering (Emergency)
```bash
# In TTY (Ctrl+Alt+F2)
# Disable hardware acceleration in SDDM
sudo nano /etc/sddm.conf

# Add these lines:
[General]
DisplayServer=x11

[X11]
ServerArguments=-nolisten tcp -dpi 96

# Save and restart
sudo systemctl restart sddm
```

---

## Step 5: Reset KDE/Plasma Configs

If Phase 2 broke KDE:

### Reset to Default KDE
```bash
# In TTY (Ctrl+Alt+F2)
# Backup current configs
mv ~/.config ~/.config.broken-backup

# Restart SDDM
sudo systemctl restart sddm

# Now login - you'll have default KDE settings
```

### Reset Specific Components
```bash
# In TTY (Ctrl+Alt+F2)

# Reset only Plasma shell
rm ~/.config/plasmashellrc

# Reset only KWin (window manager)
rm ~/.config/kwinrc

# Reset only SDDM theme
sudo rm /etc/sddm.conf.d/*.conf

# Restart display manager
sudo systemctl restart sddm
```

---

## Step 6: Uninstall Phase 2 Changes

Complete rollback of Phase 2:

```bash
# In TTY (Ctrl+Alt+F2)

# Remove installed packages
sudo pacman -R touchegg maliit-keyboard maliit-framework kvantum

# Remove mode switcher scripts
rm ~/.local/bin/surface-tablet-mode
rm ~/.local/bin/surface-desktop-mode

# Restore backup configs (if Phase 2 created backup)
# Look for backup directory
ls -la ~/ | grep surface-backup

# Restore from backup
cp -r ~/.config/surface-backup-YYYYMMDD-HHMMSS/* ~/.config/

# Restart KDE
sudo systemctl restart sddm
```

---

## Step 7: Nuclear Option - Reinstall Desktop

If everything is broken:

```bash
# In TTY (Ctrl+Alt+F2)

# Reinstall KDE Plasma
sudo pacman -S plasma-meta sddm

# Reinstall display drivers
sudo pacman -S mesa xf86-video-intel

# Enable SDDM
sudo systemctl enable sddm
sudo systemctl start sddm
```

---

## Prevention: Safe Testing Steps

Before running Phase 1 or Phase 2 on your main system:

### 1. Create System Snapshot (Timeshift)

```bash
# Install Timeshift
sudo pacman -S timeshift

# Create snapshot
sudo timeshift --create --comments "Before Phase 1"

# Restore later if needed
sudo timeshift --restore
```

### 2. Verify Current Kernel Works

```bash
# Check current kernel
uname -r

# Test current kernel boots
sudo grub-mkconfig -o /boot/grub/grub.cfg
grep menuentry /boot/grub/grub.cfg
```

### 3. Test in Safe Mode First

Boot with safe graphics:
1. At GRUB menu, press `e` on your kernel
2. Add to end of `linux` line: `nomodeset`
3. Press `Ctrl+X` to boot
4. If boots successfully, graphics drivers are the issue

---

## Common Scenarios

### Scenario 1: Black Screen, Can't Login

**Symptom:** Screen turns on but stays black
**Fix:**
1. `Ctrl+Alt+F2` to TTY
2. `sudo systemctl restart sddm`
3. If still broken: `sudo pacman -R linux-surface && sudo reboot`

### Scenario 2: Login Screen Garbled/Corrupted

**Symptom:** Login screen has visual artifacts
**Fix:**
1. `Ctrl+Alt+F2` to TTY
2. Force software rendering:
   ```bash
   echo "LIBGL_ALWAYS_SOFTWARE=1" | sudo tee -a /etc/environment
   sudo reboot
   ```

### Scenario 3: Can Login But Desktop Won't Load

**Symptom:** Login works, then black screen or crash
**Fix:**
1. `Ctrl+Alt+F2` to TTY
2. Reset Plasma:
   ```bash
   rm ~/.config/plasma*
   rm ~/.config/kwinrc
   sudo systemctl restart sddm
   ```

### Scenario 4: GRUB Doesn't Show Any Kernels

**Symptom:** GRUB menu is empty
**Fix:**
1. Boot from USB installer
2. Arch-chroot into your system
3. `grub-install /dev/sdX && grub-mkconfig -o /boot/grub/grub.cfg`

### Scenario 5: Touchégg Causing Freezes

**Symptom:** System freezes when touching screen
**Fix:**
```bash
# In TTY
sudo systemctl stop touchegg
sudo systemctl disable touchegg
sudo pacman -R touchegg
sudo reboot
```

---

## Recovery Commands Cheat Sheet

```bash
# Access TTY
Ctrl + Alt + F2

# Return to graphical login
Ctrl + Alt + F1

# Restart display manager
sudo systemctl restart sddm

# Boot into old kernel
# (Select at GRUB menu - press Shift/Esc during boot)

# Restore GRUB backup
sudo cp /boot/grub/grub.cfg.backup /boot/grub/grub.cfg

# Remove linux-surface kernel
sudo pacman -R linux-surface linux-surface-headers
sudo grub-mkconfig -o /boot/grub/grub.cfg

# Reset KDE to defaults
mv ~/.config ~/.config.backup
sudo systemctl restart sddm

# Check logs for errors
sudo journalctl -xb -p err
sudo journalctl -u sddm

# Force software rendering
echo "LIBGL_ALWAYS_SOFTWARE=1" | sudo tee -a /etc/environment
```

---

## Getting Help

If recovery steps don't work:

1. **Boot from USB installer** (EndeavourOS live USB)
2. **Arch-chroot** into your system:
   ```bash
   sudo mount /dev/sdaX /mnt  # Replace X with your root partition
   sudo arch-chroot /mnt
   # Now run recovery commands
   ```

3. **Community Support:**
   - EndeavourOS Forums: https://forum.endeavouros.com/
   - linux-surface Matrix: https://matrix.to/#/#linux-surface:matrix.org
   - r/SurfaceLinux: https://reddit.com/r/SurfaceLinux

4. **Last Resort:** Reinstall EndeavourOS (preserving /home)

---

## Prevention Checklist

Before running Phase 1/Phase 2:

- [ ] Create Timeshift snapshot
- [ ] Verify `/boot/grub/grub.cfg` shows multiple kernels
- [ ] Test TTY access works (`Ctrl+Alt+F2`)
- [ ] Have USB installer ready
- [ ] Know your root partition (`lsblk`)
- [ ] Backup important files

**Remember:** Phase 1 now creates `/boot/grub/grub.cfg.backup` automatically!

---

## Contact

Found this guide helpful? Have additional recovery tips?
Submit improvements: https://github.com/YOUR_USERNAME/surface-pro-6-linux-setup/issues
