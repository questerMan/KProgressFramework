//
//  KWaveProgressView.swift
//  KProgressFramework
//
//  Created by 疯狂1024 on 2020/9/11.
//  Copyright © 2020 疯狂1024. All rights reserved.
//

import UIKit

@objc public enum TYPE_ENUM:Int {
    case circleType = 0
    case squareType = 1
    case triangleType = 2
}

@objc public class KWaveProgressView: KBaseProgressView {
    
    private var displayLink: CADisplayLink?    ///  定时器
    private var wave_amplitude: CGFloat?       ///  振幅a    （  y = asin( wx + φ ) + k  ）
    private var  wave_cycle: CGFloat?          ///  周期w
    private var  wave_h_distance: CGFloat?     ///  两个波水平之间偏移
    private var  wave_v_distance: CGFloat?     ///  两个波竖直之间偏移
    private var  wave_scale: CGFloat?          ///  水波速率
    private var  wave_offsety: CGFloat?        ///  波峰所在位置的y坐标
    private var  wave_move_width: CGFloat?     ///  移动的距离，配合速率设置
    private var  wave_offsetx: CGFloat?        ///  偏移
    private var  offsety_scale: CGFloat?       ///  上升的速度
    
    private var type:TYPE_ENUM = .circleType   ///  形状类型，默认圆形
    
    public var progress:CGFloat = 0.0 {
        didSet {
            self.setupLogic()
        }
    }
    
    private lazy var setupOneUI: Void = {
        setupConfig()
    }()
    
    @objc public override func layoutSubviews() {
        super.layoutSubviews()
        let _ = setupOneUI
    }
    override init(frame: CGRect) {
        super.init(frame: frame)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    @objc public override func draw(_ rect: CGRect) {
        self.progresseLabel.text = String(format: "%.0f%%", (self.progress * 100.0))
        
        // 绘制两个波形图
        self.drawWaveColor(color: (self.progressColor ?? UIColor.green), offsetx: 0, offsety: 0)
        self.drawWaveColor(color: (self.progressColor ?? UIColor.green).withAlphaComponent(0.5), offsetx: self.wave_h_distance ?? 0, offsety: self.wave_v_distance ?? 0)
    }
    
    deinit {
        self.removeDisplayLinkAction()
    }
}
/// MARK :  private Method 私有方法
extension KWaveProgressView {
    private func setType(rect: CGRect) {
        
        switch self.type {
        case .circleType:

            let newRect = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
            let maskPath = UIBezierPath.init(roundedRect: newRect, cornerRadius: rect.size.width/2)
            let shapeLayer = CAShapeLayer.init()
            //设置大小
            shapeLayer.frame = CGRect(x: 0, y: 0, width: rect.size.width, height: rect.size.height)
            //设置圆形的样子
            shapeLayer.path = maskPath.cgPath
            self.layer.mask = shapeLayer
            
        case .triangleType:
            
            let width = rect.size.width
            let height = rect.size.height
            let pointPath1 = CGPoint(x: width/2, y: 0)
            let pointPath2 = CGPoint(x: width , y: height)
            let pointPath3 = CGPoint(x: 0, y: height)
            let bezierPath = UIBezierPath()
            bezierPath.move(to: pointPath1)
            bezierPath.addLine(to: pointPath2)
            bezierPath.addLine(to: pointPath3)
            bezierPath.close()
            let shapeLayer = CAShapeLayer()
            shapeLayer.path = bezierPath.cgPath
            self.layer.mask = shapeLayer
            
        default:
            break
        }
        
        
    }
    
    private func setupConfig() {
        let size:CGFloat = min(frame.size.width, frame.size.height)
        var rect:CGRect = self.frame
        rect.size = CGSize(width: size, height: size)
        self.frame = rect
        
        let M_PI = CGFloat.pi
        // 振幅
        self.wave_amplitude = self.frame.size.height / 25
        // 周期
        self.wave_cycle = 2 * M_PI / (self.frame.size.width * 0.9)
        // 两个波水平之间偏移
        self.wave_h_distance = 2 * M_PI / (wave_cycle ?? 0) * 0.6
        // 两个波竖直之间偏移
        self.wave_v_distance = (wave_amplitude ?? 0) * 0.4
        // 移动的距离，配合速率设置
        self.wave_move_width = 0.5
        // 水波速率
        self.wave_scale = 0.4
        // 上升的速度
        self.offsety_scale = 0.1
        // 波峰所在位置的y坐标，刚开始的时候_wave_offsety是最大值
        self.wave_offsety = (self.frame.size.height + 2 * (wave_amplitude ?? 0))
        
        self.backgroundColor = self.bgColor
        self.addDisplayLinkAction()
        self.bringSubviewToFront(progresseLabel)
        self.progresseLabel.text = String(format: "%.0f%%", (self.progress * 100.0))
        self.progresseLabel.frame = self.bounds
        let scale = self.bounds.height / kScaleWidth(100)
        self.progresseLabel.font = UIFont.boldSystemFont(ofSize: kFontSize(13)*scale)
        
        self.setType(rect: rect)
    }
    
    
    private func drawWaveColor(color: UIColor, offsetx: CGFloat, offsety: CGFloat) {
        // 波浪动画，进度的实际操作范围是，多加上两个振幅的高度，到达设置进度的位置y
        let end_offY: CGFloat = (1.0 - self.progress) * (self.frame.size.height + 2 * (self.wave_amplitude ?? 0))
        if (self.wave_offsety ?? 0) != end_offY {
            if end_offY < (self.wave_offsety ?? 0) {
                let num = (((self.wave_offsety ?? 0) - end_offY) * (self.offsety_scale  ?? 0))
                self.wave_offsety = (self.wave_offsety ?? 0) -  num
                self.wave_offsety = max((self.wave_offsety ?? 0), end_offY)
            } else {
                let num = (end_offY - (self.wave_offsety ?? 0)) * (self.offsety_scale ?? 0)
                self.wave_offsety = (self.wave_offsety ?? 0) + num
                self.wave_offsety = min(self.wave_offsety ?? 0, end_offY)
            }
        }
        
        let wavePath:UIBezierPath = UIBezierPath()
        
        for next_x in 0...Int(self.frame.size.width) {
            // 正弦函数，绘制波形
            let k:CGFloat = (self.wave_offsety ?? 0) + offsety
            let s:CGFloat = (self.wave_offsetx ?? 0) + offsetx / self.bounds.size.width * 2 * CGFloat.pi
            let next_y: CGFloat = (self.wave_amplitude ?? 0) * sin((self.wave_cycle ?? 0) * CGFloat(next_x) + s) + k;
            if (next_x == 0) {
                wavePath.move(to: CGPoint(x: CGFloat(next_x), y: next_y - (self.wave_amplitude ?? 0)))
            } else {
                wavePath.addLine(to: CGPoint(x: CGFloat(next_x), y: next_y - (self.wave_amplitude ?? 0)))
            }
        }
        
        wavePath.addLine(to: CGPoint(x: self.frame.size.width, y: self.frame.size.height))
        wavePath.addLine(to: CGPoint(x: 0, y: self.frame.size.height))
        color.setFill()
        wavePath.fill()
        
        switch self.type {
        case .circleType:
            
            let r = CGRect(x: 0, y: 0, width:  self.frame.size.width, height:  self.frame.size.height)
            let linePath:UIBezierPath = UIBezierPath(roundedRect: r, cornerRadius: r.size.width/2)
            linePath.lineWidth = self.lineWidth ?? 0
            self.lineColor?.setStroke()
            linePath.stroke()
            
        case .triangleType:
            let width = self.frame.size.width
            let height = self.frame.size.height
            let pointPath1 = CGPoint(x: width/2, y: 0)
            let pointPath2 = CGPoint(x: width , y: height)
            let pointPath3 = CGPoint(x: 0, y: height)
            
            let linePath = UIBezierPath()
            linePath.move(to: pointPath1)
            linePath.addLine(to: pointPath2)
            linePath.addLine(to: pointPath3)
            linePath.close()
            linePath.lineWidth = self.lineWidth ?? 0
            self.lineColor?.setStroke()
            linePath.stroke()
            
        default:
            let width = self.frame.size.width
            let height = self.frame.size.height
            let pointPath1 = CGPoint(x: width, y: 0)
            let pointPath2 = CGPoint(x: width , y: height)
            let pointPath3 = CGPoint(x: 0, y: height)
            let pointPath4 = CGPoint(x: 0, y: 0)
            let linePath = UIBezierPath()
            linePath.move(to: pointPath1)
            linePath.addLine(to: pointPath2)
            linePath.addLine(to: pointPath3)
            linePath.addLine(to: pointPath4)
            linePath.close()
            linePath.lineWidth = self.lineWidth ?? 0
            self.lineColor?.setStroke()
            linePath.stroke()
        }
        
    }
}
/// MARK :  private Method 私有方法
extension KWaveProgressView {
    private func addDisplayLinkAction() {
        if (self.displayLink == nil) {
            self.displayLink = CADisplayLink(target: self, selector: #selector(self.handledisplayLinkAction))
            self.displayLink?.isPaused = false
            // 设置触发频率
            if #available(iOS 3.1, *) {
                //设置一秒内有几帧刷新，默认60，即是一秒内有60帧执行刷新调用。
                self.displayLink?.preferredFramesPerSecond = 60
            }else {
                self.displayLink?.frameInterval = 1  // 60/1次
            }
            self.displayLink?.add(to: RunLoop.current, forMode: .common)
        }
    }
    
    @objc private func handledisplayLinkAction() {
        wave_offsetx = (wave_offsetx ?? 0) + ((wave_move_width ?? 0) * (wave_scale ?? 0))
        if (wave_offsety ?? 0) <= 0.01 {
            self.removeDisplayLinkAction()
        }
        self.setNeedsDisplay()
    }
    
    // MARK: 设置进度逻辑
    private func setupLogic() {
        if progress > 1.0 {
            progress = 1.0
        } else if progress < 0 {
            progress = 0.0
        }
        
        self.addDisplayLinkAction()
    }
    // MARK: 设置UI界面
    private func setupUI() {
        
    }
    
    private func removeDisplayLinkAction() {
        self.displayLink?.invalidate()
        self.displayLink = nil
    }
}

/// MARK : Public  Method 公共接口KPI方法
extension KWaveProgressView {
    @discardableResult // 取消警告
    public static func initProgressView(_ progressBlock: (KWaveProgressView) -> Void) -> KWaveProgressView {
        let progressView = KWaveProgressView()
        progressBlock(progressView)
        return progressView
    }
}

/// MARK : Public  Method 公共接口KPI方法
extension KWaveProgressView {
    @discardableResult // 取消警告
    public func K_MakeProgress(_ progress: CGFloat) -> KWaveProgressView {
        self.progress = progress
        return self
    }
    @discardableResult // 取消警告
    public func K_MakeType(_ type: TYPE_ENUM) -> KWaveProgressView {
        self.type = type
        return self
    }
    @discardableResult // 取消警告
    public func K_MakeAddSuperView(_ view: UIView) -> KWaveProgressView {
        view.addSubview(self)
        return self
    }
    @discardableResult // 取消警告
    public func K_MakeBGColor(_ bgColor: UIColor) -> KWaveProgressView{
        self.bgColor = bgColor
        return self
    }
    @discardableResult // 取消警告
    public func K_MakeProgressColor(_ progressColor: UIColor) -> KWaveProgressView{
        self.progressColor = progressColor
        return self
    }
    @discardableResult // 取消警告
    public func K_MakeLineColor(_ lineColor: UIColor) -> KWaveProgressView{
        self.lineColor = lineColor
        return self
    }
    @discardableResult // 取消警告
    public func K_MakeLineWidth(_ lineWidth: CGFloat) -> KWaveProgressView{
        self.lineWidth = lineWidth
        return self
    }
    @discardableResult // 取消警告
    public func K_MakeFrame(_ frame: CGRect) -> KWaveProgressView{
        self.frame = frame
        return self
    }
}
