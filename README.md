# Surface Pro 6 Linux Setup - GNOME Edition

Comprehensive setup scripts and configuration for running **GNOME with tablet optimizations** on Microsoft Surface Pro 6. Transform your Surface into a touch-first Linux tablet with iPad-like gestures, dock, and interface.

## Overview

This repository provides automated installation and configuration to make your Surface Pro 6 a fully functional Linux tablet with GNOME desktop environment.

**Target Distribution:** EndeavourOS / Arch Linux (adaptable to other distributions)

**Tested Hardware:** Surface Pro 6 (i5-8250U, 8GB RAM)

**Desktop Environment:** GNOME 45+ with tablet extensions

## Features

- **Automated 2-Phase Setup**: Hardware support → Tablet interface
- **Touchscreen & Stylus**: Full IPTSD integration with pressure sensitivity
- **iPad-Like Gestures**: 3-finger/4-finger multitouch gestures via Touchégg
- **Dash-to-Dock**: iOS/iPadOS-style bottom dock
- **Touch Controls Extension**: Quick touchscreen toggle from top bar
- **Power Management**: Optimized battery life with auto-cpufreq
- **Virtual Keyboard**: Maliit keyboard for Wayland
- **Tablet Apps**: Xournal++ for notes, Foliate for reading

## Quick Start

### Prerequisites

- EndeavourOS or Arch-based distribution installed
- GNOME desktop environment
- Internet connection
- Sudo privileges

### ⚠️ Safety First

**Before running Phase 1:**
- Create a system backup/snapshot (Timeshift recommended)
- Know how to access TTY: `Ctrl+Alt+F2`
- Read the recovery guide: [docs/emergency-recovery.md](docs/emergency-recovery.md)

**Your old kernel will remain bootable** - if graphics break, press `Shift` during boot to select it from GRUB.

### Phase 1: Essential Setup (Automated)

```bash
# Clone this repository
git clone https://github.com/YOUR_USERNAME/surface-pro-6-arch-gnome.git
cd surface-pro-6-arch-gnome

# Run Phase 1 installation
./scripts/phase1-essential-setup.sh
```

**What Phase 1 Installs:**

1. linux-surface kernel and headers
2. IPTSD (Intel Precise Touch & Stylus Daemon)
3. Wacom and stylus drivers
4. Thermal management (thermald)
5. Power management (auto-cpufreq, powertop)
6. Bluetooth support
7. Intel graphics drivers
8. Screen rotation support (iio-sensor-proxy)
9. Initramfs rebuild for new kernel
10. GRUB configuration update with backup

**⚠️ REBOOT REQUIRED** after Phase 1 completes!

### Post-Phase-1: Calibrate IPTSD

After rebooting into the linux-surface kernel, **you must calibrate IPTSD** for optimal touch and stylus performance:

```bash
# Stop IPTSD service
sudo systemctl stop 'iptsd@*.service'

# Run calibration (follow on-screen instructions)
sudo iptsd-calibrate $(sudo iptsd-find-hidraw)

# Collect 3000-4000 samples by:
# - Touching with varying pressure
# - Placing all fingers simultaneously
# - Performing common gestures
# - Avoid palm contact during calibration

# Enable and start IPTSD
sudo systemctl enable iptsd@$(sudo iptsd-find-hidraw).service
sudo systemctl start iptsd@$(sudo iptsd-find-hidraw).service
```

### Phase 2: GNOME Tablet Interface (Automated)

Transform your Surface into a premium tablet experience!

```bash
# Run Phase 2 installation (after completing Phase 1 + reboot)
./scripts/phase2-gnome-tablet.sh
```

**What Phase 2 Includes:**

1. **GNOME Extensions**: Dash-to-Dock, GSConnect, tablet controls
2. **iPad-Like Gestures**: Touchégg with optimized response times
3. **Touch-Friendly Themes**: Materia theme, Papirus icons, larger fonts
4. **Virtual Keyboard**: Maliit keyboard with auto-show
5. **Tablet Apps**: Xournal++, Foliate, Drawing, GNOME apps
6. **Visual Polish**: Touch-optimized scaling, spacing, and sizing

**⚠️ LOG OUT REQUIRED** after extension installation (step 2)

The script will prompt you to log out after installing extensions. After logging back in, run the script again to complete remaining steps.

**Gesture Controls (After Phase 2):**

- **3-finger swipe up**: Show Activities Overview
- **3-finger swipe down**: Minimize window
- **3-finger swipe left/right**: Switch workspaces
- **4-finger pinch in**: Show desktop
- **2-finger tap**: Right-click
- **2-finger pinch**: Zoom in/out (in supporting apps)

**Browser-Specific:**
- **2-finger swipe left/right**: Back/forward navigation

## Repository Structure

```
surface-pro-6-arch-gnome/
├── scripts/
│   ├── phase1-essential-setup.sh    # Hardware support installation
│   ├── phase2-gnome-tablet.sh       # GNOME tablet interface setup
│   ├── enable-tablet-controls.sh    # Enable custom extension
│   └── install-wallpapers.sh        # Optional wallpaper install
├── docs/
│   ├── dash-to-panel-guide.md       # Dock customization guide
│   ├── tablet-controls-extension.md # Custom extension docs
│   ├── tablet-ui-customization.md   # Advanced GNOME theming
│   ├── power-management.md          # Battery optimization
│   ├── stylus-writing-guide.md      # Stylus app recommendations
│   ├── pdf-annotation-workflow.md   # PDF workflow with stylus
│   ├── emergency-recovery.md        # Recovery procedures
│   └── troubleshooting.md           # Common issues and solutions
├── QUICK-START.md                   # Quick setup validation
├── TABLET-CONTROLS-SETUP.md         # Extension setup guide
├── TEST-GESTURES.md                 # Gesture testing checklist
└── README.md                        # This file
```

## Hardware Support Status

| Component | Status | Notes |
|-----------|--------|-------|
| Touchscreen | ✅ Working | Requires IPTSD calibration |
| Stylus (Pressure) | ✅ Working | Full pressure sensitivity with IPTSD |
| Stylus (Tilt) | ✅ Working | Supported in compatible apps |
| Keyboard | ✅ Working | Type Cover fully functional |
| Trackpad | ✅ Working | Multitouch gestures supported |
| WiFi | ✅ Working | Requires linux-firmware-marvell |
| Bluetooth | ✅ Working | Fully functional |
| Screen Rotation | ✅ Working | Automatic with iio-sensor-proxy |
| Battery | ✅ Working | Accurate reporting |
| Cameras | ❌ Not Working | Intel IPU3 - detected but unusable, no Linux driver support |
| Fingerprint | ❌ Not Available | No built-in sensor (Type Cover accessory only) |
| Hibernate | ⚠️ Manual Setup | Requires swap configuration |
| Sleep/Suspend | ⚠️ Battery Drain | Use hibernate instead |

## Performance Expectations

With proper optimization:

- **Battery Life**: 5-7 hours active note-taking/writing
- **Stylus Latency**: <20ms (comparable to Windows)
- **Palm Rejection**: >95% effectiveness after IPTSD calibration
- **Boot Time**: ~15-20 seconds with SSD
- **Gesture Response**: <100ms (iPad-like smoothness)

## GNOME Extensions Included

- **Dash-to-Dock**: iPad-style bottom dock with transparency
- **GSConnect**: Android/iOS integration (SMS, notifications, file sharing)
- **Surface Tablet Controls**: Custom extension for touchscreen toggle
- **Screen Rotate**: Manual rotation controls
- **Hibernate Status**: Hibernate/suspend status in top bar

## Troubleshooting

**🚨 Graphics broken / Can't login after Phase 1:**
See emergency recovery guide: [docs/emergency-recovery.md](docs/emergency-recovery.md)
- Press `Ctrl+Alt+F2` for TTY access
- Boot old kernel from GRUB menu (press `Shift` during boot)

**Touchscreen not working after boot:**
```bash
sudo systemctl restart iptsd@*.service
```

**Gestures not working:**
```bash
sudo systemctl restart touchegg
```

**WiFi not connecting:**
```bash
sudo pacman -S linux-firmware-marvell
sudo reboot
```

**Extension not showing after Phase 2:**
```bash
# Log out and back in
# Or check extension status:
gnome-extensions list --enabled
gnome-extensions info dash-to-dock@micxgx.gmail.com
```

**Virtual keyboard not appearing:**
- Make sure you're on Wayland session (not X11)
- Check if Maliit is running: `ps aux | grep maliit`
- Restart: `pkill maliit-server && maliit-server &`

For detailed troubleshooting, see [docs/troubleshooting.md](docs/troubleshooting.md)

## Configuration Examples

Sample configurations are provided in the `docs/` directory:

- **IPTSD Calibration**: Palm rejection and stylus optimization
- **Power Profiles**: Battery saver, balanced, and performance modes
- **Gesture Customization**: Adding/modifying Touchégg gestures
- **Extension Configuration**: Dash-to-Dock, GSConnect, and more

## Roadmap

- [x] Phase 1: Essential hardware support automation
- [x] Phase 2: GNOME tablet interface with gestures
- [x] Custom tablet controls extension
- [x] Touch-optimized theme and scaling
- [x] Virtual keyboard integration (Maliit)
- [x] Comprehensive documentation
- [ ] Hibernate/suspend optimization guide
- [ ] Advanced gesture customization tool
- [ ] One-click backup/restore script
- [ ] Fedora/Ubuntu adaptation guide

## Contributing

Contributions are welcome! This project benefits from real-world testing and improvements.

**Ways to contribute:**
- Test scripts on your Surface Pro 6 and report issues
- Share your IPTSD calibration improvements
- Document GNOME extension configurations
- Submit configuration improvements
- Improve documentation

## Acknowledgments

This project builds upon:

- [linux-surface](https://github.com/linux-surface/linux-surface) - Surface hardware support
- [IPTSD](https://github.com/linux-surface/iptsd) - Touch and stylus processing
- [Touchégg](https://github.com/JoseExposito/touchegg) - Gesture recognition
- [auto-cpufreq](https://github.com/AdnanHodzic/auto-cpufreq) - Power management
- [Dash-to-Dock](https://github.com/micheleg/dash-to-dock) - GNOME dock extension

## Resources

- **linux-surface Wiki**: https://github.com/linux-surface/linux-surface/wiki
- **Community Support**: https://matrix.to/#/#linux-surface:matrix.org
- **r/SurfaceLinux**: https://reddit.com/r/SurfaceLinux
- **GNOME Extensions**: https://extensions.gnome.org
- **EndeavourOS Forums**: https://forum.endeavouros.com/

## License

MIT License - See [LICENSE](LICENSE) file for details

## Disclaimer

This software is provided as-is without warranty. Always backup your data before running system modification scripts. The author is not responsible for hardware damage or data loss.

---

**Status**: Active Development | **Last Updated**: 2025-11-12 | **Maintainer**: Your Name
