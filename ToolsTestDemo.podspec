Pod::Spec.new do |s|

  s.name         = "ToolsTestDemo"
  s.version      = "0.0.1"
  s.summary      = "ZJToolHelper SDK"
  s.homepage     = "https://github.com/zhangjiang1203/ToolsTestDemo"
  s.license      = { :type => "Copyright", :file => "Copyright zhangjiang" }
  s.author             = { "zhangjiang" => "896884553@q.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/zhangjiang1203/ToolsTestDemo.git", :tag => "0.0.1" }

  s.source_files  = "Classes", "**/ToolsTestDemo/ZJToolHelper/*.{h,m}"
  s.frameworks = "UIKit", "Foundation"
  s.requires_arc = true

end
