require 'xcodeproj'

project_path = 'CrystalPopJourney.xcodeproj'
project = Xcodeproj::Project.open(project_path)

puts "🔧 Fixing AboutDMDScene.swift file path..."

# Get the main target
target = project.targets.first
puts "Target: #{target.name}"

# Get the main group
main_group = project.main_group.find_subpath('CrystalPopJourney', true)

# Find all file references with AboutDMDScene.swift
all_refs = []
project.files.each do |file_ref|
  if file_ref.path.include?('AboutDMDScene.swift')
    all_refs << file_ref
    puts "Found file reference: #{file_ref.path} (real_path: #{file_ref.real_path})"
  end
end

# Remove all AboutDMDScene.swift references from build phase
puts "\n🗑️  Removing old references from build phase..."
target.source_build_phase.files.each do |build_file|
  if build_file.file_ref && build_file.file_ref.path.include?('AboutDMDScene.swift')
    puts "  Removing: #{build_file.file_ref.path}"
    build_file.remove_from_project
  end
end

# Remove all file references
puts "\n🗑️  Removing old file references..."
all_refs.each do |file_ref|
  puts "  Removing: #{file_ref.path}"
  file_ref.remove_from_project
end

# Add the correct file reference
puts "\n✅ Adding correct file reference..."
file_ref = main_group.new_reference('AboutDMDScene.swift')
puts "  Added: #{file_ref.path}"

# Add to build phase
puts "\n✅ Adding to build phase..."
target.source_build_phase.add_file_reference(file_ref)
puts "  Added to build phase"

puts "\n📝 Saving project..."
project.save

puts "✅ Fixed AboutDMDScene.swift path!"
