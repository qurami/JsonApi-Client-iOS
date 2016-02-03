#
# Be sure to run `pod lib lint QuramiJsonApi.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "QuramiJsonApi"
  s.version          = "0.1.0"
  s.summary          = "An Obj-C json-api client implementation, for the json-api specification."

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = "This library consists of a Client and many classes to implement quickly and easily the JSONApi Specification in your iOS App."

  s.homepage         = "https://github.com/qurami/JsonApi-Client-iOS"
  s.license          = 'MIT'
  s.author           = { "Marco Musella" => "mar.musella@gmail.com" }
  s.source           = { :git => "https://github.com/qurami/JsonApi-Client-iOS.git", :tag => s.version.to_s }
  s.social_media_url = 'https://twitter.com/i_mush'

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'
  s.resource_bundles = {
    'QuramiJsonApi' => ['Pod/Assets/*.png']
  }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
