# PDF Annotation Workflow Guide

## Installed PDF Tools

### PDF Annotation
1. **Xournal++** (Recommended for handwriting)
   - Best for: Adding handwritten notes, sketches, highlighting
   - Features: Pressure-sensitive pen, multiple layers, shape tools
   - Launch: `xournalpp`

2. **Okular** (KDE PDF viewer)
   - Best for: Quick annotations, form filling, text highlighting
   - Features: Text annotations, drawing tools, stamps
   - Launch: `okular`

3. **Evince** (GNOME Document Viewer)
   - Best for: Simple viewing and basic annotations
   - Features: Highlighting, text notes
   - Launch: `evince`

### PDF Organization
- **PDFArranger**
  - Merge, split, rotate, and rearrange PDF pages
  - Drag-and-drop interface
  - Launch: `pdfarranger`

## Workflows

### Workflow 1: Annotating Research Papers

1. **Open PDF in Xournal++**
   ```bash
   xournalpp document.pdf
   ```

2. **Add Handwritten Notes**
   - Use Surface Pen to write directly on PDF
   - Pressure sensitivity allows natural writing
   - Different pen colors for categories

3. **Highlight Key Sections**
   - Use highlighter tool
   - Color-code by topic
   - Add margin notes

4. **Export Annotated PDF**
   - File → Export to PDF
   - Keeps original + annotations

### Workflow 2: Filling Forms

1. **Open in Okular**
   ```bash
   okular form.pdf
   ```

2. **Fill Text Fields**
   - Use on-screen keyboard for typing
   - Or use Surface Pen to handwrite in fields

3. **Sign Documents**
   - Tools → Add Signature
   - Draw signature with Surface Pen
   - Place signature where needed

4. **Save**
   - File → Save As (creates new annotated copy)

### Workflow 3: Creating Study Notes

1. **Import PDF to Xournal++**
   - Load textbook chapter or slides

2. **Add Note Pages**
   - Paper → Append New Page
   - Use blank pages for summaries

3. **Link Notes to Content**
   - Write notes next to relevant sections
   - Use arrows and shapes to connect ideas

4. **Export Combined Document**
   - Original PDF + handwritten notes in one file

### Workflow 4: Organizing PDFs

1. **Open PDFArranger**
   ```bash
   pdfarranger
   ```

2. **Load Multiple PDFs**
   - Drag and drop files

3. **Rearrange Pages**
   - Drag pages between documents
   - Delete unwanted pages
   - Rotate pages

4. **Save Merged PDF**
   - File → Save

## Quick Start Commands

```bash
# Annotate a PDF with handwriting
xournalpp document.pdf

# View and highlight PDF
evince document.pdf

# Organize multiple PDFs
pdfarranger

# Advanced annotation with forms
okular document.pdf
```

## Tips for Surface Pen PDF Annotation

### In Xournal++
1. **Configure Pen Settings**
   - Edit → Preferences → Stylus
   - Enable "Use Stylus as Pen"
   - Set pressure sensitivity curve

2. **Quick Tool Switching**
   - Top button: Switch to eraser
   - Side button: Context menu (if supported)

3. **Layer Management**
   - Keep annotations on separate layer
   - Can show/hide without affecting original

### In Okular
1. **Enable Annotation Tools**
   - Settings → Configure Okular → Annotations
   - Customize toolbar with frequently used tools

2. **Custom Stamps**
   - Create custom stamps (checkmarks, stamps, etc.)
   - Useful for reviewing documents

### General Tips
1. **Use landscape orientation** for wider writing space
2. **Zoom in** to write smaller, more precise notes
3. **Export regularly** to avoid losing work
4. **Name files descriptively**: `document_annotated_2025-10-18.pdf`

## Keyboard Shortcuts (Xournal++)

- `Ctrl + N`: New page
- `Ctrl + S`: Save
- `Ctrl + Z`: Undo
- `Ctrl + Y`: Redo
- `P`: Pen tool
- `E`: Eraser tool
- `H`: Highlighter
- `S`: Select tool
- `I`: Image tool
- `T`: Text tool

## Integration with Other Apps

### Send PDF to Annotation
From file manager:
- Right-click PDF → Open With → Xournal++

### Export Options
- **Xournal++ native (.xopp)**: Editable, keeps layers
- **PDF**: Flattened for sharing
- **SVG**: Vector format for editing in Inkscape
- **PNG**: Image export for specific pages

## Cloud Sync Recommendations

While not installed by default, consider:
- Syncthing for P2P sync
- Nextcloud client for self-hosted cloud
- rclone for various cloud providers

This keeps annotated PDFs synced across devices.

## Troubleshooting

### Pen pressure not working in PDF apps
- Xournal++: Check Edit → Preferences → Stylus
- Restart app after plugging/unplugging Type Cover

### Annotations not saving
- Make sure to explicitly save/export
- Some viewers (Evince) have limited save options
- Use Xournal++ for permanent annotations

### PDF opens in wrong app
Set default:
```bash
# Set Xournal++ as default for PDFs
xdg-mime default com.github.xournalpp.xournalpp.desktop application/pdf
```

## Next Steps

1. Test annotation workflow with a sample PDF
2. Configure Xournal++ pen pressure to preference
3. Create templates for common note-taking scenarios
4. Set up file organization system for annotated documents
