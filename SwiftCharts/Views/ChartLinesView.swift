//
//  ChartLinesView.swift
//  swift_charts
//
//  Created by ischuetz on 11/04/15.
//  Copyright (c) 2015 ivanschuetz. All rights reserved.
//

import UIKit

public protocol ChartLinesViewPathGenerator {
    func generatePath(points: [CGPoint], lineWidth: CGFloat) -> UIBezierPath
}

open class ChartLinesView: UIView {

    open let lineColor: UIColor
    open let lineWidth: CGFloat
    open let lineJoin: LineJoin
    open let lineCap: LineCap
    open let animDuration: Float
    open let animDelay: Float
    open let dashPattern: [Double]?
    
    public init(path: UIBezierPath, frame: CGRect, lineColor: UIColor, lineWidth: CGFloat, lineJoin: LineJoin, lineCap: LineCap, animDuration: Float, animDelay: Float, dashPattern: [Double]?) {
        self.lineColor = lineColor
        self.lineWidth = lineWidth
        self.lineJoin = lineJoin
        self.lineCap = lineCap
        self.animDuration = animDuration
        self.animDelay = animDelay
        self.dashPattern = dashPattern
        
        super.init(frame: frame)

        backgroundColor = UIColor.clear
        show(path: path)
    }

    required public init(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open func generateLayer(path: UIBezierPath) -> CAShapeLayer {
        let lineLayer = CAShapeLayer()
        lineLayer.lineJoin = lineJoin.CALayerString
        lineLayer.lineCap = lineCap.CALayerString
        lineLayer.fillColor = UIColor.clear.cgColor
        lineLayer.lineWidth = lineWidth

        path.apply(CGAffineTransform(translationX: 2, y: 2))

        lineLayer.path = path.cgPath
        lineLayer.strokeColor = lineColor.cgColor
        
        if dashPattern != nil {
            lineLayer.lineDashPattern = dashPattern as [NSNumber]?
        }
        
        if animDuration > 0 {
            lineLayer.strokeEnd = 0.0
            let pathAnimation = CABasicAnimation(keyPath: "strokeEnd")
            pathAnimation.duration = CFTimeInterval(animDuration)
            pathAnimation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
            pathAnimation.fromValue = NSNumber(value: 0 as Float)
            pathAnimation.toValue = NSNumber(value: 1 as Float)
            pathAnimation.autoreverses = false
            pathAnimation.isRemovedOnCompletion = false
            pathAnimation.fillMode = kCAFillModeForwards
            
            pathAnimation.beginTime = CACurrentMediaTime() + CFTimeInterval(animDelay)
            lineLayer.add(pathAnimation, forKey: "strokeEndAnimation")
            
        } else {
            lineLayer.strokeEnd = 1
        }
        
        return lineLayer
    }
    
    fileprivate func show(path: UIBezierPath) {
        let gradientLayer = CAGradientLayer()
        gradientLayer.frame = layer.frame.insetBy(dx: -2, dy: -2, dw: -2, dh: -2)
        let green = UIColor(red: 52/255, green: 211/255, blue: 149/255, alpha: 1.0).cgColor
        let yellow = UIColor.yellow.cgColor
        let orange = UIColor(red: 1.0, green: 109/255, blue: 0, alpha: 1.0).cgColor
        gradientLayer.colors = [orange, yellow, green]
        gradientLayer.locations = [NSNumber(value: 0), NSNumber(value: 0.5), NSNumber(value: 1)]
        gradientLayer.startPoint = CGPoint(x: 0, y: 0.5)
        gradientLayer.endPoint = CGPoint(x: 1, y: 0.5)

        gradientLayer.mask = generateLayer(path: path)

        layer.addSublayer(gradientLayer)
    }
 }
