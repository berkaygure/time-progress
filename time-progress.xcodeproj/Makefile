.PHONY: build release clean install test help

VERSION ?= 1.0.0

help: ## Show this help message
	@echo 'Usage: make [target]'
	@echo ''
	@echo 'Available targets:'
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "  %-15s %s\n", $$1, $$2}' $(MAKEFILE_LIST)

build: ## Build the app in release mode
	@echo "🔨 Building Time Progress..."
	@xcodebuild clean build \
		-scheme time-progress \
		-configuration Release \
		-derivedDataPath build/DerivedData \
		CODE_SIGN_IDENTITY="-" \
		CODE_SIGNING_REQUIRED=NO \
		CODE_SIGNING_ALLOWED=NO
	@echo "✅ Build complete!"

release: ## Create release package (ZIP, DMG, SHA256)
	@echo "📦 Creating release package..."
	@chmod +x build-release.sh
	@./build-release.sh $(VERSION)

clean: ## Clean build artifacts
	@echo "🧹 Cleaning..."
	@rm -rf build/
	@xcodebuild clean
	@echo "✅ Clean complete!"

install: build ## Build and install to /Applications
	@echo "📲 Installing to /Applications..."
	@APP_PATH=$$(find build/DerivedData -name "*.app" -type d -depth 1 | head -n 1); \
	if [ -d "/Applications/time-progress.app" ]; then \
		rm -rf "/Applications/time-progress.app"; \
	fi; \
	cp -R "$$APP_PATH" "/Applications/"
	@echo "✅ Installed to /Applications/time-progress.app"

uninstall: ## Remove app from /Applications
	@echo "🗑️  Uninstalling..."
	@rm -rf "/Applications/time-progress.app"
	@rm -f ~/Library/Preferences/com.berkaygure.time-progress.plist
	@echo "✅ Uninstalled!"

test: ## Run tests (if any)
	@echo "🧪 Running tests..."
	@xcodebuild test \
		-scheme time-progress \
		-destination 'platform=macOS'

run: build install ## Build, install, and run the app
	@echo "🚀 Launching Time Progress..."
	@open /Applications/time-progress.app

archive: ## Create Xcode archive
	@echo "📦 Creating archive..."
	@xcodebuild archive \
		-scheme time-progress \
		-configuration Release \
		-archivePath build/TimeProgress.xcarchive \
		CODE_SIGN_IDENTITY="-" \
		CODE_SIGNING_REQUIRED=NO
	@echo "✅ Archive created!"

format: ## Format Swift code (requires swift-format)
	@if command -v swift-format >/dev/null 2>&1; then \
		echo "🎨 Formatting code..."; \
		find . -name "*.swift" ! -path "*/.*" -exec swift-format -i {} \; ; \
		echo "✅ Format complete!"; \
	else \
		echo "❌ swift-format not found. Install with: brew install swift-format"; \
	fi

lint: ## Lint Swift code (requires SwiftLint)
	@if command -v swiftlint >/dev/null 2>&1; then \
		echo "🔍 Linting code..."; \
		swiftlint; \
		echo "✅ Lint complete!"; \
	else \
		echo "❌ SwiftLint not found. Install with: brew install swiftlint"; \
	fi

homebrew-test: release ## Test Homebrew installation locally
	@echo "🍺 Testing Homebrew installation..."
	@brew uninstall --cask time-progress 2>/dev/null || true
	@brew install --cask build/TimeProgress-$(VERSION).zip
	@echo "✅ Homebrew test complete!"

version: ## Show current version
	@echo "Version: $(VERSION)"

bump-version: ## Bump version (usage: make bump-version VERSION=1.1.0)
	@echo "📝 Updating version to $(VERSION)..."
	@sed -i '' 's/version ".*"/version "$(VERSION)"/' homebrew-formula-template.rb
	@echo "✅ Version updated in formula template"
	@echo "Don't forget to update version in Xcode project settings!"
