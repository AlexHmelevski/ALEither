#
# Be sure to run `pod lib lint ALEither.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'ALEither'
  s.version          = '0.1.3'
  s.summary          = 'Either monad in swift'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  Simple idea of Either monad implemented in Swift. Supports map,flatMap,fork etc
                       DESC

  s.homepage         = 'https://github.com/AlexHmelevski/ALEither.git'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'AlexHmelevskiAG' => 'alexei.hmelevski@gmail.com' }
  s.source           = { :git => 'https://github.com/AlexHmelevski/ALEither.git', :tag => s.version.to_s }


  s.ios.deployment_target = '8.0'

  s.source_files = 'ALEither/Classes/**/*'

end
