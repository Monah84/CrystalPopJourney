require 'xcodeproj'

project_path = 'CrystalPopJourney.xcodeproj'
project = Xcodeproj::Project.open(project_path)

puts "🔧 Fixing file paths for PowerUp and GameMode..."

# Get the main group
main_group = project.main_group.find_subpath('CrystalPopJourney', false)

# Files to fix
problem_files = {
  'PowerUp.swift' => '/Users/monah/projects/CrystalPopJourney/CrystalPopJourney/PowerUp.swift',
  'GameMode.swift' => '/Users/monah/projects/CrystalPopJourney/CrystalPopJourney/GameMode.swift'
}

problem_files.each do |filename, correct_path|
  puts "\n📄 Fixing #{filename}..."

  # Find the file reference
  file_ref = nil
  project.main_group.recursive_children.each do |item|
    if item.is_a?(Xcodeproj::Project::Object::PBXFileReference)
      if item.path.to_s == filename || item.path.to_s.end_with?("/#{filename}")
        file_ref = item
        break
      end
    end
  end

  if file_ref.nil?
    puts "  ⚠️  File reference not found!"
    next
  end

  # Update the path to be relative
  file_ref.path = filename
  file_ref.source_tree = '<group>'

  puts "  ✅ Fixed path: #{filename}"
  puts "     Source tree: <group>"
end

puts "\n📝 Saving project..."
project.save

puts "\n✅ File paths fixed!"
