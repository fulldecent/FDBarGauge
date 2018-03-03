//
//  FDBarGauge.swift
//  Echo
//
//  Created by William Entriken on 1/12/16.
//
//  Completely ripped off from Brad Benson
//  Released under MIT license
//

import Foundation
import UIKit

/// A view for showing a single number on an LED display
@IBDesignable open class FDBarGauge: UIView {

    /// Whether to maintain a view of local maximums
    @IBInspectable open var holdPeak = false

    /// This applies a gradient style to the rendering
    @IBInspectable open var litEffect = true

    /// If `true` then render top-to-bottom or right-to-left
    @IBInspectable open var reverseDirection = false

    /// The quantity to be rendered
    @IBInspectable open var value = 0.0 {
        didSet {
            var redraw = false
            // Point at which bars start lighting up
            let newOnIdx = (value >= minLimit) ? 0 : numBars
            if onIdx != newOnIdx {
                onIdx = newOnIdx
                redraw = true
            }
            // Point at which bars are no longer lit
            let newOffIdx = Int(((value - minLimit) / (maxLimit - minLimit)) * Double(numBars))
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

    /// The local maximum for `value`
    @IBInspectable open var peakValue = 0.0

    /// The highest possible amount for `value`
    @IBInspectable open var maxLimit = 1.0

    /// The lowest possible amount for `value`, must be less than `maxLimit`
    @IBInspectable open var minLimit = 0.0

    /// A quantity for `value` which will render in a special color
    @IBInspectable open var warnThreshold = 0.6 {
        didSet {
            if !warnThreshold.isNaN && warnThreshold > 0.0 {
                warningBarIdx = Int(warnThreshold * Double(numBars))
            } else {
                warningBarIdx = -1
            }
        }
    }

    /// A quantity for `value` which will render in a special color
    @IBInspectable open var dangerThreshold = 0.8 {
        didSet {
            if !dangerThreshold.isNaN && dangerThreshold > 0.0 {
                dangerBarIdx = Int(dangerThreshold * Double(numBars))
            } else {
                dangerBarIdx = -1
            }
        }
    }

    /// The number of discrete segments to render
    @IBInspectable open var numBars: Int = 10 {
        didSet {
            peakValue = -.infinity // force it to be updated w/new bar index
            // Update thresholds
            value = 1 * value
            warnThreshold = 1 * warnThreshold
            dangerThreshold = 1 * dangerThreshold
        }
    }

    /// Outside border color
    @IBInspectable open var outerBorderColor = UIColor.gray

    /// Inside border color
    @IBInspectable open var innerBorderColor = UIColor.black

    /// The rendered segment color before reaching the warning threshold
    @IBInspectable open var normalColor = UIColor.green

    /// The rendered segment color after reaching the warning threshold
    @IBInspectable open var warningColor = UIColor.yellow

    /// The rendered segment color after reaching the danger threshold
    @IBInspectable open var dangerColor = UIColor.red

    fileprivate var onIdx = 0
    fileprivate var offIdx = 0
    fileprivate var peakBarIdx = -1
    fileprivate var warningBarIdx = 6
    fileprivate var dangerBarIdx = 8

    fileprivate func setup() {
        clearsContextBeforeDrawing = false;
        isOpaque = false;
        backgroundColor = UIColor.black
    }

    /// UIView initializer
    override init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }

    /// UIView initializer
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }

    /// Resets peak value
    func resetPeak() {
        peakValue = -.infinity
        peakBarIdx = -1
        self.setNeedsDisplay()
    }

    /// Draw the gauge
    override open func draw(_ rect: CGRect) {
        var ctx: CGContext
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
        ctx.clear(self.bounds)
        // Fill background
        ctx.setFillColor(backgroundColor!.cgColor)
        ctx.fill(rectBounds)
        // Draw LED bars
        ctx.setStrokeColor(innerBorderColor.cgColor)
        ctx.setLineWidth(1.0)
        for iX in 0..<numBars {
            // Determine position for this bar
            if reverseDirection {
                // Top-to-bottom or right-to-left
                rectBar.origin.x = (isVertical) ? rectBounds.origin.x + 1 : (rectBounds.maxX - CGFloat((iX + 1) * barSize))
                rectBar.origin.y = (isVertical) ? (rectBounds.minY + CGFloat(iX * barSize)) : rectBounds.origin.y + 1
            }
            else {
                // Bottom-to-top or right-to-left
                rectBar.origin.x = (isVertical) ? rectBounds.origin.x + 1 : (rectBounds.minX + CGFloat(iX * barSize))
                rectBar.origin.y = (isVertical) ? (rectBounds.maxY - CGFloat((iX + 1) * barSize)) : rectBounds.origin.y + 1
            }
            // Draw top and bottom borders for bar
            ctx.addRect(rectBar)
            ctx.strokePath()
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
            ctx.saveGState()
            let rectFill: CGRect = rectBar.insetBy(dx: 1.0, dy: 1.0)
            let clipPath: CGPath = CGPath(rect: rectFill, transform: nil)
            ctx.addPath(clipPath)
            ctx.clip()
            self.drawBar(ctx, withRect: rectFill, andColor: clrFill, lit: lit)
            ctx.restoreGState()
        }
        // Draw border around the control
        ctx.setStrokeColor(outerBorderColor.cgColor)
        ctx.setLineWidth(2.0)
        ctx.addRect(rectBounds.insetBy(dx: 1, dy: 1))
        ctx.strokePath()
    }

    /// Draw one of the bar segments inside the gauge
    fileprivate func drawBar(_ a_ctx: CGContext, withRect a_rect: CGRect, andColor a_clr: UIColor, lit a_fLit: Bool) {
        // Is the bar lit?
        if a_fLit {
            // Are we doing radial gradient fills?
            if litEffect {
                // Yes, set up to draw the bar as a radial gradient
                let num_locations: size_t = 2
                let locations: [CGFloat] = [0.0, 0.5]
                var aComponents = [CGFloat]()
                let clr: CGColor = a_clr.cgColor
                // Set up color components from passed UIColor object
                if clr.numberOfComponents == 4 {
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
                let width: CGFloat = a_rect.width
                let height: CGFloat = a_rect.height
                let radius: CGFloat = sqrt(width * width + height * height)

                // Draw the gradient inside the provided rectangle
                let myColorspace: CGColorSpace = CGColorSpaceCreateDeviceRGB()
                let myGradient: CGGradient = CGGradient(colorSpace: myColorspace, colorComponents: aComponents, locations: locations, count: num_locations)!
                let myStartPoint = CGPoint(x: a_rect.midX, y: a_rect.midY)
                a_ctx.drawRadialGradient(myGradient, startCenter: myStartPoint, startRadius: 0.0, endCenter: myStartPoint, endRadius: radius, options: [])
            }
            else {
                // No, solid fill
                a_ctx.setFillColor(a_clr.cgColor)
                a_ctx.fill(a_rect)
            }
        }
        else {
            // No, draw the bar as background color overlayed with a mostly
            // ... transparent version of the passed color
            let fillClr: CGColor = a_clr.cgColor.copy(alpha: 0.2)!
            a_ctx.setFillColor(backgroundColor!.cgColor)
            a_ctx.fill(a_rect)
            a_ctx.setFillColor(fillClr)
            a_ctx.fill(a_rect)
        }
    }
}
