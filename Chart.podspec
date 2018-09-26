Pod::Spec.new do |s|
  s.name         = "Chart"
  s.version      = "0.0.1"
  s.summary      = "develop tools."
  s.homepage     = "https://github.com/wangerdong/ZKTools"
  s.license      = "MIT"
  s.author       = { "Evan" => "83179835@qq.com" }
  s.source       = { :git => "https://github.com/wangerdong/ZKTools.git", :tag => "#{s.version}", :submodules => true }
  s.public_header_files = "Chart/ZKChartView.h"
  s.source_files  = "Chart/ZKChartView.h"
  s.requires_arc = true
end
