require 'xcodeproj'

project_path = 'CrystalPopJourney.xcodeproj'
project = Xcodeproj::Project.open(project_path)

puts "🔧 Removing GoogleMobileAds package dependency..."

# Get the main target
target = project.targets.first
puts "Target: #{target.name}"

# Remove package product dependencies
removed_count = 0
target.package_product_dependencies.each do |package_dep|
  puts "Found package dependency: #{package_dep.product_name}"
  if package_dep.product_name.include?('GoogleMobileAds')
    puts "  Removing: #{package_dep.product_name}"
    package_dep.remove_from_project
    removed_count += 1
  end
end

# Remove package references from project
project.root_object.package_references.each do |package_ref|
  if package_ref.to_tree_hash.to_s.include?('google') || package_ref.to_tree_hash.to_s.include?('GoogleMobileAds')
    puts "Removing package reference: #{package_ref.to_tree_hash}"
    package_ref.remove_from_project
    removed_count += 1
  end
end

if removed_count > 0
  puts "\n📝 Saving project..."
  project.save
  puts "✅ Removed #{removed_count} GoogleMobileAds references!"
else
  puts "ℹ️ No GoogleMobileAds package references found"
end
