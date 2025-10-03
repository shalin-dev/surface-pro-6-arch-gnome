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

## Repository Structure

```
surface-pro-6-linux-setup/
├── scripts/
│   ├── phase1-essential-setup.sh    # Automated core installation
│   └── phase2-customization.sh      # Advanced features (coming soon)
├── configs/
│   ├── iptsd/                       # Touch and stylus configurations
│   ├── auto-cpufreq/                # Power management profiles
│   ├── kde/                         # KDE Plasma tablet mode scripts
│   └── ollama/                      # AI assistant optimization
├── docs/
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

For detailed troubleshooting, see [docs/troubleshooting.md](docs/troubleshooting.md)

## Roadmap

- [x] Phase 1: Essential hardware support automation
- [ ] Phase 2: Advanced customization script
- [ ] IPTSD config templates for different use cases
- [ ] KDE tablet mode automation scripts
- [ ] Ollama integration for offline AI
- [ ] Comprehensive troubleshooting guide
- [ ] Battery optimization profiles
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
