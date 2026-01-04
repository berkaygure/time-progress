//
//  DayProgressManager.swift
//  time-progress
//
//  Created by Berkay Güre on 4.01.2026.
//

import Foundation
import Combine
import AppKit

enum ProgressBarColor: String, CaseIterable, Identifiable {
    case system = "System"
    case blue = "Blue"
    case purple = "Purple"
    case pink = "Pink"
    case red = "Red"
    case orange = "Orange"
    case yellow = "Yellow"
    case green = "Green"
    case teal = "Teal"
    case gradient = "Blue-Purple Gradient"
    
    var id: String { rawValue }
    
    func nsColor(isDarkMode: Bool) -> NSColor {
        switch self {
        case .system:
            return isDarkMode ? .white : .black
        case .blue:
            return .systemBlue
        case .purple:
            return .systemPurple
        case .pink:
            return .systemPink
        case .red:
            return .systemRed
        case .orange:
            return .systemOrange
        case .yellow:
            return .systemYellow
        case .green:
            return .systemGreen
        case .teal:
            return .systemTeal
        case .gradient:
            return .systemBlue // Will use gradient
        }
    }
}

enum MenuBarDisplayMode: String, CaseIterable, Identifiable {
    case remaining = "Time Remaining"
    case percentage = "Percentage"
    
    var id: String { rawValue }
}

class DayProgressManager: ObservableObject {
    static let shared = DayProgressManager()
    
    @Published var startTime: Date
    @Published var endTime: Date
    @Published var currentProgress: Double = 0.0
    @Published var progressBarColor: ProgressBarColor
    @Published var displayMode: MenuBarDisplayMode
    @Published var barWidth: Double
    @Published var barHeight: Double
    
    private let startTimeKey = "dayStartTime"
    private let endTimeKey = "dayEndTime"
    private let colorKey = "progressBarColor"
    private let displayModeKey = "menuBarDisplayMode"
    private let barWidthKey = "progressBarWidth"
    private let barHeightKey = "progressBarHeight"
    
    init() {
        // Load saved times or use defaults (9 AM to 5 PM)
        let calendar = Calendar.current
        let now = Date()
        
        if let savedStart = UserDefaults.standard.object(forKey: startTimeKey) as? Date {
            startTime = savedStart
        } else {
            startTime = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: now) ?? now
        }
        
        if let savedEnd = UserDefaults.standard.object(forKey: endTimeKey) as? Date {
            endTime = savedEnd
        } else {
            endTime = calendar.date(bySettingHour: 17, minute: 0, second: 0, of: now) ?? now
        }
        
        // Load saved color or use system default
        if let savedColorString = UserDefaults.standard.string(forKey: colorKey),
           let savedColor = ProgressBarColor(rawValue: savedColorString) {
            progressBarColor = savedColor
        } else {
            progressBarColor = .system
        }
        
        // Load saved display mode or use remaining time default
        if let savedModeString = UserDefaults.standard.string(forKey: displayModeKey),
           let savedMode = MenuBarDisplayMode(rawValue: savedModeString) {
            displayMode = savedMode
        } else {
            displayMode = .remaining
        }
        
        // Load saved bar dimensions or use defaults
        let savedWidth = UserDefaults.standard.double(forKey: barWidthKey)
        barWidth = savedWidth > 0 ? savedWidth : 45.0  // Default: 45
        
        let savedHeight = UserDefaults.standard.double(forKey: barHeightKey)
        barHeight = savedHeight > 0 ? savedHeight : 14.0  // Default: 14
        
        updateProgress()
    }
    
    func updateProgress() {
        let calendar = Calendar.current
        let now = Date()
        
        // Get today's start and end times
        let startComponents = calendar.dateComponents([.hour, .minute], from: startTime)
        let endComponents = calendar.dateComponents([.hour, .minute], from: endTime)
        
        guard let todayStart = calendar.date(bySettingHour: startComponents.hour ?? 9,
                                             minute: startComponents.minute ?? 0,
                                             second: 0,
                                             of: now),
              let todayEnd = calendar.date(bySettingHour: endComponents.hour ?? 17,
                                           minute: endComponents.minute ?? 0,
                                           second: 0,
                                           of: now) else {
            currentProgress = 0.0
            return
        }
        
        // Calculate progress
        let totalDuration = todayEnd.timeIntervalSince(todayStart)
        let elapsed = now.timeIntervalSince(todayStart)
        
        if elapsed < 0 {
            // Before start time
            currentProgress = 0.0
        } else if elapsed > totalDuration {
            // After end time
            currentProgress = 1.0
        } else {
            // During the day
            currentProgress = elapsed / totalDuration
        }
    }
    
    func saveStartTime(_ time: Date) {
        startTime = time
        UserDefaults.standard.set(time, forKey: startTimeKey)
        updateProgress()
    }
    
    func saveEndTime(_ time: Date) {
        endTime = time
        UserDefaults.standard.set(time, forKey: endTimeKey)
        updateProgress()
    }
    
    func saveProgressBarColor(_ color: ProgressBarColor) {
        progressBarColor = color
        UserDefaults.standard.set(color.rawValue, forKey: colorKey)
    }
    
    func saveDisplayMode(_ mode: MenuBarDisplayMode) {
        displayMode = mode
        UserDefaults.standard.set(mode.rawValue, forKey: displayModeKey)
    }
    
    func saveBarSize(width: Double, height: Double) {
        barWidth = width
        barHeight = height
        UserDefaults.standard.set(width, forKey: barWidthKey)
        UserDefaults.standard.set(height, forKey: barHeightKey)
    }
    
    var timeRemaining: String {
        let calendar = Calendar.current
        let now = Date()
        
        let endComponents = calendar.dateComponents([.hour, .minute], from: endTime)
        guard let todayEnd = calendar.date(bySettingHour: endComponents.hour ?? 17,
                                           minute: endComponents.minute ?? 0,
                                           second: 0,
                                           of: now) else {
            return "N/A"
        }
        
        let remaining = todayEnd.timeIntervalSince(now)
        
        if remaining < 0 {
            return "Day ended"
        }
        
        let hours = Int(remaining) / 3600
        let minutes = (Int(remaining) % 3600) / 60
        
        return "\(hours)h \(minutes)m remaining"
    }
    
    var timeElapsed: String {
        let calendar = Calendar.current
        let now = Date()
        
        let startComponents = calendar.dateComponents([.hour, .minute], from: startTime)
        guard let todayStart = calendar.date(bySettingHour: startComponents.hour ?? 9,
                                             minute: startComponents.minute ?? 0,
                                             second: 0,
                                             of: now) else {
            return "N/A"
        }
        
        let elapsed = now.timeIntervalSince(todayStart)
        
        if elapsed < 0 {
            return "Day hasn't started"
        }
        
        let hours = Int(elapsed) / 3600
        let minutes = (Int(elapsed) % 3600) / 60
        
        return "\(hours)h \(minutes)m elapsed"
    }
}
