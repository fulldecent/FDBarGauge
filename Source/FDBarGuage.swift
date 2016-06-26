//
//  FDBarGuage.swift
//  Echo
//
//  Created by William Entriken on 1/12/16.
//
//  Completely ripped off from Brad Benson
//  Released under MIT license
//

import Foundation
import UIKit

@IBDesignable
public class FDBarGauge: UIView {
    
    @IBInspectable public var holdPeak = false
    
    @IBInspectable public var litEffect = true
    
    @IBInspectable public var reverseDirection = false // YES = top-to-bottom or right-to-left
    
    @IBInspectable public var value = 0.0 {
        didSet {
            var redraw = false
            // Point at which bars start lighting up
            let newOnIdx: Int = (value >= minLimit) ? 0 : numBars
            if onIdx != newOnIdx {
                onIdx = newOnIdx
                redraw = true
            }
            // Point at which bars are no longer lit
            let newOffIdx: Int = Int(((value - minLimit) / (maxLimit - minLimit)) * Double(numBars))
            if newOffIdx != offIdx {
                offIdx = newOffIdx
                redraw = true
            }
            // Are we doing peak?
            if holdPeak && value > peakValue {
                peakValue = value
                peakBarIdx = min(offIdx, numBars - 1)
            }
            // Redraw the display?
            if redraw {
                setNeedsDisplay()
            }
        }
    }
    
    @IBInspectable public var peakValue = 0.0
    
    @IBInspectable public var maxLimit = 1.0
    
    @IBInspectable public var minLimit = 0.0
    
    @IBInspectable public var warnThreshold = 0.6 {
        didSet {
            if (!isnan(warnThreshold) && warnThreshold > 0.0) {
                warningBarIdx = Int(warnThreshold * Double(numBars))
            } else {
                warningBarIdx = -1
            }
        }
    }
    
    @IBInspectable public var dangerThreshold = 0.8 {
        didSet {
            if (!isnan(dangerThreshold) && dangerThreshold > 0.0) {
                dangerBarIdx = Int(dangerThreshold * Double(numBars))
            } else {
                dangerBarIdx = -1
            }
        }
    }
    
    @IBInspectable public var numBars = 10 { // Number of segments
        didSet {
            peakValue = -.infinity // force it to be updated w/new bar index
            // Update thresholds
            value = 1 * value
            warnThreshold = 1 * warnThreshold
            dangerThreshold = 1 * dangerThreshold
        }
    }
    
    @IBInspectable public var outerBorderColor = UIColor.grayColor()
    
    @IBInspectable public var innerBorderColor = UIColor.blackColor()
    
    @IBInspectable public var normalColor = UIColor.greenColor()
    
    @IBInspectable public var warningColor = UIColor.yellowColor()
    
    @IBInspectable public var dangerColor = UIColor.redColor()

    private var onIdx = 0
    private var offIdx = 0
    private var peakBarIdx = -1
    private var warningBarIdx = 6
    private var dangerBarIdx = 8
    
    private func setup() {
        clearsContextBeforeDrawing = false;
        opaque = false;
        backgroundColor = UIColor.blackColor()
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    //------------------------------------------------------------------------
    //  Method: resetPeak
    //    Resets peak value.
    //
    func resetPeak() {
        peakValue = -.infinity
        peakBarIdx = -1
        self.setNeedsDisplay()
    }
    
    //------------------------------------------------------------------------
    //  Method: drawRect:
    //    Draw the gauge
    //
    override public func drawRect(rect: CGRect) {
        var ctx: CGContextRef
        // Graphics context
        var rectBounds: CGRect
        var rectBar = CGRect()
        // Rectangle for individual light bar
        var barSize: Int
        // Size (width or height) of each LED bar
        // How is the bar oriented?
        rectBounds = self.bounds
        let isVertical: Bool = (rectBounds.size.height >= rectBounds.size.width)
        if isVertical {
            // Adjust height to be an exact multiple of bar
            barSize = Int(rectBounds.size.height / CGFloat(numBars))
            rectBounds.size.height = CGFloat(barSize * numBars)
        }
        else {
            // Adjust width to be an exact multiple
            barSize = Int(rectBounds.size.width / CGFloat(numBars))
            rectBounds.size.width = CGFloat(barSize * numBars)
        }
        // Compute size of bar
        rectBar.size.width = isVertical ? rectBounds.size.width - 2 : CGFloat(barSize)
        rectBar.size.height = isVertical ? CGFloat(barSize) : rectBounds.size.height - 2
        // Get stuff needed for drawing
        ctx = UIGraphicsGetCurrentContext()!
        CGContextClearRect(ctx, self.bounds)
        // Fill background
        CGContextSetFillColorWithColor(ctx, backgroundColor!.CGColor)
        CGContextFillRect(ctx, rectBounds)
        // Draw LED bars
        CGContextSetStrokeColorWithColor(ctx, innerBorderColor.CGColor)
        CGContextSetLineWidth(ctx, 1.0)
        for iX in 0..<numBars {
            // Determine position for this bar
            if reverseDirection {
                // Top-to-bottom or right-to-left
                rectBar.origin.x = (isVertical) ? rectBounds.origin.x + 1 : (CGRectGetMaxX(rectBounds) - CGFloat((iX + 1) * barSize))
                rectBar.origin.y = (isVertical) ? (CGRectGetMinY(rectBounds) + CGFloat(iX * barSize)) : rectBounds.origin.y + 1
            }
            else {
                // Bottom-to-top or right-to-left
                rectBar.origin.x = (isVertical) ? rectBounds.origin.x + 1 : (CGRectGetMinX(rectBounds) + CGFloat(iX * barSize))
                rectBar.origin.y = (isVertical) ? (CGRectGetMaxY(rectBounds) - CGFloat((iX + 1) * barSize)) : rectBounds.origin.y + 1
            }
            // Draw top and bottom borders for bar
            CGContextAddRect(ctx, rectBar)
            CGContextStrokePath(ctx)
            // Determine color of bar
            var clrFill: UIColor = normalColor
            if dangerBarIdx >= 0 && iX >= dangerBarIdx {
                clrFill = dangerColor
            }
            else if warningBarIdx >= 0 && iX >= warningBarIdx {
                clrFill = warningColor
            }
            // Determine if bar should be lit
            let lit: Bool = ((iX >= onIdx && iX < offIdx) || iX == peakBarIdx)
            // Fill the interior of the bar
            CGContextSaveGState(ctx)
            let rectFill: CGRect = CGRectInset(rectBar, 1.0, 1.0)
            let clipPath: CGPathRef = CGPathCreateWithRect(rectFill, nil)
            CGContextAddPath(ctx, clipPath)
            CGContextClip(ctx)
            self.drawBar(ctx, withRect: rectFill, andColor: clrFill, lit: lit)
            CGContextRestoreGState(ctx)
        }
        // Draw border around the control
        CGContextSetStrokeColorWithColor(ctx, outerBorderColor.CGColor)
        CGContextSetLineWidth(ctx, 2.0)
        CGContextAddRect(ctx, CGRectInset(rectBounds, 1, 1))
        CGContextStrokePath(ctx)
    }
    
    //------------------------------------------------------------------------
    //  Method: drawBar::::
    //    This method draws a bar
    //
    private func drawBar(a_ctx: CGContextRef, withRect a_rect: CGRect, andColor a_clr: UIColor, lit a_fLit: Bool) {
        // Is the bar lit?
        if a_fLit {
            // Are we doing radial gradient fills?
            if litEffect {
                // Yes, set up to draw the bar as a radial gradient
                let num_locations: size_t = 2
                let locations: [CGFloat] = [0.0, 0.5]
                var aComponents = [CGFloat]()
                let clr: CGColorRef = a_clr.CGColor
                // Set up color components from passed UIColor object
                if CGColorGetNumberOfComponents(clr) == 4 {
                    let ci = CIColor(color: a_clr)
                    aComponents.append(ci.red)
                    aComponents.append(ci.green)
                    aComponents.append(ci.blue)
                    aComponents.append(ci.alpha)
                    // Calculate dark color of gradient
                    aComponents.append(aComponents[0] - ((aComponents[0] > 0.3) ? 0.3 : 0.0))
                    aComponents.append(aComponents[1] - ((aComponents[1] > 0.3) ? 0.3 : 0.0))
                    aComponents.append(aComponents[2] - ((aComponents[2] > 0.3) ? 0.3 : 0.0))
                    aComponents.append(aComponents[3])
                }
                
                // Calculate radius needed
                let width: CGFloat = CGRectGetWidth(a_rect)
                let height: CGFloat = CGRectGetHeight(a_rect)
                let radius: CGFloat = sqrt(width * width + height * height)
                
                // Draw the gradient inside the provided rectangle
                let myColorspace: CGColorSpaceRef = CGColorSpaceCreateDeviceRGB()!
                let myGradient: CGGradientRef = CGGradientCreateWithColorComponents(myColorspace, aComponents, locations, num_locations)!
                let myStartPoint = CGPoint(x: CGRectGetMidX(a_rect), y: CGRectGetMidY(a_rect))
                CGContextDrawRadialGradient(a_ctx, myGradient, myStartPoint, 0.0, myStartPoint, radius, [])
            }
            else {
                // No, solid fill
                CGContextSetFillColorWithColor(a_ctx, a_clr.CGColor)
                CGContextFillRect(a_ctx, a_rect)
            }
        }
        else {
            // No, draw the bar as background color overlayed with a mostly
            // ... transparent version of the passed color
            let fillClr: CGColorRef = CGColorCreateCopyWithAlpha(a_clr.CGColor, 0.2)!
            CGContextSetFillColorWithColor(a_ctx, backgroundColor!.CGColor)
            CGContextFillRect(a_ctx, a_rect)
            CGContextSetFillColorWithColor(a_ctx, fillClr)
            CGContextFillRect(a_ctx, a_rect)
        }
    }
}
