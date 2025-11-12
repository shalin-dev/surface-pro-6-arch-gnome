# Surface Pro 6 Stylus and Writing Guide

## Installed Writing Applications

### Handwriting & Note-Taking
- **Rnote** - Native handwriting app optimized for stylus input
  - Launch: `rnote` or find in Applications
  - Features: Pressure sensitivity, infinite canvas, PDF export

- **Xournal++** - Professional PDF annotation and note-taking
  - Launch: `xournalpp`
  - Features: PDF annotation, pressure-sensitive drawing, multiple page support

- **Krita** - Digital painting and illustration
  - Launch: `krita`
  - Features: Advanced brush engine, layer support, pen pressure mapping

### Drawing & Design
- **Inkscape** - Vector graphics editor
  - Launch: `inkscape`
  - Features: SVG editing, bezier curves, pen tool support

- **Kolourpaint** - Simple painting and image editing
  - Launch: `kolourpaint`
  - Features: Quick sketches, basic image editing

- **Draw.io** - Diagram and flowchart creation
  - Launch: `drawio` or find "diagrams.net"
  - Features: Flowcharts, UML diagrams, network diagrams

## Surface Pen Configuration

### Hardware Features
- **Pressure Sensitivity**: 4096 levels supported
- **Tilt Detection**: Supported via IPTS drivers
- **Palm Rejection**: Automatically enabled
- **Eraser Button**: Top button acts as eraser in compatible apps

### Current Settings (/etc/iptsd.conf)
- `DisableOnPalm = true` - Touchscreen disabled when palm detected
- `DisableOnStylus = false` - Touch and pen work together (only palm rejected)
- `TipDistance = 0.0` - Tip offset calibration

**Why DisableOnStylus = false?**
When set to `true`, ALL touch input stops when the pen is near the screen. This is too aggressive - you can't use UI buttons or scroll while holding the pen. With it set to `false`, you can use touch and pen together, and palm rejection still works perfectly.

### Testing Pen Pressure
1. Open Rnote or Xournal++
2. Select a brush/pen tool
3. Draw with varying pressure
4. Verify line thickness changes with pressure

### Palm Rejection Test
1. Open any writing app
2. Rest your palm on screen while writing
3. Touch inputs should be ignored while pen is active
4. Only stylus should register

## Recommended Workflow

### For Note-Taking
1. **Rnote** - Best for quick handwritten notes
   - Infinite canvas
   - Simple interface
   - Export to PDF/SVG

2. **Xournal++** - Best for annotating PDFs
   - Import existing PDFs
   - Add handwritten notes
   - Export annotated PDF

### For Drawing/Sketching
1. **Krita** - Professional digital art
   - Full pressure sensitivity
   - Custom brush settings
   - Layer support

2. **Inkscape** - Vector illustrations
   - Pen tool for precise curves
   - Scalable graphics

### For Diagrams
1. **Draw.io** - Technical diagrams
   - Flowcharts
   - Architecture diagrams
   - Can be used with stylus for freehand shapes

## GNOME Tablet Features

### On-Screen Keyboard
- Automatically shows when tapping text fields
- Hides when Bluetooth keyboard connected
- No need to toggle manually

### Window Management
- Maximize apps for full tablet experience
- Use 3-finger swipe to switch workspaces
- Touch-friendly window controls

## Troubleshooting

### Pen Not Working
```bash
# Check if iptsd is detecting pen
libinput list-devices | grep -A 10 "IPTS"

# Check tablet devices in XWayland
xinput list | grep -i tablet
```

### No Pressure Sensitivity
1. Ensure app supports pressure (Rnote, Xournal++, Krita do)
2. Check pen battery (AAAA battery in Surface Pen)
3. Test in multiple apps to isolate issue

### Palm Rejection Issues
- Check `/etc/iptsd.conf` has `DisableOnPalm = true`
- Restart if needed: `sudo systemctl restart system-iptsd.slice`

## Tips for Best Experience

1. **Calibrate your stylus** in each app's preferences
2. **Disable touch scrolling** in writing apps to prevent accidental input
3. **Use full-screen mode** for distraction-free writing
4. **Create keyboard shortcuts** for frequently used tools
5. **Adjust pen tip pressure curves** in Krita for your preference

## Next Steps

- Test all apps with Surface Pen
- Configure custom brushes in Krita
- Set up PDF annotation workflow in Xournal++
- Create templates in Rnote for different note types
