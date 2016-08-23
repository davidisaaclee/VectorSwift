#
# Be sure to run `pod lib lint VectorSwift.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "VectorSwift"
  s.version          = "0.1.2"
  s.summary          = "Powerful vector operations for the types you're already using."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
VectorSwift gives you powerful vector operations for the types you're already using, by providing a Vector
protocol which can give any type the power to perform vector operations.
                       DESC

  s.homepage         = "https://github.com/davidisaaclee/VectorSwift"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "David Lee" => "david@david-lee.net" }
  s.source           = { :git => "https://github.com/davidisaaclee/VectorSwift.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/davidisaaclee'

  s.ios.deployment_target = '8.0'

  s.source_files = 'VectorSwift/Classes/**/*'
  
  # s.resource_bundles = {
  #   'VectorSwift' => ['VectorSwift/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
