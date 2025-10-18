#!/usr/bin/env ruby

require 'xcodeproj'

project_path = '/Users/monah/projects/CrystalPopJourney/CrystalPopJourney.xcodeproj'
project = Xcodeproj::Project.open(project_path)

# Get the main target
target = project.targets.first

# Get the main group
main_group = project.main_group['CrystalPopJourney']

# Files to add
new_files = [
  'PowerUp.swift',
  'GameMode.swift',
  'FontManager.swift',
  'SettingsScene.swift',
  'ScoresScene.swift'
]

# Remove existing references if any
main_group.files.each do |file|
  if new_files.include?(file.path)
    file.remove_from_project
  end
end

# Add each file
new_files.each do |filename|
  file_path = "/Users/monah/projects/CrystalPopJourney/CrystalPopJourney/#{filename}"
  if File.exist?(file_path)
    file_ref = main_group.new_file(file_path)
    file_ref.source_tree = '<group>'
    target.source_build_phase.add_file_reference(file_ref)
    puts "Added: #{filename}"
  else
    puts "Warning: #{filename} not found at #{file_path}"
  end
end

project.save

puts "\nAll files added successfully!"
