# 🔧 Manual Setup Instructions

## Why You Need This
The automatic setup script needs your password to install required software. Follow these simple steps to complete the setup manually.

---

## Step 1: Open Terminal (1 min)

1. Press **⌘ + Space** (Command + Spacebar)
2. Type: **Terminal**
3. Press **Enter**

You should see a black or white window with text.

---

## Step 2: Install Homebrew (5 min)

**Copy and paste this entire command into Terminal, then press Enter:**

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
```

**What will happen:**
- It will ask for your Mac password (same as login password)
- Type your password and press Enter (you won't see dots or asterisks - this is normal!)
- Wait 2-5 minutes for installation
- You might be asked to press Enter again - just do it!

**When it's done, you'll see:** "Installation successful!"

---

## Step 3: Add Homebrew to Your System (1 min)

**Copy and paste these commands one at a time:**

For Apple Silicon Mac (M1/M2/M3):
```bash
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"
```

For Intel Mac:
```bash
echo 'eval "$(/usr/local/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/usr/local/bin/brew shellenv)"
```

**Don't know which Mac you have?** Run both sets of commands - it won't hurt!

---

## Step 4: Install Ruby (3 min)

**Copy and paste this command:**

```bash
brew install ruby
```

Wait for it to finish (2-3 minutes).

---

## Step 5: Add Ruby to Your System (1 min)

**Copy and paste these commands:**

For Apple Silicon Mac (M1/M2/M3):
```bash
echo 'export PATH="/opt/homebrew/opt/ruby/bin:$PATH"' >> ~/.zprofile
source ~/.zprofile
```

For Intel Mac:
```bash
echo 'export PATH="/usr/local/opt/ruby/bin:$PATH"' >> ~/.zprofile
source ~/.zprofile
```

---

## Step 6: Install CocoaPods (2 min)

**Copy and paste this command:**

```bash
gem install cocoapods --user-install
```

Wait for it to finish.

---

## Step 7: Add CocoaPods to Your System (1 min)

**Copy and paste these commands:**

```bash
echo 'export PATH="$HOME/.gem/bin:$PATH"' >> ~/.zprofile
source ~/.zprofile
```

---

## Step 8: Navigate to Your Project (10 seconds)

**Copy and paste this command:**

```bash
cd /Users/monah/projects/CrystalPopJourney
```

---

## Step 9: Install Google Mobile Ads SDK (2 min)

**Copy and paste this command:**

```bash
pod install
```

**What you'll see:**
- "Analyzing dependencies..."
- "Downloading dependencies..."
- "Installing Google-Mobile-Ads-SDK..."
- "Generating Pods project..."
- Pod installation complete!

---

## Step 10: Verify Success (10 seconds)

**Run this command to check if the workspace file was created:**

```bash
ls -la | grep workspace
```

**You should see:**
```
CrystalPopJourney.xcworkspace
```

✅ **SUCCESS!** The .xcworkspace file now exists!

---

## 🎉 You're Done!

### Next Steps:

1. **Open the project in Xcode:**
   ```bash
   open CrystalPopJourney.xcworkspace
   ```

2. **Or** in Finder:
   - Navigate to: `/Users/monah/projects/CrystalPopJourney/`
   - Double-click: `CrystalPopJourney.xcworkspace` (WHITE icon)
   - ❌ DON'T click `.xcodeproj` (blue icon)

3. **Follow the rest of the setup:**
   - See `START_HERE.md` for remaining steps
   - Create AdMob ad units
   - Update ad IDs in code
   - Test on your iPhone!

---

## 🆘 If Something Goes Wrong

### "Command not found" error:
- Close Terminal
- Open a new Terminal window
- Try the command again

### "Permission denied":
- Make sure you're typing your Mac password correctly
- You might need administrator access on your Mac

### Still stuck?
- Take a screenshot of the error
- The error message will tell us what to fix!

---

## 📋 Quick Summary (Copy-Paste All Commands)

**If you want to just copy and paste everything at once, here it is:**

```bash
# Install Homebrew
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Add Homebrew to PATH (for Apple Silicon)
echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> ~/.zprofile
eval "$(/opt/homebrew/bin/brew shellenv)"

# Install Ruby
brew install ruby

# Add Ruby to PATH (for Apple Silicon)
echo 'export PATH="/opt/homebrew/opt/ruby/bin:$PATH"' >> ~/.zprofile
source ~/.zprofile

# Install CocoaPods
gem install cocoapods --user-install

# Add CocoaPods to PATH
echo 'export PATH="$HOME/.gem/bin:$PATH"' >> ~/.zprofile
source ~/.zprofile

# Navigate to project
cd /Users/monah/projects/CrystalPopJourney

# Install dependencies
pod install

# Open project
open CrystalPopJourney.xcworkspace
```

**Note:** You'll still need to enter your password when Homebrew asks for it!

---

**Good luck! You've got this! 💪**
