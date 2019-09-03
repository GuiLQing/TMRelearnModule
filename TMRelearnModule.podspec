#
# Be sure to run `pod lib lint TMRelearnModule.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'TMRelearnModule'
  s.version          = '1.0.0.2'
  s.summary          = 'A short description of TMRelearnModule.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC

  s.homepage         = 'https://github.com/GuiLQing/TMRelearnModule.git'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'GuiLQing' => 'gui950823@126.com' }
  s.source           = { :git => 'https://github.com/GuiLQing/TMRelearnModule.git', :tag => s.version.to_s }

  s.ios.deployment_target = '9.0'

  s.source_files = 'TMRelearnModule/Classes/TMRelearnModule/**/*'
  s.resources = 'TMRelearnModule/Classes/TMRelearnModule.bundle'
  
  s.dependency 'AFNetworking'
  s.dependency 'Masonry'
  s.dependency 'MJRefresh'
  s.dependency 'MJExtension'
  s.dependency 'YJNetManager'
  s.dependency 'SGTools/SGSingleAudioPlayer'
  s.dependency 'SGTools/SGSpeechSynthesizer'
  s.dependency 'SGTools/SGVocabularyDictation'
  s.dependency 'MarqueeLabel', '3.2.0'
  s.dependency 'ReactiveObjC'
  s.dependency 'YJTaskMark'
  s.dependency 'SGTools/SGTriangleView'
  s.dependency 'SGTools/SGVocabularyDictation'
  s.dependency 'SGTools/SGGradientProgress'
  s.dependency 'PSGChainedMode'
  s.dependency 'YJBaseModule'
  
end
