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
    }

    @IBAction func sliderValueChanged(sender: UISlider) {
        valueLabel.text = String(sender.value)
        adjustBarGaugeValues(Double(sender.value))

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
    }


    func setupLeftBarGauge() {

    }

    func setupDefaultBarGauge() {

    }

    func setupReversedBarGauge() {

    }

    func setupColorBarGauge() {

    }

    func setupRangeBarGauge() {

    }

    func setupPeakBarGauge() {

    }

    func setupLCDBarGauge() {

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
}
