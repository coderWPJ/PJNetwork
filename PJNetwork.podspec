Pod::Spec.new do |s|
  s.name = "PJNetwork"
  s.version = "1.2.9"
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

  s.subspec 'Reachability' do |ss|
    ss.ios.deployment_target = '7.0'
    ss.osx.deployment_target = '10.9'
    ss.tvos.deployment_target = '9.0'
    ss.source_files = 'PJNetwork/Reachability/*.{h,m}'
    ss.public_header_files = 'PJNetwork/Reachability/PJ_Reachability.h'
    ss.frameworks = 'SystemConfiguration'
  end

  s.ios.deployment_target = "8.0"
  s.framework = "CFNetwork"
  s.dependency "AFNetworking"

end
