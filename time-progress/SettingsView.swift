//
//  SettingsView.swift
//  time-progress
//
//  Created by Berkay Güre on 4.01.2026.
//

import SwiftUI

struct SettingsView: View {
    @StateObject private var progressManager = DayProgressManager.shared
    @State private var startTime: Date
    @State private var endTime: Date
    @State private var selectedColor: ProgressBarColor
    @State private var selectedDisplayMode: MenuBarDisplayMode
    
    init() {
        let manager = DayProgressManager.shared
        _startTime = State(initialValue: manager.startTime)
        _endTime = State(initialValue: manager.endTime)
        _selectedColor = State(initialValue: manager.progressBarColor)
        _selectedDisplayMode = State(initialValue: manager.displayMode)
    }
    
    var body: some View {
        Form {
            Section {
                DatePicker("Start Time",
                          selection: $startTime,
                          displayedComponents: .hourAndMinute)
                    .onChange(of: startTime) { _, newValue in
                        progressManager.saveStartTime(newValue)
                    }
                
                DatePicker("End Time",
                          selection: $endTime,
                          displayedComponents: .hourAndMinute)
                    .onChange(of: endTime) { _, newValue in
                        progressManager.saveEndTime(newValue)
                    }
            } header: {
                Text("Day Schedule")
            } footer: {
                Text("Set your working hours to track progress throughout the day.")
            }
            
            Section {
                Picker("Progress Bar Color", selection: $selectedColor) {
                    ForEach(ProgressBarColor.allCases) { color in
                        HStack {
                            if color == .system {
                                Image(systemName: "circle.lefthalf.filled")
                            } else if color == .gradient {
                                Image(systemName: "circle.hexagongrid.circle.fill")
                            } else {
                                Circle()
                                    .fill(Color(color.nsColor(isDarkMode: false)))
                                    .frame(width: 12, height: 12)
                            }
                            Text(color.rawValue)
                        }
                        .tag(color)
                    }
                }
                .onChange(of: selectedColor) { _, newValue in
                    progressManager.saveProgressBarColor(newValue)
                }
                
                Picker("Menu Bar Display", selection: $selectedDisplayMode) {
                    ForEach(MenuBarDisplayMode.allCases) { mode in
                        HStack {
                            if mode == .remaining {
                                Image(systemName: "clock")
                            } else {
                                Image(systemName: "percent")
                            }
                            Text(mode.rawValue)
                        }
                        .tag(mode)
                    }
                }
                .onChange(of: selectedDisplayMode) { _, newValue in
                    progressManager.saveDisplayMode(newValue)
                }
            } header: {
                Text("Appearance")
            } footer: {
                Text("Choose the color and display format for the menu bar.")
            }
            
            Section {
                VStack(alignment: .leading, spacing: 8) {
                    HStack {
                        Text("Current Progress:")
                            .fontWeight(.medium)
                        Spacer()
                        Text("\(Int(progressManager.currentProgress * 100))%")
                            .foregroundColor(.secondary)
                    }
                    
                    ProgressView(value: progressManager.currentProgress)
                        .progressViewStyle(.linear)
                    
                    HStack {
                        Text(progressManager.timeElapsed)
                            .font(.caption)
                            .foregroundColor(.secondary)
                        Spacer()
                        Text(progressManager.timeRemaining)
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                }
            } header: {
                Text("Preview")
            }
            
            Section {
                Button("Reset to Default (9 AM - 5 PM)") {
                    let calendar = Calendar.current
                    let now = Date()
                    
                    if let start = calendar.date(bySettingHour: 9, minute: 0, second: 0, of: now),
                       let end = calendar.date(bySettingHour: 17, minute: 0, second: 0, of: now) {
                        startTime = start
                        endTime = end
                        progressManager.saveStartTime(start)
                        progressManager.saveEndTime(end)
                    }
                }
            }
        }
        .formStyle(.grouped)
        .frame(width: 450, height: 500)
        .navigationTitle("Settings")
    }
}

#Preview {
    SettingsView()
}
