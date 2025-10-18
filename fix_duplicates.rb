require 'xcodeproj'

project_path = 'CrystalPopJourney.xcodeproj'
project = Xcodeproj::Project.open(project_path)

puts "🔧 Fixing duplicate file references in Xcode project..."

# Get the main target
target = project.targets.first
puts "Target: #{target.name}"

# Get the compile sources build phase
sources_phase = target.source_build_phase

# Track files by basename
seen_basenames = {}
duplicates_removed = 0

# Check each build file
files_to_remove = []

sources_phase.files.each do |build_file|
  next unless build_file.file_ref

  file_path = build_file.file_ref.path
  basename = File.basename(file_path)

  if seen_basenames[basename]
    puts "  ❌ Marking for removal (duplicate basename): #{file_path}"
    files_to_remove << build_file
    duplicates_removed += 1
  else
    seen_basenames[basename] = file_path
    puts "  ✅ Keeping: #{file_path}"
  end
end

# Remove the duplicate files
files_to_remove.each do |build_file|
  sources_phase.files.delete(build_file)
end

if duplicates_removed > 0
  puts "\n📝 Saving project..."
  project.save
  puts "✅ Removed #{duplicates_removed} duplicate file reference(s)"
else
  puts "\n✅ No duplicates found!"
end

puts "\n🎉 Project is ready to build!"
