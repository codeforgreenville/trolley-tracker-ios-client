//
//  TrolleyAnnotationView.swift
//  
//
//  Created by Austin Younts on 8/28/15.
//
//

import UIKit
import MapKit

class TrolleyAnnotationView: MKAnnotationView {
    
    /// Will be shown on the view
    var trolleyNumber: Int = 0 {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    fileprivate var labelText: String {
        get { return "#\(trolleyNumber)" }
    }

    fileprivate let innerColorAlpha: CGFloat = 0.9
    fileprivate let outerColorAlpha: CGFloat = 0.5
    
    fileprivate let outerCirclePercentage: CGFloat = 0.9 // The diameter of the outer circle, as a percentage of the view's size
    fileprivate let innerCirclePercentage: CGFloat = 0.73 // The diameter of the inner circle, as a percentage of the view's size
    
    fileprivate let outerCircleWidthPercentage: CGFloat = 0.08 // The line width of the outerCircle, as a percentage of the view's width
    
    fileprivate let imageInsetPercentage: CGFloat = 0.35 // The size of the image, as a precentage of the view's size
    fileprivate let verticalImageOffsetPercent: CGFloat = 0.1 // Controls how far the image is shifted vertically, as a percentage of the view's height
    
    fileprivate let textWidthPercentage: CGFloat = 0.5 // The width of the text area, as a percentage of the view's width
    fileprivate let textHeightPercentage: CGFloat = 0.25 // The height of the text area, as a percentage of the view's height
    fileprivate let textHeightOffset: CGFloat = -0.035 // The vertical offset of the text, starting at the bottom of the image, as a percentage of the view's height
    
    override func draw(_ rect: CGRect) {
        
        let innerColor = tintColor.withAlphaComponent(innerColorAlpha)
        let outerColor = tintColor.withAlphaComponent(outerColorAlpha)
        
        // Outer circle/ring
        let outerCircle = UIBezierPath(ovalIn: insetRect(rect, toPercent: outerCirclePercentage))
        outerColor.setStroke()
        outerCircle.lineWidth = rect.width * outerCircleWidthPercentage
        outerCircle.stroke()
        
        // Inner circle
        let innerCircle = UIBezierPath(ovalIn: insetRect(rect, toPercent: innerCirclePercentage))
        innerColor.setFill()
        innerCircle.fill()
        
        // Trolley image
        var imageRect = insetRect(rect, toPercent: imageInsetPercentage)
        imageRect = imageRect.offsetBy(dx: 0, dy: -(rect.height * verticalImageOffsetPercent))
        let trolleyImage = UIImage.ttTrolleyMarkerImage
        trolleyImage.draw(in: imageRect)
        
        // Trolley label text
        var labelRect = CGRect(x: 0, y: 0, width: rect.width * textWidthPercentage, height: rect.height * textHeightPercentage)
        labelRect.origin.x = rect.midX - (labelRect.width / 2)
        labelRect.origin.y = imageRect.maxY + (rect.height * textHeightOffset)
        
        let paragraphStyle = NSParagraphStyle.default.mutableCopy() as! NSMutableParagraphStyle
        paragraphStyle.alignment = NSTextAlignment.center
        
        var attributes: [String : AnyObject] = [
            NSForegroundColorAttributeName : UIColor.white,
            NSParagraphStyleAttributeName : paragraphStyle,
            NSFontAttributeName : UIFont.ttDefaultFont(6)
        ]
        
        let maxFontSize = labelText.maxFontSizeForSize(labelRect.size, attributes: attributes)
        attributes[NSFontAttributeName] = UIFont.ttDefaultFont(maxFontSize)
        
        (labelText as NSString).draw(in: labelRect, withAttributes: attributes)
    }
    
    override func setNeedsDisplay() {
        super.setNeedsDisplay()
        
        backgroundColor = UIColor.clear
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        layer.shadowOffset = CGSize(width: 2, height: 2)
        layer.shadowRadius = 5.0
        layer.shadowOpacity = 1.0
        
        layer.shadowColor = selected ? UIColor.black.cgColor : UIColor.clear.cgColor
    }
}
