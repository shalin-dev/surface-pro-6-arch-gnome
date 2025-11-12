# Surface Pro 6 Linux Setup

Comprehensive setup scripts and configuration files for running Linux on Microsoft Surface Pro 6 devices. This repository provides automated installation, optimization guides, and essential configurations to transform your Surface Pro 6 into a fully functional Linux workstation with proper touchscreen, stylus, and tablet mode support.

## Overview

The Microsoft Surface Pro 6 is a capable 2-in-1 device that can run Linux with proper hardware support through the [linux-surface](https://github.com/linux-surface/linux-surface) project. This repository streamlines the setup process with automated scripts, tested configurations, and comprehensive documentation.

**Target Distribution:** EndeavourOS / Arch Linux (can be adapted for other distributions)

**Tested Hardware:** Surface Pro 6 (i5-8250U, 8GB RAM)

## Features

- **Automated Phase 1 Setup**: One-command installation of essential Surface hardware support
- **Touchscreen & Stylus**: Full IPTSD integration with pressure sensitivity
- **Power Management**: Optimized battery life with auto-cpufreq
- **Thermal Management**: Proper cooling with thermald
- **Screen Rotation**: Automatic orientation detection
- **Tablet Mode**: KDE Plasma optimizations for touch input

## Quick Start

### Prerequisites

- EndeavourOS or Arch-based distribution installed
- Internet connection
- Sudo privileges

### ⚠️ Safety First

**Before running Phase 1/Phase 2:**
- Create a system backup/snapshot (Timeshift recommended)
- Know how to access TTY: `Ctrl+Alt+F2`
- Read the recovery guide: [docs/emergency-recovery.md](docs/emergency-recovery.md)

**Your old kernel will remain bootable** - if graphics break, press `Shift` during boot to select it from GRUB.

### Phase 1: Essential Setup (Automated)

```bash
# Clone this repository
git clone https://github.com/YOUR_USERNAME/surface-pro-6-linux-setup.git
cd surface-pro-6-linux-setup

# Run Phase 1 installation
./scripts/phase1-essential-setup.sh
```

**What Phase 1 Installs:**

1. linux-surface kernel and headers
2. IPTSD (Intel Precise Touch & Stylus Daemon)
3. Wacom and stylus drivers (libwacom, xf86-input-wacom)
4. Thermal management (thermald)
5. Power management (auto-cpufreq, powertop)
6. Bluetooth support (bluez, bluez-utils)
7. Intel graphics drivers (mesa, vulkan-intel, intel-media-driver)
8. Screen rotation support (iio-sensor-proxy)
9. Initramfs rebuild for new kernel
10. GRUB configuration update with backup

### Post-Installation

After running Phase 1 and rebooting, you must **calibrate IPTSD** for optimal touch and stylus performance:

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

### Phase 2: Tablet UI/UX Optimization (Automated)

Transform your Surface Pro 6 into a premium tablet experience inspired by Samsung Galaxy Tab and iPad!

```bash
# Run Phase 2 installation (after completing Phase 1)
./scripts/phase2-tablet-ux.sh
```

**What Phase 2 Includes:**

1. **Touch-Optimized Themes**: Sweet KDE theme, Papirus icons, larger fonts
2. **Gesture Navigation**: iPad-style multi-touch gestures (3-finger swipe, 4-finger pinch)
3. **Virtual Keyboard**: Maliit keyboard with auto-show on text fields
4. **Tablet Mode Automation**: Scripts to switch between tablet and desktop layouts
5. **Visual Polish**: Rounded corners, blur effects, smooth animations
6. **DeX-Style Mode Switching**: Automatic layout change when keyboard is attached/detached
7. **Config Deployment**: IPTSD stylus optimization and power management profiles

**Gesture Controls (After Phase 2):**

- **3-finger swipe up**: Maximize/restore window
- **3-finger swipe down**: Minimize window
- **3-finger swipe left/right**: Switch workspaces
- **4-finger pinch in**: Show desktop
- **4-finger swipe up**: Task switcher
- **2-finger tap**: Right click

**Manual Switching:**

```bash
# Switch to tablet mode (touch-optimized, larger UI)
surface-tablet-mode

# Switch to desktop mode (keyboard + mouse optimized)
surface-desktop-mode
```

## Repository Structure

```
surface-pro-6-linux-setup/
├── scripts/
│   ├── phase1-essential-setup.sh    # Automated core installation
│   └── phase2-tablet-ux.sh          # Tablet UI/UX optimization
├── configs/
│   ├── iptsd/                       # Touch and stylus configurations
│   ├── auto-cpufreq/                # Power management profiles
│   ├── kde/                         # KDE Plasma tablet mode scripts
│   └── ollama/                      # AI assistant optimization
├── docs/
│   ├── tablet-mode-guide.md         # Complete tablet mode usage guide
│   ├── troubleshooting.md           # Common issues and solutions
│   ├── battery-optimization.md      # Power saving techniques
│   └── contributing.md              # How to contribute
├── README.md                        # This file
└── LICENSE                          # MIT License
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
| Cameras | ❌ Not Working | Intel ISP driver limitations |
| Hibernate | ⚠️ Manual Setup | Requires swap configuration |
| Sleep/Suspend | ⚠️ Battery Drain | Use hibernate instead (~30% overnight drain) |

## Performance Expectations

With proper optimization:

- **Battery Life**: 5-7 hours active note-taking/writing
- **Stylus Latency**: <20ms (comparable to Windows)
- **Palm Rejection**: >95% effectiveness after IPTSD calibration
- **Boot Time**: ~15-20 seconds with SSD

## Configuration Examples

Sample configurations are provided in the `configs/` directory:

- **IPTSD Calibration**: Optimized palm rejection and stylus settings
- **Power Profiles**: Battery saver, balanced, and performance modes
- **KDE Tablet Mode**: Auto-switching between laptop and tablet layouts
- **Ollama AI**: Memory-optimized settings for 8GB RAM

## Troubleshooting

**🚨 Graphics broken / Can't login after Phase 1:**
See emergency recovery guide: [docs/emergency-recovery.md](docs/emergency-recovery.md)
- Press `Ctrl+Alt+F2` for TTY access
- Boot old kernel from GRUB menu (press `Shift` during boot)

**Touchscreen not working after boot:**
```bash
sudo systemctl restart iptsd@*.service
```

**WiFi not connecting:**
```bash
sudo pacman -S linux-firmware-marvell
sudo reboot
```

**Battery draining during sleep:**
Configure hibernate instead of suspend (see docs/battery-optimization.md)

**Tablet mode questions:**
See complete guide at [docs/tablet-mode-guide.md](docs/tablet-mode-guide.md)

For detailed troubleshooting, see [docs/troubleshooting.md](docs/troubleshooting.md)

## Roadmap

- [x] Phase 1: Essential hardware support automation
- [x] Phase 2: Tablet UI/UX optimization (Samsung/iPad-style)
- [x] IPTSD config templates for different use cases
- [x] KDE tablet mode automation scripts
- [x] Gesture navigation (Touchégg)
- [x] Virtual keyboard integration (Maliit)
- [ ] Ollama integration for offline AI
- [ ] Comprehensive troubleshooting guide expansion
- [ ] Battery optimization profiles (additional modes)
- [ ] Fedora/Ubuntu adaptation guide

## Contributing

Contributions are welcome! This project benefits from real-world testing and improvements from the community.

**Ways to contribute:**
- Test scripts on your Surface Pro 6 and report issues
- Share your IPTSD calibration values
- Document hardware quirks or workarounds
- Submit configuration improvements
- Improve documentation

See [docs/contributing.md](docs/contributing.md) for detailed guidelines.

## Acknowledgments

This project builds upon the excellent work of:

- [linux-surface](https://github.com/linux-surface/linux-surface) - Surface hardware support
- [IPTSD](https://github.com/linux-surface/iptsd) - Touch and stylus processing
- [auto-cpufreq](https://github.com/AdnanHodzic/auto-cpufreq) - Power management

## Resources

- **linux-surface Wiki**: https://github.com/linux-surface/linux-surface/wiki
- **Community Support**: https://matrix.to/#/#linux-surface:matrix.org
- **r/SurfaceLinux**: https://reddit.com/r/SurfaceLinux
- **EndeavourOS Forums**: https://forum.endeavouros.com/

## License

MIT License - See [LICENSE](LICENSE) file for details

## Disclaimer

This software is provided as-is without warranty. Always backup your data before running system modification scripts. The author is not responsible for hardware damage or data loss.

---

**Status**: Active Development | **Last Updated**: 2025-10-03 | **Maintainer**: Shalin
