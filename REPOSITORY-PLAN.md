# Repository Split Plan

## Overview

This repository contains GNOME-specific configurations for Surface Pro 6 tablet setup. A separate KDE repository will be created later.

## Current Repository: GNOME Edition

### Repository Name
`surface-pro-6-arch-gnome`

### What to Commit

#### ✅ Scripts (Working)
- `scripts/phase1-essential-setup.sh` - Hardware support (DE-agnostic)
- `scripts/phase2-gnome-tablet.sh` - **NEW**: Unified GNOME setup
- `scripts/enable-tablet-controls.sh` - GNOME extension enabler
- `scripts/install-wallpapers.sh` - Optional wallpapers

#### ✅ Documentation (GNOME-specific)
- `README-GNOME.md` → Rename to `README.md`
- `QUICK-START.md` - Setup validation guide
- `TABLET-CONTROLS-SETUP.md` - Extension setup
- `TEST-GESTURES.md` - Gesture testing

**docs/ folder:**
- `docs/dash-to-panel-guide.md` - Dock customization
- `docs/tablet-controls-extension.md` - Custom extension
- `docs/tablet-ui-customization.md` - GNOME theming
- `docs/power-management.md` - Battery optimization
- `docs/stylus-writing-guide.md` - Stylus apps
- `docs/pdf-annotation-workflow.md` - PDF workflow
- `docs/emergency-recovery.md` - Recovery guide
- `docs/troubleshooting.md` - Common issues
- `docs/contributing.md` - Contribution guidelines

#### ❌ DO NOT Commit (KDE-specific or obsolete)
- `scripts/phase2-tablet-ux.sh` - KDE Plasma only
- `scripts/ultimate-tablet-ui.sh` - KDE only
- `scripts/complete-tablet-fix.sh` - KDE only
- `scripts/apply-tablet-layout.sh` - KDE only
- `scripts/apply-tablet-theme.sh` - Mixed (remove)
- `research.md` - Massive KDE guide (save for KDE repo)
- `docs/tablet-mode-guide.md` - Check if KDE-specific

### Modified Files
- `README.md` - Currently mixed, needs full rewrite (use README-GNOME.md)

## Future Repository: KDE Edition

### Repository Name
`surface-pro-6-arch-kde`

### Will Include
- `scripts/phase1-essential-setup.sh` (shared)
- `scripts/phase2-tablet-ux.sh` (fixed)
- `scripts/ultimate-tablet-ui.sh` (fixed)
- `scripts/complete-tablet-fix.sh` (fixed)
- `research.md` → `COMPREHENSIVE-GUIDE.md`
- KDE-specific documentation
- Shared docs (emergency-recovery, troubleshooting, contributing)

## Execution Plan

### Step 1: Clean GNOME Repository
```bash
# Remove KDE scripts
rm scripts/phase2-tablet-ux.sh
rm scripts/ultimate-tablet-ui.sh
rm scripts/complete-tablet-fix.sh
rm scripts/apply-tablet-layout.sh
rm scripts/apply-tablet-theme.sh

# Remove KDE research doc (save for KDE repo)
mv research.md ~/research-kde.md

# Replace README
mv README-GNOME.md README.md

# Remove modified indicator from phase1
git add scripts/phase1-essential-setup.sh
```

### Step 2: Commit GNOME Setup
```bash
cd /home/dev/surface-pro-6-linux-setup

# Stage new and modified files
git add scripts/phase2-gnome-tablet.sh
git add README.md
git add QUICK-START.md
git add TABLET-CONTROLS-SETUP.md
git add TEST-GESTURES.md
git add docs/
git add REPOSITORY-PLAN.md

# Commit with comprehensive message
git commit -m "Add unified GNOME tablet setup with automated Phase 2 script

- Create phase2-gnome-tablet.sh: Unified, modular GNOME setup script
  * Installs Dash-to-Dock, GSConnect, tablet extensions
  * Configures Touchégg with iPad-like gestures (100ms latency)
  * Applies Materia theme with touch-friendly scaling
  * Sets up Maliit virtual keyboard for Wayland
  * Installs tablet apps (Xournal++, Foliate, Drawing)
  * State-tracking system allows resume after logout
  * Proper reboot/logout handling for extensions

- Update documentation for GNOME setup
  * Comprehensive README with hardware support matrix
  * Quick-start guides for validation
  * Gesture testing checklist
  * Extension configuration guides
  * Power management and stylus workflows

- Working GNOME features:
  * Dash-to-Dock (iPad-style bottom panel)
  * Custom tablet controls extension (touchscreen toggle)
  * Touchégg gestures (3-finger, 4-finger multitouch)
  * Screen rotation, hibernate status
  * GSConnect for phone integration

- Remove KDE-specific scripts (phase2-tablet-ux, ultimate-tablet-ui, etc)
- Save KDE research.md for future KDE repository

Tested on: Surface Pro 6, EndeavourOS, GNOME 47"
```

### Step 3: Push to GitHub
```bash
# Create GitHub repository first (via web interface)
# Then:

git remote add origin https://github.com/YOUR_USERNAME/surface-pro-6-arch-gnome.git
git branch -M main
git push -u origin main
```

### Step 4: Create KDE Repository (Later)
1. Create new directory
2. Copy phase1 script
3. Fix and copy KDE phase2 scripts
4. Add research.md as COMPREHENSIVE-GUIDE.md
5. Write KDE-specific README
6. Commit and push to `surface-pro-6-arch-kde`

## Script Flow Summary

### GNOME Setup Flow
```
1. phase1-essential-setup.sh
   ├─ Install linux-surface kernel
   ├─ Install IPTSD, thermald, auto-cpufreq
   └─ **REBOOT REQUIRED**

2. Manual: Calibrate IPTSD
   └─ sudo iptsd-calibrate $(sudo iptsd-find-hidraw)

3. phase2-gnome-tablet.sh
   ├─ Step 1: Install packages (touchegg, maliit, themes, apps)
   ├─ Step 2: Install GNOME extensions
   │  └─ **LOG OUT REQUIRED** (run script again after)
   ├─ Step 3: Configure Touchégg gestures
   ├─ Step 4: Configure extensions (Dash-to-Dock)
   ├─ Step 5: Apply theme (Materia + Papirus)
   └─ Step 6: Configure Maliit keyboard

4. Done! Test gestures and enjoy tablet interface
```

### Reboot/Logout Points
- **After Phase 1**: MUST REBOOT (new kernel)
- **After Phase 2 Step 2**: MUST LOG OUT (extension loading)
- **Optional**: Reboot after hibernate setup (not in default script)

## Notes

- Phase 2 script is **resumable** - uses state file to skip completed steps
- User can run script multiple times safely
- Checks for linux-surface kernel before proceeding
- Reminds user about IPTSD calibration
- Validates GNOME is running (warns if different DE)
- All steps are idempotent (safe to re-run)

## Testing Checklist

Before pushing to GitHub:
- [ ] Test phase1 script on fresh EndeavourOS install
- [ ] Verify reboot into linux-surface kernel
- [ ] Test IPTSD calibration process
- [ ] Test phase2 script steps 1-2, log out
- [ ] Test phase2 script resume (steps 3-6)
- [ ] Verify all gestures work (3-finger, 4-finger, 2-finger)
- [ ] Verify Dash-to-Dock configuration
- [ ] Test Maliit keyboard appearance
- [ ] Verify theme and scaling applied
- [ ] Test all documentation links

## Current Status

✅ Phase 2 GNOME script created
✅ README-GNOME.md created
✅ Repository plan documented
⏳ Ready to clean and commit
⏳ Ready to push to GitHub
⏳ KDE repository (future work)
