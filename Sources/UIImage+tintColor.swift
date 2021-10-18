//
//  UIImage+tintColor.swift
//  Battery
//
//  Created by ShenYj on 2021/10/18.
//
//  Copyright (c) 2021 ShenYj <shenyanjie123@foxmail.com>
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

extension UIImage {
    
    /// 将已有图片重新绘制颜色
    ///
    /// - Note: `iOS 13`直接使用新`API`完成, 低于`13.0`下重新绘制失败返回原图
    ///
    func render(WithColor renderColor: UIColor?) -> UIImage {
        guard let newColor = renderColor else {
            return self
        }
        if #available(iOS 13.0, *) {
            //return self.withTintColor(newColor)
            return self.withTintColor(newColor, renderingMode: .alwaysOriginal)
        } else {
            UIGraphicsBeginImageContextWithOptions(size, false, 0.0)
            newColor.setFill()
            let bounds = CGRect(x: 0, y: 0, width: size.width, height: size.height)
            UIRectFill(bounds)
            draw(in: bounds, blendMode: .overlay, alpha: 1.0)
            draw(in: bounds, blendMode: .destinationIn, alpha: 1.0)
            let image = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            return image ?? self
        }
    }
}

