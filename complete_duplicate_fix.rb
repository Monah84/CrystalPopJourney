require 'xcodeproj'

project_path = 'CrystalPopJourney.xcodeproj'
project = Xcodeproj::Project.open(project_path)

puts "🔧 Complete duplicate file fix..."

# Get the main target
target = project.targets.first
puts "Target: #{target.name}"

# Files to fix
problem_files = ['PowerUp.swift', 'GameMode.swift']

problem_files.each do |filename|
  puts "\n📄 Fixing #{filename}..."

  # Find ALL file references for this file
  all_refs = []
  project.main_group.recursive_children.each do |item|
    if item.is_a?(Xcodeproj::Project::Object::PBXFileReference) && item.path.to_s.end_with?(filename)
      all_refs << item
      puts "  Found reference: #{item.path} (UUID: #{item.uuid})"
    end
  end

  if all_refs.empty?
    puts "  ⚠️  No references found!"
    next
  end

  # Remove ALL from build phase first
  target.source_build_phase.files.each do |build_file|
    if build_file.file_ref && all_refs.include?(build_file.file_ref)
      puts "  ❌ Removing from build phase: #{build_file.file_ref.path}"
      target.source_build_phase.files.delete(build_file)
    end
  end

  # Keep only the first reference, remove others from project
  keeper = all_refs.first
  puts "  ✅ Keeping reference: #{keeper.path}"

  all_refs[1..-1].each do |ref|
    puts "  ❌ Removing extra reference: #{ref.path}"
    ref.remove_from_project
  end

  # Add the keeper back to build phase
  puts "  ✅ Adding back to build phase: #{keeper.path}"
  target.source_build_phase.add_file_reference(keeper)
end

puts "\n📝 Saving project..."
project.save

puts "\n✅ All duplicates removed!"
puts "\n🧹 Now cleaning derived data..."
