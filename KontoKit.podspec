Pod::Spec.new do |s|
  s.name         = "KontoKit"
  s.version      = "0.0.1"
  s.summary      = "A library for creating German Bank account forms (copied from PaymentKit)."
  s.homepage     = "https://github.com/kashif/kontokit"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.authors      = { "Kashif Rasul" => "kashif.rasul@gmail.com", "Shoaib Burq" => "saburq@gmail.com" }

  s.source       = { :git => "https://github.com/kashif/kontokit.git", :tag => "0.0.1" }
  s.platform     = :ios
  s.source_files = 'KontoKit/*.{h,m}'
  s.resources    = "KontoKit/Resources/Cards/*.png", "KontoKit/Resources/*.png"

  s.framework  = 'QuartzCore'
  s.requires_arc = true
end
