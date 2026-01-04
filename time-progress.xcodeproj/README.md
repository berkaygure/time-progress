# Time Progress - macOS Menu Bar App

A beautiful and customizable day progress tracker for macOS that lives in your menu bar.

![macOS](https://img.shields.io/badge/macOS-14.0+-blue.svg)
![Swift](https://img.shields.io/badge/Swift-5.9+-orange.svg)
![License](https://img.shields.io/badge/license-MIT-green.svg)

## Features

✨ **Real-time Progress Tracking**
- Visual progress bar in the menu bar
- Circular progress indicator in popup
- Updates every second for accurate tracking

⚙️ **Customizable Settings**
- Set custom start and end times for your day
- Choose from 10 color themes (including gradient)
- Toggle between time remaining or percentage display
- System theme support (auto light/dark mode)

🎨 **Beautiful Design**
- Rounded progress bar with smooth animations
- Card-based time info display
- Native macOS appearance
- Liquid glass design elements

🚀 **Menu Bar Only**
- No dock icon clutter
- Quick access from menu bar
- Persistent settings
- Minimal resource usage

## Screenshots

### Menu Bar
The progress bar shows your day's progress at a glance with remaining time or percentage.

### Popup View
Click the menu bar icon to see detailed progress with elapsed and remaining time in beautiful cards.

### Settings
Customize your experience with color themes, display modes, and custom work hours.

## Installation

1. Clone this repository
2. Open `time-progress.xcodeproj` in Xcode
3. Build and run (⌘R)
4. The app will appear in your menu bar

## Requirements

- macOS 14.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later

## Usage

### First Launch
1. Click the menu bar icon
2. Open Settings
3. Set your work hours (default: 9 AM - 5 PM)
4. Choose your preferred color and display mode

### Features Explained

**Display Modes:**
- **Time Remaining**: Shows hours and minutes left (e.g., "3h 15m")
- **Percentage**: Shows completion percentage (e.g., "45%")

**Color Themes:**
- System (adapts to light/dark mode)
- Blue, Purple, Pink, Red, Orange, Yellow, Green, Teal
- Blue-Purple Gradient

## Project Structure

```
time-progress/
├── time_progressApp.swift      # Main app entry point
├── AppDelegate.swift            # Menu bar management
├── DayProgressManager.swift     # Progress calculation logic
├── MenuBarView.swift            # Popup view
├── SettingsView.swift           # Settings interface
└── ContentView.swift            # Initial view (unused)
```

## Technical Details

### Architecture
- **SwiftUI** for modern UI
- **AppKit** for menu bar integration
- **Combine** for reactive updates
- **UserDefaults** for persistent settings

### Key Components
- Real-time progress calculation
- Custom NSStatusItem with attributed strings
- Gradient and solid color support
- Popover with delegate pattern
- Theme-aware color system

## Configuration

All settings are automatically saved and persisted:
- Start time
- End time
- Progress bar color
- Display mode (time/percentage)

## Building from Source

```bash
# Clone the repository
git clone https://github.com/berkaygure/time-progress.git

# Open in Xcode
cd time-progress
open time-progress.xcodeproj

# Build and run
# Press ⌘R in Xcode
```

## Contributing

Contributions are welcome! Feel free to:
- Report bugs
- Suggest new features
- Submit pull requests

## Future Enhancements

- [ ] Week/month/year progress tracking
- [ ] Multiple custom time periods
- [ ] Keyboard shortcuts
- [ ] Notifications at milestones
- [ ] Export progress data
- [ ] Widget support

## License

This project is licensed under the MIT License - see the LICENSE file for details.

## Credits

Created by Berkay Güre - January 2026

## Support

If you find this app useful, please star the repository! ⭐

---

**Note**: This is a menu bar-only application. It will not appear in your Dock or application switcher.
