require 'xcodeproj'

project_path = 'CrystalPopJourney.xcodeproj'
project = Xcodeproj::Project.open(project_path)

puts "🔧 Adding GameCenterManager.swift to project..."

# Get the main target
target = project.targets.first
puts "Target: #{target.name}"

# Get the main group for source files
main_group = project.main_group.find_subpath('CrystalPopJourney', true)

# Add the file reference
file_ref = main_group.new_file('GameCenterManager.swift')

# Add to compile sources
target.add_file_references([file_ref])

puts "\n📝 Saving project..."
project.save

puts "✅ GameCenterManager.swift added successfully!"
