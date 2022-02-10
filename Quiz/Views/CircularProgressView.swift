//
//  CircularProgressView.swift
//  Quiz
//
//  Created by Megan Wynn on 05/11/2021.
//

import UIKit

class CircularProgressView: UIView {

    // MARK: - Properties
    private var circleLayer = CAShapeLayer()
    private var progressLayer = CAShapeLayer()
    private var gradientLayer = CAGradientLayer()
    private var startPoint = CGFloat(-Double.pi / 2)
    private var endPoint = CGFloat(3 * Double.pi / 2)

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }

    func createCircularPath() {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: frame.size.width / 2.0, y: frame.size.height / 2.0), radius: 80, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 20.0
        circleLayer.strokeEnd = 1.0
        circleLayer.strokeColor = UIColor.white.cgColor
        layer.addSublayer(circleLayer)

        progressLayer.path = circularPath.cgPath
        progressLayer.fillColor = UIColor.clear.cgColor
        progressLayer.lineCap = .round
        progressLayer.lineWidth = 10
        progressLayer.strokeEnd = 0
        progressLayer.strokeColor = UIColor.startButtonColour.cgColor
        layer.addSublayer(progressLayer)

//        func addGradient() {
//            let gradient = CAGradientLayer()
//            gradient.colors = [UIColor.red.cgColor,UIColor.purple.cgColor,UIColor.systemPink.cgColor,UIColor.blue.cgColor]
//            gradient.frame = bounds
//            gradient.mask = progressLayer
//            layer.addSublayer(gradient)
//          }
//
//        addGradient()
//
//        gradientLayer.startPoint = CGPoint(x: 0.5, y: 0.0)
//        gradientLayer.endPoint = CGPoint(x: 0, y: 0.5)
//        gradientLayer.colors = [UIColor.startButtonColour.cgColor, UIColor.resultButtonColour.cgColor]
//        gradientLayer.frame = progressLayer.bounds
//        gradientLayer.frame = CGRect(x: frame.size.width, y: frame.size.height, width: 160, height: 160)
//        gradientLayer.mask = progressLayer
//        layer.addSublayer(gradientLayer)
    }

    func createStaticView(x: CGFloat, y: CGFloat, strokeEnd: CGFloat) {
        let circularPath = UIBezierPath(arcCenter: CGPoint(x: x, y: y), radius: 25, startAngle: startPoint, endAngle: endPoint, clockwise: true)
        circleLayer.path = circularPath.cgPath
        circleLayer.fillColor = UIColor.clear.cgColor
        circleLayer.lineCap = .round
        circleLayer.lineWidth = 5
        circleLayer.strokeEnd = strokeEnd
        circleLayer.strokeColor = UIColor.startButtonColour.cgColor
        layer.addSublayer(circleLayer)
    }

    func progressAnimation(toValue: Float) {
        let circularProgressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        circularProgressAnimation.duration = 2
        circularProgressAnimation.toValue = toValue
        circularProgressAnimation.fillMode = .forwards
        circularProgressAnimation.isRemovedOnCompletion = false
        progressLayer.add(circularProgressAnimation, forKey: "progressAnim")
    }
}