//
//  KLineProgressView.swift
//  KProgressFramework
//
//  Created by 陆遗坤 on 2020/9/1.
//  Copyright © 2020 陆遗坤. All rights reserved.
//

import UIKit

@objc public class KLineProgressView: KBaseProgressView {
    
    var originXY:CGFloat = kScaleWidth(1.0)
    
    @objc public lazy var progressView: UIView = {
        let view = UIView()
        view.backgroundColor = self.progressColor
        return view
    }()
    
    public var progress:CGFloat = 0.0 {
        didSet {
            setupLogic()
        }
    }
    lazy var setupOneUI: Void = {
        setupUI()
    }()
    
    @objc public override func layoutSubviews() {
        super.layoutSubviews()
        let _ = setupOneUI
    }
}
/// MARK :  private Method 私有方法
extension KLineProgressView {
    // MARK: 设置进度逻辑
    private func setupLogic() {
        if progress > 1.0 {
            progress = 1.0
        } else if progress < 0 {
            progress = 0.0
        }
        
        let origin = (self.lineWidth ?? 0) + self.originXY
        let height = self.frame.height - origin*2
        let width = (self.frame.width - origin*2)*progress
        
        UIView.animate(withDuration: 0.5) {
            self.progressView.frame = CGRect(x: origin, y: origin, width: width, height: height)
            self.progresseLabel.text = String(format: "%.0f%%", self.progress*100)
        }
    }
    // MARK: 设置UI界面
    private func setupUI() {
        self.layer.borderColor = self.lineColor?.cgColor
        self.layer.borderWidth = self.lineWidth ?? 0
        self.backgroundColor = self.bgColor
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
       
        self.addSubview(progressView)
        let origin = (self.lineWidth ?? 0) + self.originXY
        let height = self.frame.height - origin*2
        let width = (self.frame.width - origin*2)*progress
        
        self.progressView.frame = CGRect(x: origin, y: origin, width: width, height: height)
        self.progressView.layer.cornerRadius = height/2
        self.progressView.layer.masksToBounds = true
        
        self.bringSubviewToFront(progresseLabel)
        self.progresseLabel.frame = self.bounds
        let scale = self.frame.height / kScaleWidth(20)
        self.progresseLabel.font = UIFont.boldSystemFont(ofSize: kFontSize(13)*scale)
        
    }
}

/// MARK : Public  Method 公共接口KPI方法
extension KLineProgressView {
    @discardableResult // 取消警告
    @objc public static func initProgressView(_ progressBlock: (KLineProgressView) -> Void) -> KLineProgressView {
        let progressView = KLineProgressView()
        progressBlock(progressView)
        return progressView
    }
}

/// MARK : Public  Method 公共接口KPI方法
extension KLineProgressView {
    @discardableResult // 取消警告
    public func K_MakeProgress(_ progress: CGFloat) -> KLineProgressView {
        self.progress = progress
        return self
    }
    @discardableResult // 取消警告
    public func K_MakeAddSuperView(_ view: UIView) -> KLineProgressView {
        view.addSubview(self)
        return self
    }
    @discardableResult // 取消警告
    public func K_MakeBGColor(_ bgColor: UIColor) -> KLineProgressView{
        self.bgColor = bgColor
        return self
    }
    @discardableResult // 取消警告
    public func K_MakeProgressColor(_ progressColor: UIColor) -> KLineProgressView{
        self.progressColor = progressColor
        return self
    }
    @discardableResult // 取消警告
    public func K_MakeLineColor(_ lineColor: UIColor) -> KLineProgressView{
        self.lineColor = lineColor
        return self
    }
    @discardableResult // 取消警告
    public func K_MakeLineWidth(_ lineWidth: CGFloat) -> KLineProgressView{
        self.lineWidth = lineWidth
        return self
    }
    @discardableResult // 取消警告
    public func K_MakeFrame(_ frame: CGRect) -> KLineProgressView{
        self.frame = frame
        return self
    }
}
