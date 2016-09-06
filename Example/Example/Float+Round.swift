//
//  Double+Round.swift
//  UpdateFDBarGuage
//
//  Created by Hayden on 2016-09-03.
//  Copyright © 2016 Hayden. All rights reserved.
//

import Foundation

extension Float {
    /// Rounds the double to decimal places value
    func round(places:Int) -> Float {
        let divisor: Float = pow(10.0, Float(places))
        return roundf(self * divisor) / divisor
    }
}
