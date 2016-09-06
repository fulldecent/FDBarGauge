//
//  ViewController.swift
//  UpdateFDBarGuage
//
//  Created by Hayden on 2016-09-01.
//  Copyright © 2016 Hayden. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    @IBOutlet var leftBarGauge: FDBarGauge!
    @IBOutlet var defaultBarGauge: FDBarGauge!
    @IBOutlet var reversedBarGauge: FDBarGauge!
    @IBOutlet var colorBarGauge: FDBarGauge!
    @IBOutlet var rangeBarGauge: FDBarGauge!
    @IBOutlet var peakBarGauge: FDBarGauge!
    @IBOutlet var lcdBarGauge: FDBarGauge!
    @IBOutlet var valueLabel: UILabel!
    @IBOutlet var slider: UISlider!

    var barGauges = [FDBarGauge]()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupBarGauges()
        setupValueLabel()
        self.setNeedsStatusBarAppearanceUpdate()
    }

    @IBAction func sliderValueChanged(sender: UISlider) {
        valueLabel.text = String(sender.value.round(2))
        adjustBarGaugeValues(Double(sender.value))

    }

    @IBAction func resetButtonTapped(sender: UIButton) {
        peakBarGauge.resetPeak()
    }

    func adjustBarGaugeValues(value: Double) {
        for gauge in barGauges {
            gauge.value = value
        }
    }

    func setupValueLabel() {
        valueLabel.font = UIFont(name: "DBLCDTempBlack", size: 18)
        valueLabel.text = String(slider.value)
    }

    func setupBarGauges() {
        appendBarGauges()
        setupLeftBarGauge()
        setupDefaultBarGauge()
        setupReversedBarGauge()
        setupColorBarGauge()
        setupRangeBarGauge()
        setupPeakBarGauge()
        setupLCDBarGauge()
        adjustBarGaugeValues(Double(slider.value))
    }


    func setupLeftBarGauge() {}

    func setupDefaultBarGauge() {}

    func setupReversedBarGauge() {
        reversedBarGauge.reverseDirection = true
    }

    func setupColorBarGauge() {
        colorBarGauge.numBars = 15
        colorBarGauge.warnThreshold = (6.0/15.0)
        colorBarGauge.dangerThreshold = (13.0/15.0)

        colorBarGauge.normalColor = UIColor.blueColor()
        colorBarGauge.warningColor = UIColor.cyanColor()
        colorBarGauge.dangerColor = UIColor.magentaColor()
        colorBarGauge.outerBorderColor = UIColor.blackColor()
        colorBarGauge.innerBorderColor = UIColor.blackColor()
    }

    func setupRangeBarGauge() {
        rangeBarGauge.numBars = 20
        rangeBarGauge.minLimit = 0.4
        rangeBarGauge.maxLimit = 0.6
    }

    func setupPeakBarGauge() {
        peakBarGauge.holdPeak = true
    }

    func setupLCDBarGauge() {
        lcdBarGauge.backgroundColor = UIColor.clearColor()
        lcdBarGauge.numBars = 15
        lcdBarGauge.normalColor = UIColor(red: 0.4, green: 0.4, blue: 0.4, alpha: 1.0)
        lcdBarGauge.warnThreshold = 1.0
        lcdBarGauge.dangerThreshold = 1.0
        lcdBarGauge.outerBorderColor = UIColor(red: 128/255, green: 187/255, blue: 218/255, alpha: 1)
        lcdBarGauge.innerBorderColor = UIColor(red: 128/255, green: 187/255, blue: 218/255, alpha: 1)
    }

    func appendBarGauges() {
        barGauges.append(leftBarGauge)
        barGauges.append(defaultBarGauge)
        barGauges.append(reversedBarGauge)
        barGauges.append(colorBarGauge)
        barGauges.append(rangeBarGauge)
        barGauges.append(peakBarGauge)
        barGauges.append(lcdBarGauge)
    }

    override func preferredStatusBarStyle() -> UIStatusBarStyle {
        return .LightContent
    }
}
