Pod::Spec.new do |s|
  s.name         = "WFExtension"
  s.version      = "1.0.2"
  s.summary      = "字典/模型转化库"
  s.homepage     = "https://github.com/CWFJ/WFExtension"
  s.license      = "MIT"
  s.authors      = { 'WF Chia' => '345609097@qq.com'}
  s.platform     = :ios, "6.0"
  s.source       = { :git => "https://github.com/CWFJ/WFExtension.git", :tag => s.version }
  s.source_files = "WFExtension/Classes/WFExtension/*.{h,m}"
  s.requires_arc = true
end
