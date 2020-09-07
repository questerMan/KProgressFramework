Pod::Spec.new do |spec|
  spec.name         = "KProgressFramework"
  spec.version      = "1.0.1"
  spec.summary      = "带百分比的Swift条形进度条"
  spec.description  = <<-DESC
  第一次上传CocoaPod！！！
  代码语言：Swift；使用链式编程思想封装的进度条，让代码看起来更加优雅。
                   DESC
  spec.homepage     = "https://github.com/questerMan/KProgressFramework.git"
  spec.license      = "MIT"
  spec.ios.deployment_target = '13.0'
  spec.author             = { "疯狂1024" => "luyikun01@163.com" }
  spec.source       = { :git => "https://github.com/questerMan/KProgressFramework.git", :tag => "#{spec.version}" }
  spec.source_files  = "KProgressFramework", "KProgressFramework/KProgressFramework/KProgressView/**/*.{swift}"
  spec.swift_version = '5.0'
end
