require 'xcodeproj'

project_path = 'CrystalPopJourney.xcodeproj'
project = Xcodeproj::Project.open(project_path)

puts "🔧 Adding GoogleMobileAds via Swift Package Manager..."

# Remove the repository URL if it exists (to avoid duplicates)
project.root_object.package_references.each do |package_ref|
  if package_ref.to_tree_hash.to_s.include?('google') || package_ref.to_tree_hash.to_s.include?('GoogleMobileAds')
    puts "Removing existing package reference..."
    package_ref.remove_from_project
  end
end

# Add Google Mobile Ads SDK package
puts "Adding GoogleMobileAds package..."

# Create package reference
package = project.root_object.new_package('https://github.com/googleads/swift-package-manager-google-mobile-ads.git')
package.requirement = {
  'kind' => 'upToNextMajorVersion',
  'minimumVersion' => '11.0.0'
}

# Get the main target
target = project.targets.first
puts "Target: #{target.name}"

# Add package product to target
product = target.new_package_product_dependency(package, 'GoogleMobileAds')
target.package_product_dependencies << product

puts "\n📝 Saving project..."
project.save

puts "✅ GoogleMobileAds package added successfully!"
puts "\nNext steps:"
puts "1. Open CrystalPopJourney.xcodeproj in Xcode"
puts "2. Xcode will automatically download the package"
puts "3. Build the project"
