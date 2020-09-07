//
//  KDefaultMacro.swift
//  KProgressFramework
//
//  Created by 陆遗坤 on 2020/9/1.
//  Copyright © 2020 陆遗坤. All rights reserved.
//

import UIKit

let KScreen_Width = UIScreen.main.bounds.width
let KScreen_Height = UIScreen.main.bounds.height

// iphone6s为适配的宽度尺寸比例
func kScaleWidth(_ width:CGFloat) -> CGFloat { return ((width)*(KScreen_Width/375.0))}
// 判断是否iphone6P
let IsIphone6P = (KScreen_Width == 414.0 ? true : false)

let KSizeScale = (IsIphone6P ? 1.2 : 1)
// 字体适配
func kFontSize(_ value:CGFloat) -> CGFloat{ return value * CGFloat(KSizeScale)}

class KDefaultMacro: NSObject {

}
