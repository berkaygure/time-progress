cask "time-progress" do
  version "1.0.1"
  sha256 "f5e685ef81c0eea547bfb3a7860c284f560ef0bfe7ba80292e7acb4b2b576bc1"

  url "https://github.com/berkaygure/time-progress/releases/download/v#{version}/TimeProgress-#{version}.zip"
  name "Time Progress"
  desc "Day progress tracker for macOS menu bar"
  homepage "https://github.com/berkaygure/time-progress"

  # Requires macOS 14.0 or later
  depends_on macos: ">= :sonoma"

  app "time-progress.app"

  zap trash: [
    "~/Library/Preferences/com.berkaygure.time-progress.plist",
  ]
end
