//
//  FDBarGaugeTests.swift
//  FDBarGaugeTests
//
//  Created by Full Decent on 5/2/16.
//  Copyright © 2016 William Entriken. All rights reserved.
//

import XCTest
@testable import FDBarGuage

class FDBarGaugeTests: XCTestCase {
    
    var barGauge: FDBarGauge! = nil
    
    override func setUp() {
        super.setUp()
        barGauge = FDBarGauge()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPeak() {
        barGauge.holdPeak = true
        barGauge.value = 10
        XCTAssertEqual(barGauge.value, barGauge.peakValue)
    }
    
    func testProperties() {
        barGauge.holdPeak = true
        XCTAssert(barGauge.holdPeak)
        barGauge.litEffect = true
        XCTAssert(barGauge.litEffect)
        barGauge.reverseDirection = true
        XCTAssert(barGauge.reverseDirection)
        barGauge.value = 1.0
        XCTAssert(barGauge.value == 1.0)
        barGauge.peakValue = 1.0
        XCTAssert(barGauge.peakValue == 1.0)
        barGauge.maxLimit = 1.0
        XCTAssert(barGauge.maxLimit == 1.0)
        barGauge.minLimit = 0.0
        XCTAssert(barGauge.minLimit == 0.0)
        barGauge.warnThreshold = 1.0
        XCTAssert(barGauge.warnThreshold == 1.0)
        barGauge.dangerThreshold = 1.0
        XCTAssert(barGauge.dangerThreshold == 1.0)
        barGauge.numBars = 10
        XCTAssert(barGauge.numBars == 10)
        barGauge.outerBorderColor = UIColor.black
        XCTAssert(barGauge.outerBorderColor == UIColor.black)
        barGauge.innerBorderColor = UIColor.black
        XCTAssert(barGauge.innerBorderColor == UIColor.black)
        barGauge.normalColor = UIColor.black
        XCTAssert(barGauge.normalColor == UIColor.black)
        barGauge.warningColor = UIColor.black
        XCTAssert(barGauge.warningColor == UIColor.black)
        barGauge.dangerColor = UIColor.black
        XCTAssert(barGauge.dangerColor == UIColor.black)
    }
}
