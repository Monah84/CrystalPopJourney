require 'xcodeproj'

project_path = 'CrystalPopJourney.xcodeproj'
project = Xcodeproj::Project.open(project_path)

puts "🔧 Adding GoogleMobileAds.xcframework to project..."

# Get the main target
target = project.targets.first
puts "Target: #{target.name}"

# Create Frameworks group if it doesn't exist
frameworks_group = project.main_group['Frameworks'] || project.main_group.new_group('Frameworks')

# Add the xcframework file reference
framework_path = 'Frameworks/GoogleMobileAds.xcframework'
file_ref = frameworks_group.new_file(framework_path)
file_ref.source_tree = 'SOURCE_ROOT'

puts "Added file reference: #{file_ref.path}"

# Add to frameworks build phase
frameworks_phase = target.frameworks_build_phase
build_file = frameworks_phase.add_file_reference(file_ref)

# Configure the build file
build_file.settings = {
  'ATTRIBUTES' => ['CodeSignOnCopy']
}

puts "Added to Frameworks build phase"

# Add framework search paths
target.build_configurations.each do |config|
  search_paths = config.build_settings['FRAMEWORK_SEARCH_PATHS'] || ['$(inherited)']
  search_paths = [search_paths] unless search_paths.is_a?(Array)
  unless search_paths.include?('$(PROJECT_DIR)/Frameworks')
    search_paths << '$(PROJECT_DIR)/Frameworks'
    config.build_settings['FRAMEWORK_SEARCH_PATHS'] = search_paths
    puts "Added framework search path to #{config.name}"
  end
end

puts "\n📝 Saving project..."
project.save

puts "✅ GoogleMobileAds.xcframework added successfully!"
puts "\nThe framework is now linked to your project."
puts "Build the project to use Google Mobile Ads."
