//
//  MenuBarView.swift
//  time-progress
//
//  Created by Berkay Güre on 4.01.2026.
//

import SwiftUI
import Combine

struct MenuBarView: View {
    @StateObject private var progressManager = DayProgressManager.shared
    @State private var currentTime = Date()
    @Environment(\.colorScheme) var colorScheme
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    
    var body: some View {
        VStack(spacing: 20) {
            // Header
            Text("Day Progress")
                .font(.title2)
                .fontWeight(.bold)
            
            // Circular Progress
            ZStack {
                Circle()
                    .stroke(Color.gray.opacity(0.2), lineWidth: 20)
                    .frame(width: 150, height: 150)
                
                Circle()
                    .trim(from: 0, to: progressManager.currentProgress)
                    .stroke(
                        progressBarGradient,
                        style: StrokeStyle(lineWidth: 20, lineCap: .round)
                    )
                    .frame(width: 150, height: 150)
                    .rotationEffect(.degrees(-90))
                    .animation(.linear(duration: 1), value: progressManager.currentProgress)
                
                VStack(spacing: 4) {
                    Text("\(Int(progressManager.currentProgress * 100))%")
                        .font(.system(size: 36, weight: .bold))
                    Text("Complete")
                        .font(.caption)
                        .foregroundColor(.secondary)
                }
            }
            .padding()
            
            // Time Info Cards
            HStack(spacing: 12) {
                // Time Elapsed Card
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "clock.fill")
                            .font(.caption)
                            .foregroundColor(.blue)
                        Text("Elapsed")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Text(shortTimeFormat(progressManager.timeElapsed))
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
                
                // Time Remaining Card
                VStack(alignment: .leading, spacing: 4) {
                    HStack {
                        Image(systemName: "hourglass")
                            .font(.caption)
                            .foregroundColor(.orange)
                        Text("Remaining")
                            .font(.caption)
                            .foregroundColor(.secondary)
                    }
                    Text(shortTimeFormat(progressManager.timeRemaining))
                        .font(.system(.body, design: .rounded))
                        .fontWeight(.semibold)
                }
                .frame(maxWidth: .infinity)
                .padding(10)
                .background(Color.gray.opacity(0.1))
                .cornerRadius(8)
            }
            .padding(.horizontal, 8)
            
            Divider()
            
            // Settings Button
            SettingsLink {
                Label("Settings", systemImage: "gear")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            
            // Quit Button
            Button(action: quitApp) {
                Label("Quit", systemImage: "xmark.circle")
                    .frame(maxWidth: .infinity)
            }
            .buttonStyle(.bordered)
            .tint(.red)
        }
        .padding()
        .frame(width: 300, height: 450)
        .onReceive(timer) { _ in
            currentTime = Date()
            progressManager.updateProgress()
        }
    }
    
    private var progressBarGradient: LinearGradient {
        let isDarkMode = colorScheme == .dark
        
        if progressManager.progressBarColor == .gradient {
            return LinearGradient(
                colors: [.blue, .purple],
                startPoint: .leading,
                endPoint: .trailing
            )
        } else {
            let color = Color(progressManager.progressBarColor.nsColor(isDarkMode: isDarkMode))
            return LinearGradient(
                colors: [color],
                startPoint: .leading,
                endPoint: .trailing
            )
        }
    }
    
    private func shortTimeFormat(_ timeString: String) -> String {
        // Remove "remaining" or "elapsed" suffix if present
        let cleaned = timeString
            .replacingOccurrences(of: " remaining", with: "")
            .replacingOccurrences(of: " elapsed", with: "")
        
        // Handle special cases
        if cleaned == "Day ended" || cleaned == "Day hasn't started" {
            return cleaned
        }
        
        return cleaned
    }
    
    private func quitApp() {
        NSApplication.shared.terminate(nil)
    }
}

#Preview {
    MenuBarView()
}
