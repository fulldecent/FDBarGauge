//
//  FDBarGuageTests.swift
//  FDBarGuageTests
//
//  Created by Full Decent on 5/2/16.
//  Copyright © 2016 William Entriken. All rights reserved.
//

import XCTest
@testable import FDBarGuage

class FDBarGuageTests: XCTestCase {
    
    var barGuage: FDBarGauge! = nil
    
    override func setUp() {
        super.setUp()
        barGuage = FDBarGauge()
    }
    
    override func tearDown() {
        super.tearDown()
    }
    
    func testPeak() {
        barGuage.holdPeak = true
        barGuage.value = 10
        XCTAssertEqual(barGuage.value, barGuage.peakValue)
    }
    
    func testProperties() {
        barGuage.holdPeak = true
        XCTAssert(barGuage.holdPeak)
        barGuage.litEffect = true
        XCTAssert(barGuage.litEffect)
        barGuage.reverseDirection = true
        XCTAssert(barGuage.reverseDirection)
        barGuage.value = 1.0
        XCTAssert(barGuage.value == 1.0)
        barGuage.peakValue = 1.0
        XCTAssert(barGuage.peakValue == 1.0)
        barGuage.maxLimit = 1.0
        XCTAssert(barGuage.maxLimit == 1.0)
        barGuage.minLimit = 0.0
        XCTAssert(barGuage.minLimit == 0.0)
        barGuage.warnThreshold = 1.0
        XCTAssert(barGuage.warnThreshold == 1.0)
        barGuage.dangerThreshold = 1.0
        XCTAssert(barGuage.dangerThreshold == 1.0)
        barGuage.numBars = 10
        XCTAssert(barGuage.numBars == 10)
        barGuage.outerBorderColor = UIColor.blackColor()
        XCTAssert(barGuage.outerBorderColor == UIColor.blackColor())
        barGuage.innerBorderColor = UIColor.blackColor()
        XCTAssert(barGuage.innerBorderColor == UIColor.blackColor())
        barGuage.normalColor = UIColor.blackColor()
        XCTAssert(barGuage.normalColor == UIColor.blackColor())
        barGuage.warningColor = UIColor.blackColor()
        XCTAssert(barGuage.warningColor == UIColor.blackColor())
        barGuage.dangerColor = UIColor.blackColor()
        XCTAssert(barGuage.dangerColor == UIColor.blackColor())
    }
}
