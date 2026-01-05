cask "time-progress" do
  version "1.0.1"
  sha256 "79bb0c9f753377553170b8c574112ba908f0325dfbe0b079e41c3d1f32bdbc15"

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
