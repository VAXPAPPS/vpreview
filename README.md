# vpreview

**vpreview** is a modern and powerful document viewer application built with **Flutter** for **Linux**, featuring a sleek Glassmorphism UI and a professional user experience.

The application supports viewing PDF files, images, code (with syntax highlighting), and Markdown files in a beautifully formatted way.

## ✨ Key Features

*   **Tabbed Interface:** Open and view multiple documents simultaneously with easy navigation.
*   **File Explorer:** Integrated sidebar for quick and hierarchical file system browsing.
*   **Modern Glassmorphism UI:** Transparent, modern interface with eye-pleasing blur effects.
*   **Broad File Support:**
    *   📄 **PDF:** View, zoom, and navigate pages.
    *   🖼️ **Images:** View images (PNG, JPG, BMP, WEBP) with high-quality zoom.
    *   📝 **Markdown:** Formatted rendering for headers, lists, code blocks, and tables.
    *   💻 **Code & Text:** Read-only text editor with syntax highlighting for multiple languages (Dart, Python, JS, etc.).
*   **Advanced Search:** In-file text search with result highlighting and navigation (Ctrl+F).
*   **Recent Files:** Quick access to recently opened files from the Welcome page.
*   **Keyboard Shortcuts:** Enhanced productivity with intuitive shortcuts.
*   **Drag & Drop:** Simply drag files into the app to open them instantly.

---

## 🚀 Keyboard Shortcuts

| Shortcut | Function |
| :--- | :--- |
| `Ctrl + O` | Open File |
| `Ctrl + W` | Close Current Tab |
| `Ctrl + F` | Toggle Search Bar |
| `Ctrl + =` | Zoom In |
| `Ctrl + -` | Zoom Out |
| `Ctrl + 0` | Reset Zoom |
| `F11` | Toggle Fullscreen |
| `Esc` | Close Search |

---

## 🛠️ Tech Stack

This project is built following **Clean Architecture** principles and uses modern libraries:

*   **Framework:** Flutter (Linux Desktop)
*   **State Management:** flutter_bloc
*   **Architecture:** Clean Architecture (Domain, Data, Application, Presentation Layers)
*   **PDF Rendering:** pdfrx
*   **Markdown:** flutter_markdown
*   **Syntax Highlighting:** flutter_highlight
*   **Window Management:** window_manager

## 📦 Installation & Running

1. **Prerequisites:** Ensure Flutter SDK and Linux requirements (GTK, Clang, CMake, Ninja) are installed.
2. **Get Dependencies:**
   ```bash
   flutter pub get
   ```
3. **Run:**
   ```bash
   flutter run -d linux
   ```

---

This project is part of the VAXP organization


