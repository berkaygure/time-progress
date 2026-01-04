cask "time-progress" do
  version "1.0.0"
  sha256 "REPLACE_WITH_YOUR_SHA256_HASH"

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
