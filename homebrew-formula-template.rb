cask "time-progress" do
  version "1.0.0"
  sha256 "f1c78b699c9537169ca6c603fd583d3fc8bf9a45dbf79bd5283ab48a0db1583c"

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
