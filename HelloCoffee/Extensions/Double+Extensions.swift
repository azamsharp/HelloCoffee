//
//  Double+Extensions.swift
//  HelloCoffee
//
//  Created by Mohammad Azam on 8/19/22.
//

import Foundation

extension Double {
    
    func formatAsCurrency() -> String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter.string(from: NSNumber(value: self)) ?? ""
    }
    
}
