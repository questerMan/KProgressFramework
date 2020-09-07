
# KProgressFramework Swift条形进度条
![Image](https://github.com/questerMan/KProgressFramework/blob/master/progressView.png)

特 点：

      Swift语言封装的简易进度条，使用链式编程思想进行创建，使代码更加优雅！
      
      你可以根据需要对进度条进行修改文本标签、背景边框等样式进行自定义。
      
cocoapod导入:

      platform :ios, '13.0'

      target 'demoName' do
        use_frameworks!
        pod 'KProgressFramework', '~> 1.0.1'
      end

使用：类似Masonry进行编写

      /// MARK - 1.创建：必须 必须 必须 通过initProgressView类方法进行实例化创建

      let progressView = KLineProgressView.initProgressView { (make) in    
          make.K_MakeAddSuperView(self) // 在self上显示
              .K_MakeProgress(0.5)      // 当前进度初始值
              .K_MakeLineColor(.black)  // 进度条边框颜色
              .K_MakeBGColor(.white)    // 进度条背景颜色
      }

初始化方法如下：

      /// initProgressView（类方法）

属性列表如下：

      /// K_MakeBGColor                 背景颜色（默认白色）

      /// K_MakeProgressColor           进度颜色（默认绿色）

      /// K_MakeLineColor               边框线条颜色（默认灰色）

      /// K_MakeLineWidth               边框线条大小（默认1.0）

      /// var progresseLabel：UILabel   字体标签（默认字体黑色/居中显示/隐藏）

      /// K_MakeProgress                进度状态（0到1）赋值后实时更新

      /// K_MakeAddSuperView            添加到某视图上

      /// K_MakeFrame                   坐标位置设置
     

