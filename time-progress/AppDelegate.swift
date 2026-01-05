//
//  AppDelegate.swift
//  time-progress
//
//  Created by Berkay Güre on 4.01.2026.
//

import SwiftUI
import AppKit

class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {
    private var statusItem: NSStatusItem!
    private var popover: NSPopover!
    private var progressManager = DayProgressManager.shared
    private var timer: Timer?
    private var isPopoverOpen = false
    
    func applicationDidFinishLaunching(_ notification: Notification) {
        // Create the status bar item
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        
        if let button = statusItem.button {
            button.action = #selector(togglePopover)
            button.target = self
            button.sendAction(on: [.leftMouseUp, .rightMouseUp])
            updateStatusBarTitle()
        }
        
        // Create the popover
        popover = NSPopover()
        popover.contentSize = NSSize(width: 300, height: 450)
        popover.behavior = .transient
        popover.animates = true
        popover.delegate = self
        popover.contentViewController = NSHostingController(rootView: MenuBarView())
        
        // Update every second for smooth real-time progress
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateStatusBarTitle()
        }
    }
    
    @objc func togglePopover() {
        if let button = statusItem.button {
            if popover.isShown {
                popover.performClose(nil)
                isPopoverOpen = false
            } else {
                isPopoverOpen = true
                popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
                // Keep button highlighted while popover is shown
                NSApp.activate(ignoringOtherApps: true)
            }
        }
    }
    
    // MARK: - NSPopoverDelegate
    
    func popoverWillShow(_ notification: Notification) {
        isPopoverOpen = true
    }
    
    func popoverDidClose(_ notification: Notification) {
        isPopoverOpen = false
    }
    
    // MARK: - Status Bar Updates
    
    private func updateStatusBarTitle() {
        guard let button = statusItem.button else { return }
        
        let progress = progressManager.currentProgress
        let timeText = getTimeRemainingText()
        let progressBar = createProgressBar(progress: progress, timeText: timeText)
        
        button.attributedTitle = progressBar
        
        // Update button appearance based on popover state
        if isPopoverOpen {
            // Add a subtle background when popover is open
            button.wantsLayer = true
            button.layer?.backgroundColor = NSColor.selectedContentBackgroundColor.withAlphaComponent(0.2).cgColor
            button.layer?.cornerRadius = 4
        } else {
            button.layer?.backgroundColor = NSColor.clear.cgColor
        }
    }
    
    private func getTimeRemainingText() -> String {
        let calendar = Calendar.current
        let now = Date()
        
        let endComponents = calendar.dateComponents([.hour, .minute], from: progressManager.endTime)
        guard let todayEnd = calendar.date(bySettingHour: endComponents.hour ?? 17,
                                           minute: endComponents.minute ?? 0,
                                           second: 0,
                                           of: now) else {
            return progressManager.displayMode == .percentage ? "0%" : "0h 0m"
        }
        
        // Return based on display mode
        if progressManager.displayMode == .percentage {
            let percentage = Int(progressManager.currentProgress * 100)
            return "\(percentage)%"
        } else {
            let remaining = todayEnd.timeIntervalSince(now)
            
            if remaining < 0 {
                return "0h 0m"
            }
            
            let hours = Int(remaining) / 3600
            let minutes = (Int(remaining) % 3600) / 60
            
            return "\(hours)h \(minutes)m"
        }
    }
    
    private func createProgressBar(progress: Double, timeText: String) -> NSAttributedString {
        let attributedString = NSMutableAttributedString()
        
        // Create rounded progress bar - SMALLER SIZE
        let barWidth: CGFloat = 45
        let barHeight: CGFloat = 14
        let cornerRadius: CGFloat = 8
        let padding: CGFloat = 2
        let borderWidth: CGFloat = 1
        
        // Check if dark mode is enabled (properly detect system appearance)
        let appearance = NSApp.effectiveAppearance
        let isDarkMode = appearance.name == .darkAqua || appearance.name == .vibrantDark || appearance.name == .accessibilityHighContrastDarkAqua
        
        // Get selected color
        let selectedColor = self.progressManager.progressBarColor
        let borderColor: NSColor
        
        if selectedColor == .gradient {
            // For gradient, use blue for border
            borderColor = NSColor.systemBlue
        } else {
            borderColor = selectedColor.nsColor(isDarkMode: isDarkMode)
        }
        
        let image = NSImage(size: NSSize(width: barWidth, height: barHeight), flipped: false) { rect in
            // Outer border - same color as fill
            let borderPath = NSBezierPath(roundedRect: rect, xRadius: cornerRadius, yRadius: cornerRadius)
            borderColor.withAlphaComponent(0.6).setStroke()
            borderPath.lineWidth = borderWidth
            borderPath.stroke()
            
            // Background (inside border)
            let bgRect = rect.insetBy(dx: borderWidth, dy: borderWidth)
            let bgPath = NSBezierPath(roundedRect: bgRect, xRadius: cornerRadius - borderWidth, yRadius: cornerRadius - borderWidth)
            NSColor.gray.withAlphaComponent(0.15).setFill()
            bgPath.fill()
            
            // Inner filled progress with padding
            let innerRect = rect.insetBy(dx: padding, dy: padding)
            let fillWidth = (innerRect.width) * progress
            let fillRect = NSRect(x: innerRect.minX, y: innerRect.minY, width: fillWidth, height: innerRect.height)
            
            let innerPath = NSBezierPath(roundedRect: fillRect, xRadius: cornerRadius - padding, yRadius: cornerRadius - padding)
            
            // Use selected color or gradient
            if selectedColor == .gradient {
                let gradient = NSGradient(colors: [
                    NSColor.systemBlue,
                    NSColor.systemPurple
                ])
                gradient?.draw(in: innerPath, angle: 0)
            } else {
                borderColor.setFill()
                innerPath.fill()
            }
            
            return true
        }
        
        // Create text attachment for the progress bar with baseline adjustment
        let attachment = NSTextAttachment()
        attachment.image = image
        
        // Adjust bounds to vertically center the image with text
        let font = NSFont.monospacedSystemFont(ofSize: 12, weight: .regular)
        let fontHeight = font.capHeight
        let yOffset = (fontHeight - barHeight) / 2.0
        attachment.bounds = CGRect(x: 0, y: yOffset, width: barWidth, height: barHeight)
        
        // Add progress bar
        attributedString.append(NSAttributedString(attachment: attachment))
        
        // Add spacing between progress bar and text
        attributedString.append(NSAttributedString(string: "  "))  // Double space for more spacing
        
        // Add time text
        let timeString = NSAttributedString(string: timeText, attributes: [
            .font: font,
            .baselineOffset: 0
        ])
        attributedString.append(timeString)
        
        return attributedString
    }
}
