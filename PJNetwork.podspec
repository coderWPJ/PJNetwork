Pod::Spec.new do |s|
  s.name = "PJNetwork"
  s.version = "1.0.3"
  s.summary = "PJNetwork is a high level request util based on AFNetworking."
  s.homepage = "https://github.com/coderWPJ"
  s.license= "MIT"
  s.author = {
    "WPJ" => "331321408@qq.com",
  }
  s.source = { :git => "https://github.com/coderWPJ/PJNetwork.git", :tag => s.version }
  s.source_files = "PJNetwork/*.{h,m}"
  s.requires_arc = true
#s.private_header_files = "PJNetwork/PJNetwork.h"
  s.ios.deployment_target = "8.0"
  s.framework = "CFNetwork"
  s.dependency "AFNetworking", "~> 3.1"

end
