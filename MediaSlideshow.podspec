#
# Be sure to run `pod lib lint MediaSlideshow.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "MediaSlideshow"
  s.version          = "2.1.1"
  s.summary          = "Image (and optionally, video) slideshow written in Swift with circular scrolling, timer and full screen viewer"

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!  
  s.description      = <<-DESC
Media slideshow is a Swift library providing customizable image (and optionally, video) slideshow with circular scrolling, timer and full screen viewer and extendable media source (AFNetworking image source available in AFURL subspec).
                         DESC

  s.homepage         = "https://github.com/pm-dev/MediaSlideshow"
  s.screenshots     = "https://dzwonsemrish7.cloudfront.net/items/2R06283n040V3P3p0i42/ezgif.com-optimize.gif"
  s.license          = 'MIT'
  s.author           = { "Petr Zvonicek" => "zvonicek@gmail.com" }
  s.source           = { :git => "https://github.com/pm-dev/MediaSlideshow.git", :tag => s.version.to_s }

  s.swift_versions = ['4.0', '4.1', '4.2', '5', '5.1', '5.2']
  s.platform     = :ios, '10.0'
  s.requires_arc = true

  s.subspec 'Core' do |core|
    core.source_files = 'MediaSlideshow/Source/**/*'
    core.resources = 'MediaSlideshow/Resources/*.*'
  end

  s.subspec 'Alamofire' do |subspec|
    subspec.dependency 'MediaSlideshow/Core'
    subspec.dependency 'AlamofireImage', '~> 4.0'
    subspec.source_files = 'MediaSlideshowAlamofire/Source/**/*.swift'
  end

  s.subspec 'SDWebImage' do |subspec|
    subspec.dependency 'MediaSlideshow/Core'
    subspec.dependency 'SDWebImage', '>= 3.7'
    subspec.source_files = 'MediaSlideshowSDWebImage/Source/**/*.swift'
  end

  s.subspec 'Kingfisher' do |subspec|
    subspec.dependency 'MediaSlideshow/Core'
    subspec.dependency 'Kingfisher', '> 3.0'
    subspec.source_files = 'MediaSlideshowKingfisher/Source/**/*.swift'
  end

  s.default_subspec = 'Core'

end
