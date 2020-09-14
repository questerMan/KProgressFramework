//
//  KBaseProgressView.swift
//  KProgressFramework
//
//  Created by 疯狂1024 on 2020/9/1.
//  Copyright © 2020 疯狂1024. All rights reserved.
//

import UIKit

@objc public class KBaseProgressView: UIView {

    /// 背景颜色（默认白色）
    internal var bgColor:UIColor?
    /// 进度颜色（默认绿色）
    internal var progressColor:UIColor?
    /// 边框线条颜色（默认灰色）
    internal var lineColor:UIColor?
    /// 边框线条大小（默认1.0）
    internal var lineWidth:CGFloat?
    /// 字体标签（默认字体黑色/居中显示/隐藏）
    @objc public lazy var progresseLabel:UILabel = {
        let lab = UILabel(frame: self.bounds)
        lab.numberOfLines = 1
        lab.textAlignment = .center
        lab.textColor = .black
        lab.font = UIFont.boldSystemFont(ofSize: kFontSize(13))
        lab.text = "0%"
        return lab
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupConfig()
        self.addSubview(progresseLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
/// MARK :  private Method 私有方法
extension KBaseProgressView {
    private func setupConfig() {
        bgColor = .white
        progressColor = .green
        lineColor = .gray
        lineWidth = kScaleWidth(1.0)
    }
}
