//
// Copyright (c) 2017 malkouz
//
// Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
//

import UIKit

// MARK: - Line Cap Enum

public enum LineCap : Int{
    case round, butt, square
    
    public func style() -> String {
        switch self {
        case .round:
            return CAShapeLayerLineCap.round.rawValue
        case .butt:
            return CAShapeLayerLineCap.butt.rawValue
        case .square:
            return CAShapeLayerLineCap.square.rawValue
        }
    }
}

// MARK: - Orientation Enum

public enum Orientation: Int  {
    case left, top, right, bottom
    
}

@IBDesignable
open class MKMagneticProgress: UIView {
    
    // MARK: - Variables
    private let titleLabelWidth: CGFloat = 100
    
    private let percentLabel = UILabel(frame: .zero)
    @IBInspectable open var titleLabel = UILabel(frame: .zero)
    
    /// Stroke background color
    @IBInspectable open var clockwise: Bool = true {
        didSet {
            layoutSubviews()
        }
    }
    
    /// Stroke background color
    @IBInspectable open var backgroundShapeColor: UIColor = UIColor(white: 0.9, alpha: 0.5) {
        didSet {
            updateShapes()
        }
    }
    
    /// Progress stroke color
    @IBInspectable open var progressShapeColor: UIColor   = .blue {
        didSet {
            updateShapes()
        }
    }
    
    /// Line width
    @IBInspectable open var lineWidth: CGFloat = 8.0 {
        didSet {
            updateShapes()
        }
    }
    
    /// Space value
    @IBInspectable open var spaceDegree: CGFloat = 45.0 {
        didSet {
            if spaceDegree < 0.0 {
                spaceDegree = 0.0
            }
            else if spaceDegree > 135.0 {
                spaceDegree = 135.0
            }
            
            layoutSubviews()
        }
    }
    
    /// The progress shapes line width will be the `line width` minus the `inset`.
    @IBInspectable open var inset: CGFloat = 0.0 {
        didSet {
            updateShapes()
        }
    }
    
    /// Value to set
    @IBInspectable open var value: CGFloat = 0.0 {
        didSet {
            if value < minValue {
                value = minValue
            }
            else if value > maxValue {
                value = maxValue
            }
            
            internalValue = value
            
            updateShapes()
        }
    }
    
    /// Current internal value.
    private var internalValue: CGFloat = 0.0
    
    /// Minimum value
    @IBInspectable open var minValue: CGFloat = 0.0 {
        didSet {
            if minValue > maxValue {
                minValue = oldValue
                return
            }
            else if minValue > value {
                value = minValue
                return
            }
            
            updateShapes()
        }
    }
    
    /// Maximum value
    @IBInspectable open var maxValue: CGFloat = 1.0 {
        didSet {
            if maxValue < minValue {
                maxValue = oldValue
                return
            }
            else if maxValue < value {
                value = maxValue
                return
            }
            
            updateShapes()
        }
    }
    
    // The progress percentage label(center label) format
    @IBInspectable open var percentLabelFormat: String = "%.f %%" {
        didSet {
            percentLabel.text = String(format: percentLabelFormat, value)
        }
    }
    
    @IBInspectable open var percentColor: UIColor = UIColor(white: 0.9, alpha: 0.5) {
        didSet {
            percentLabel.textColor = percentColor
        }
    }
    
    @IBInspectable open var percentFont: UIFont = .monospacedDigitSystemFont(ofSize: UIFont.preferredFont(forTextStyle: .largeTitle).pointSize, weight: .regular) {
        didSet {
            percentLabel.font = percentFont
        }
    }
    
    
    /// progress text (progress bottom label)
    @IBInspectable open var title: String = "" {
        didSet {
            titleLabel.text = title
        }
    }
    
    @IBInspectable open var titleColor: UIColor = UIColor(white: 0.9, alpha: 0.5) {
        didSet {
            titleLabel.textColor = titleColor
        }
    }
    
    @IBInspectable open var titleFont: UIFont = UIFont.preferredFont(forTextStyle: .body) {
        didSet {
            titleLabel.font = titleFont
        }
    }
    
    
    // progress Orientation
    open var orientation: Orientation = .bottom {
        didSet {
            updateShapes()
        }
    }

    /// Progress shapes line cap.
    open var lineCap: LineCap = .round {
        didSet {
            updateShapes()
        }
    }
    
    /// Duration for a complete animation from 0.0 to 1.0.
    open var completeDuration: Double = 2.0
    
    private var backgroundShape: CAShapeLayer!
    private var progressShape: CAShapeLayer!
    
    private var progressAnimation: CABasicAnimation!
    
    // MARK: - Init
    
    public required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    public override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    private func setup() {
        
        backgroundShape = CAShapeLayer()
        backgroundShape.fillColor = nil
        backgroundShape.strokeColor = backgroundShapeColor.cgColor
        layer.addSublayer(backgroundShape)
        
        progressShape = CAShapeLayer()
        progressShape.fillColor   = nil
        progressShape.strokeStart = 0.0
        progressShape.strokeEnd   = 0.1
        layer.addSublayer(progressShape)
        
        progressAnimation = CABasicAnimation(keyPath: "strokeEnd")
        
        percentLabel.frame = self.bounds
        percentLabel.textAlignment = .center
        percentLabel.textColor = percentColor
        percentLabel.font = percentFont
        percentLabel.text = String(format: percentLabelFormat, value)
        self.addSubview(percentLabel)
        
        
        titleLabel.frame = CGRect(x: (self.bounds.size.width-titleLabelWidth)/2, y: self.bounds.size.height-21, width: titleLabelWidth, height: 21)
        titleLabel.textAlignment = .center
        titleLabel.textColor = titleColor
        titleLabel.font = titleFont
        titleLabel.text = title
//        titleLabel.contentScaleFactor = 0.3
        titleLabel.numberOfLines = 2
        titleLabel.adjustsFontSizeToFitWidth = true
        self.addSubview(titleLabel)
    }
    
    // MARK: - Progress Animation
    
    public func setValue(value: CGFloat, animated: Bool = true) {
        if value < minValue {
            internalValue = minValue
        }
        else if value > maxValue {
            internalValue = maxValue
        }
        else {
            internalValue = value
        }
        
        let progressValue = (internalValue - minValue) / maxValue
        
        percentLabel.text = String(format: percentLabelFormat, internalValue)
        
        var start = progressShape.strokeEnd
        if let presentationLayer = progressShape.presentation(){
            if let count = progressShape.animationKeys()?.count, count > 0  {
            start = presentationLayer.strokeEnd
            }
        }
        
        let duration = abs(Double(progressValue - start)) * completeDuration
        progressShape.strokeEnd = progressValue
        
        if animated {
            progressAnimation.fromValue = start
            progressAnimation.toValue   = progressValue
            progressAnimation.duration  = duration
            progressShape.add(progressAnimation, forKey: progressAnimation.keyPath)
        }
    }
    
    // MARK: - Layout
    
    open override func layoutSubviews() {
        
        super.layoutSubviews()
        
        backgroundShape.frame = bounds
        progressShape.frame   = bounds
        
        let rect = rectForShape()
        backgroundShape.path = pathForShape(rect: rect).cgPath
        progressShape.path   = pathForShape(rect: rect).cgPath
        
        self.titleLabel.frame = CGRect(x: (self.bounds.size.width - titleLabelWidth)/2, y: self.bounds.size.height-50, width: titleLabelWidth, height: 42)
        
        updateShapes()
        
        percentLabel.frame = self.bounds
    }
    
    private func updateShapes() {
        backgroundShape?.lineWidth   = lineWidth
        backgroundShape?.strokeColor = backgroundShapeColor.cgColor
        backgroundShape?.lineCap     = CAShapeLayerLineCap(rawValue: lineCap.style())
        
        progressShape?.strokeColor = progressShapeColor.cgColor
        progressShape?.lineWidth   = lineWidth - inset
        progressShape?.lineCap     = CAShapeLayerLineCap(rawValue: lineCap.style())
        
        switch orientation {
        case .left:
            titleLabel.isHidden = true
            self.progressShape.transform = CATransform3DMakeRotation( CGFloat.pi / 2, 0, 0, 1.0)
            self.backgroundShape.transform = CATransform3DMakeRotation(CGFloat.pi / 2, 0, 0, 1.0)
            
        case .right:
            titleLabel.isHidden = true
            self.progressShape.transform = CATransform3DMakeRotation( CGFloat.pi * 1.5, 0, 0, 1.0)
            self.backgroundShape.transform = CATransform3DMakeRotation(CGFloat.pi * 1.5, 0, 0, 1.0)
            
        case .bottom:
            titleLabel.isHidden = false
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [] , animations: { [weak self] in
                if let temp = self {
                    temp.titleLabel.frame = CGRect(x: (temp.bounds.size.width - temp.titleLabelWidth)/2, y: temp.bounds.size.height-50, width: temp.titleLabelWidth, height: 42)
                }

            }, completion: nil)
            self.progressShape.transform = CATransform3DMakeRotation( CGFloat.pi * 2, 0, 0, 1.0)
            self.backgroundShape.transform = CATransform3DMakeRotation(CGFloat.pi * 2, 0, 0, 1.0)
            
        case .top:
            titleLabel.isHidden = false
            UIView.animate(withDuration: 0.3, delay: 0.0, usingSpringWithDamping: 0.9, initialSpringVelocity: 0.0, options: [] , animations: { [weak self] in
                if let temp = self {
                    temp.titleLabel.frame = CGRect(x: (temp.bounds.size.width - temp.titleLabelWidth)/2, y: 0, width: temp.titleLabelWidth, height: 42)
                }
                
                }, completion: nil)
            self.progressShape.transform = CATransform3DMakeRotation( CGFloat.pi, 0, 0, 1.0)
            self.backgroundShape.transform = CATransform3DMakeRotation(CGFloat.pi, 0, 0, 1.0)
        }
    }
    
    // MARK: - Helper
    
    private func rectForShape() -> CGRect {
        return bounds.insetBy(dx: lineWidth / 2.0, dy: lineWidth / 2.0)
    }
    
    private func pathForShape(rect: CGRect) -> UIBezierPath {
        let startAngle:CGFloat!
        let endAngle:CGFloat!
        
        if clockwise {
            startAngle = CGFloat(spaceDegree * .pi / 180.0) + (0.5 * .pi)
            endAngle = CGFloat((360.0 - spaceDegree) * (.pi / 180.0)) + (0.5 * .pi)
        }
        else {
            startAngle = CGFloat((360.0 - spaceDegree) * (.pi / 180.0)) + (0.5 * .pi)
            endAngle = CGFloat(spaceDegree * .pi / 180.0) + (0.5 * .pi)
        }
        let path = UIBezierPath(arcCenter: CGPoint(x: rect.midX, y: rect.midY), radius: rect.size.width / 2.0, startAngle: startAngle, endAngle: endAngle, clockwise: clockwise)
    
        return path
    }
}

