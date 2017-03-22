# Uncomment this line to define a global platform for your project
# run: pod install --no-repo-update
platform :ios, '8.0'
# 工程不显示任何警告
inhibit_all_warnings!

def thirdparty_pods
  pod 'SDWebImage'
  pod 'SDWebImage/WebP'
  pod 'libwebp', :git => 'http://192.168.30.6/shengming.han/libwebp.git'
end

target 'WebKitSupportURLProtocol' do
  thirdparty_pods
end