#!/bin/bash

echo "🚀 Setting up Crystal Pop Journey for Production..."
echo ""

# Navigate to project directory
cd /Users/monah/projects/CrystalPopJourney

# Check if Homebrew is installed
echo "📦 Checking for Homebrew..."
if ! command -v brew &> /dev/null; then
    echo "⚠️  Homebrew not found. Installing Homebrew..."
    echo "   (This is Apple's recommended package manager)"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

    # Add Homebrew to PATH for Apple Silicon Macs
    if [ -d "/opt/homebrew/bin" ]; then
        echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
        eval "$(/opt/homebrew/bin/brew shellenv)"
    fi
else
    echo "✅ Homebrew is installed"
fi

# Install Ruby via Homebrew
echo ""
echo "💎 Checking for Ruby..."
if ! brew list ruby &> /dev/null; then
    echo "⚠️  Installing Ruby via Homebrew..."
    brew install ruby

    # Add Homebrew Ruby to PATH
    echo 'export PATH="/opt/homebrew/opt/ruby/bin:$PATH"' >> ~/.zprofile
    export PATH="/opt/homebrew/opt/ruby/bin:$PATH"

    # For Intel Macs
    if [ -d "/usr/local/opt/ruby/bin" ]; then
        echo 'export PATH="/usr/local/opt/ruby/bin:$PATH"' >> ~/.zprofile
        export PATH="/usr/local/opt/ruby/bin:$PATH"
    fi
else
    echo "✅ Ruby is installed via Homebrew"
    export PATH="/opt/homebrew/opt/ruby/bin:$PATH"
    export PATH="/usr/local/opt/ruby/bin:$PATH"
fi

# Install CocoaPods
echo ""
echo "📦 Installing CocoaPods..."
if ! command -v pod &> /dev/null; then
    echo "⚠️  Installing CocoaPods..."
    gem install cocoapods --user-install

    # Add CocoaPods to PATH
    export PATH="$HOME/.gem/ruby/3.3.0/bin:$PATH"
    export PATH="$HOME/.gem/ruby/3.2.0/bin:$PATH"
else
    echo "✅ CocoaPods is installed"
fi

# Initialize CocoaPods if needed
echo ""
echo "🔧 Setting up CocoaPods..."
if [ ! -d "$HOME/.cocoapods/repos/cocoapods" ]; then
    pod setup
fi

# Install pods
echo ""
echo "📥 Installing Google Mobile Ads SDK..."
pod install

echo ""
echo "✅ Setup complete!"
echo ""
echo "📱 Next steps:"
echo "1. Open CrystalPopJourney.xcworkspace (NOT .xcodeproj)"
echo "2. Connect your iPhone via USB"
echo "3. Select your iPhone from the device dropdown in Xcode"
echo "4. Press ▶️ (Play) button to build and run"
echo ""
echo "📋 Important Notes:"
echo "   • The .xcworkspace file should now be visible!"
echo "   • You need to update Ad IDs in MonetizationManager.swift"
echo "   • See START_HERE.md for detailed instructions"
echo ""
echo "🎮 Have fun testing!"
