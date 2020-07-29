#
#  Be sure to run `pod spec lint MKMagneticProgress.podspec' to ensure this is a
#  valid spec and to remove all comments including this before submitting the spec.
#
#  To learn more about Podspec attributes see https://guides.cocoapods.org/syntax/podspec.html
#  To see working Podspecs in the CocoaPods repo see https://github.com/CocoaPods/Specs/
#

Pod::Spec.new do |spec|
  
  spec.name         = "MKMagneticProgress"
  spec.version      = "1.4"
  spec.summary      = "A circular progress bar for iOS written in Swift"
  
  spec.description  = <<-DESC
MKMagneticProgress is a circular progress bar for iOS written in Swift, easy to customizd via Interface builder or by code
                   DESC
  
  spec.homepage     = "https://github.com/Shebuka/MKMagneticProgress"
  spec.screenshots  = "https://github.com/Shebuka/MKMagneticProgress/raw/master/demo.gif", "https://github.com/Shebuka/MKMagneticProgress/raw/master/IB.gif"
  spec.license      = { :type => "MIT", :file => "LICENSE" }
  
  spec.authors          = { "Anton Shebukov" => "email@address.com", "Moayad Al kouz" => "moayad_kouz9@hotmail.com" }
  spec.social_media_url = "https://twitter.com/Shebuka"
  
  spec.platform     = :ios, "11.0"
  spec.swift_versions   = ['5.0']
  spec.source       = { :git => "https://github.com/Shebuka/MKMagneticProgress.git", :tag => "#{spec.version}" }
  
  spec.source_files = "MKMagneticProgress/Classes/**/*.{swift}"
  
  spec.requires_arc = true
  
end
