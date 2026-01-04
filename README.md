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

## Screenshots

### Menu Bar
The progress bar shows your day's progress at a glance with remaining time or percentage.

<img width="125" height="30" alt="Screenshot 2026-01-04 at 20 30 00" src="https://github.com/user-attachments/assets/adf2ad85-42b4-40f6-a898-e0846372ac24" />

### Popup View
Click the menu bar icon to see detailed progress with elapsed and remaining time in beautiful cards.
<img width="334" height="493" alt="Screenshot 2026-01-04 at 20 30 16" src="https://github.com/user-attachments/assets/1f712cb0-3dc9-4b1d-a57b-7c8380dc7ed3" />

### Settings
Customize your experience with color themes, display modes, and custom work hours.
<img width="477" height="558" alt="Screenshot 2026-01-04 at 20 27 43" src="https://github.com/user-attachments/assets/94f43279-483f-4322-9811-a7332e5eb776" />

## Installation

### DMG

You can download DM from the [releases](https://github.com/berkaygure/time-progress/releases) page.

### Manuel

1. Clone this repository
2. Open `time-progress.xcodeproj` in Xcode
3. Build and run (⌘R)
4. The app will appear in your menu bar

## Requirements

- macOS 14.0 or later
- Xcode 15.0 or later
- Swift 5.9 or later

### Features Explained

**Display Modes:**
- **Time Remaining**: Shows hours and minutes left (e.g., "3h 15m")
- **Percentage**: Shows completion percentage (e.g., "45%")

**Color Themes:**
- System (adapts to light/dark mode)
- Blue, Purple, Pink, Red, Orange, Yellow, Green, Teal
- Blue-Purple Gradient

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


