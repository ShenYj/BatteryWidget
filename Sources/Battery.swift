//
//  Battery.swift
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
import Foundation

fileprivate let horizontalMarginLeft: CGFloat = 10
fileprivate let horizontalMarginRight: CGFloat = 15
fileprivate let horizontalItemSpacing: CGFloat = 3
fileprivate let verticalMargin: CGFloat = 8
fileprivate let unitPowerCount: Int = 10


open class Battery: UIView {
    
    /// `DEBUG Mode`下开启有效
    public var debugMode: Bool = false
    
    /// 精准度, 默认为`true`, 设置为`false`电量百分比将四舍五入后展示
    public var highAccuracy: Bool = true
    
    /// `电量百分比: 0 ~ 1`
    public var progress: CGFloat = 0 { didSet { setBattery(Power: progress) } }
        
    
    /// `边框 覆盖层`
    lazy var batteryBorderImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = self.bounds
        imageView.contentMode = .scaleAspectFit
        imageView.image = batteryLevelBorderImage
        return imageView
    }()
    
    /// `剩余电量`
    lazy var remainingPowerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: horizontalMarginLeft, y: verticalMargin, width: batteryPowerSize.width, height: batteryPowerSize.height)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.mask = shapeLayer
        imageView.backgroundColor = .clear
        return imageView
    }()
    /// `已用电量`
    fileprivate lazy var usedPowerImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.frame = CGRect(x: horizontalMarginLeft, y: verticalMargin, width: batteryPowerSize.width, height: batteryPowerSize.height)
        imageView.contentMode = .scaleAspectFit
        imageView.layer.mask = shapeLayer
        imageView.backgroundColor = .clear
        return imageView
    }()
    
    /// `渲染layer`
    fileprivate lazy var shapeLayer: CAShapeLayer = {
        let shapelayer = CAShapeLayer()
        shapelayer.frame = CGRect(x: 0, y: 0, width: batteryPowerSize.width, height: batteryPowerSize.height)
        shapelayer.strokeColor = UIColor.clear.cgColor
        shapelayer.fillColor = UIColor.white.cgColor
        shapelayer.lineCap = .butt
        shapelayer.contentsScale = UIScreen.main.scale
        shapelayer.contentsGravity = .resizeAspect
        shapelayer.lineWidth = batteryPowerSize.height
        return shapelayer
    }()
    
    
    /// 电量区域尺寸 去除了间距
    fileprivate lazy var batteryPowerSize = CGSize(width: self.frame.width - horizontalMarginLeft - horizontalMarginRight, height: self.frame.height - 2*verticalMargin)
    
    fileprivate var unitPowerWidth: CGFloat = 0
    fileprivate var unitPowerHeight: CGFloat = 0
    
    fileprivate var path: UIBezierPath = UIBezierPath(rect: CGRect.zero)
    
    required public init(size: CGSize) {
        super.init(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        setProperties()
        setupUI()
    }
    
    required public init?(coder: NSCoder) {
        super.init(frame: .zero)
        setProperties()
        setupUI()
    }
}

public extension Battery {
    
    fileprivate func setBattery(Power progress: CGFloat) {
        
#if DEBUG
        if debugMode { print("\(#file)-\(#line)电池电量: \(progress)") }
#endif
        var borderColor: UIColor? = nil
        var usedColor: UIColor? = nil
        var remainingColor: UIColor? = nil
        
        switch progress {
        case 0..<0.5:
            borderColor = UIColor(hex: "#F01C1C").alpha(0.3)
            usedColor = UIColor(hex: "#F01C1C").alpha(0.3)
            remainingColor = UIColor(hex: "#F01C1C").alpha(0.3)
        case 0.5...:
            borderColor = UIColor(hex: "#32BA6C")
            usedColor = UIColor(hex: "#B1B1B1")
            remainingColor = UIColor(hex: "#32BA6C")
        default:
            borderColor = UIColor(hex: "#B1B1B1").alpha(0.3)
            usedColor = UIColor(hex: "#B1B1B1").alpha(0.3)
            remainingColor = UIColor(hex: "#B1B1B1").alpha(0.3)
        }
        
        batteryBorderImageView.image = batteryLevelBorderImage?.render(WithColor: borderColor)
        usedPowerImageView.image = batteryLevelImage?.render(WithColor: usedColor)
        remainingPowerImageView.image = batteryLevelImage?.render(WithColor: remainingColor)
        
        var progressWidth: CGFloat = 0
        let levelItemProgressWidth = batteryPowerSize.width * progress
        let fullItemCount = Int(levelItemProgressWidth / unitPowerWidth)
        
        let fullItemWidth = CGFloat(fullItemCount) * unitPowerWidth
        let percentItemWidth = levelItemProgressWidth - fullItemWidth
        
        switch (highAccuracy, percentItemWidth > 0, percentItemWidth > 0.5) {
        case (true, true, _):   progressWidth += levelItemProgressWidth + ( CGFloat(fullItemCount) * horizontalItemSpacing)
        case (true, false, _):  progressWidth += levelItemProgressWidth + ( CGFloat(fullItemCount - 1) * horizontalItemSpacing )
        case (false, _, true):  progressWidth += (CGFloat(fullItemCount + 1) * unitPowerWidth + CGFloat(fullItemCount) * horizontalItemSpacing)
        case (false, _, false): progressWidth += (CGFloat(fullItemCount) * unitPowerWidth + CGFloat(fullItemCount - 1) * horizontalItemSpacing)
        }
        
        path = UIBezierPath(rect: CGRect(x: 0, y: verticalMargin, width: progressWidth, height: unitPowerHeight))
        
        shapeLayer.path = path.cgPath
        shapeLayer.strokeEnd = progress
    }
}

extension Battery {
    
    fileprivate func setProperties() {
        unitPowerWidth = (batteryPowerSize.width - CGFloat(unitPowerCount - 1) * horizontalItemSpacing) / CGFloat(unitPowerCount)
        unitPowerHeight = (batteryPowerSize.height - 2 * verticalMargin)
        
        setBattery(Power: 0)
    }
}


extension Battery {
    
    fileprivate func setupUI() {
        
        backgroundColor = .clear
        addSubview(batteryBorderImageView)
        addSubview(usedPowerImageView)
        addSubview(remainingPowerImageView)
    }
}

extension Battery {
    
    fileprivate var batteryLevelBorderImage: UIImage? { UIImage(contentsOfFile: bundle?.path(forResource: "battery_border_gray".scaleName, ofType: "png") ?? "") }
    fileprivate var batteryLevelImage: UIImage? { UIImage(contentsOfFile: bundle?.path(forResource: "battery_level_item_gray".scaleName, ofType: "png") ?? "") }
    
    fileprivate var bundle: Bundle? { Bundle(path: Bundle(for: Battery.self).path(forResource: "icons", ofType: "bundle") ?? "") }
}
