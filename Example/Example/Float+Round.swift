//
//  Double+Round.swift
//  UpdateFDBarGuage
//
//  Created by Hayden on 2016-09-03.
//  Copyright © 2016 Hayden. All rights reserved.
//

import Foundation

extension Double {
    /// Rounds the double to decimal places value
    func roundToPlaces(places:Int) -> Double {
        let divisor = pow(10.0, Double(places))
        return round(self * divisor) / divisor
    }
}