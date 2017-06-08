

Pod::Spec.new do |s|

  s.name         = "BBAD"
  s.version      = "1.0.1"
  s.summary      = "BBAD"

  s.description  = <<-DESC
                        BBAD
                   DESC

  s.homepage     = "https://github.com/Djw2017/BBAD"
 
  s.license      = {:type => "MIT",:file => "LICENSE"}

  s.author             = { "Dong JW" => "1971728089@qq.com" }
 
  s.platform     = :ios, "7.0"

  s.source       = { :git => "https://github.com/Djw2017/BBAD.git" }

  s.subspec 'Main' do |mainn|
    mainn.source_files = 'BBAD/Main/*'
    mainn.public_header_files = 'BBAD/Main/*.h'
    mainn.dependency 'BBAD/Babybus'
  end
  s.subspec 'Babybus' do |bb|
    bb.source_files = 'BBAD/Babybus/*'
    bb.public_header_files = 'BBAD/Babybus/*.h'
  end


 # s.subspec 'GDT' do |gdtt|
 #   gdtt.source_files = 'BBAD/GDT/*'
  #  gdtt.public_header_files = 'BBAD/GDT/*.h'
  #  gdtt.pod_target_xcconfig = {'GCC_PREPROCESSOR_DEFINITIONS' => 'ADPLATFORMGDT=1'}
 #   gdtt.vendored_libraries = 'BBAD/GDT/Framework/libGDTMobSDK.a'
  #  gdtt.dependency 'BBAD/Main'

  #  gdtt.subspec 'Framework' do |fw|
  #    fw.source_files = 'BBAD/GDT/Framework/*'
  #    fw.public_header_files = 'BBAD/GDT/Framework/*.h'
      
      
  #  end

  #end

 
  s.resource = 'BBAD/Main/BBAD.bundle'

  #s.frameworks = "UIKit"

  s.requires_arc = true

  # s.xcconfig = { "HEADER_SEARCH_PATHS" => "$(SDKROOT)/usr/include/libxml2" }

  s.dependency 'BBNetwork'
  s.dependency 'BBSDK'
  s.dependency 'SDWebImage',  '~> 4.0.0'
  s.dependency 'Masonry',     '~> 1.0.2'

end
