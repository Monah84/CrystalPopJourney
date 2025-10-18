require 'xcodeproj'

project_path = 'CrystalPopJourney.xcodeproj'
project = Xcodeproj::Project.open(project_path)

puts "🔧 Ensuring all Swift files are in target..."

# Get the main target
target = project.targets.first
puts "Target: #{target.name}"

# Get the main group
main_group = project.main_group.find_subpath('CrystalPopJourney', true)

# Files that should be in the target
required_files = [
  'PowerUp.swift',
  'GameMode.swift',
  'FontManager.swift',
  'SettingsScene.swift',
  'ScoresScene.swift',
  'AboutDMDScene.swift'
]

required_files.each do |filename|
  puts "\n📄 Checking #{filename}..."

  # Find the file reference
  file_ref = main_group.files.find { |f| f.path == filename }

  if file_ref.nil?
    puts "  ⚠️  File reference not found, adding..."
    # Add the file reference
    file_ref = main_group.new_reference(filename)
  else
    puts "  ✅ File reference exists"
  end

  # Check if file is in build phase
  build_file = target.source_build_phase.files.find { |bf| bf.file_ref == file_ref }

  if build_file.nil?
    puts "  ⚠️  Not in build phase, adding..."
    target.source_build_phase.add_file_reference(file_ref)
    puts "  ✅ Added to build phase"
  else
    puts "  ✅ Already in build phase"
  end
end

puts "\n📝 Saving project..."
project.save

puts "✅ All files are properly configured!"
puts "\n🎯 Next steps:"
puts "1. Close Xcode if open"
puts "2. Reopen: open CrystalPopJourney.xcodeproj"
puts "3. Clean build: ⌘+Shift+K"
puts "4. Build: ⌘+R"
