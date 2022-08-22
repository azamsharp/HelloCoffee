//
//  NumberFormatter.swift
//  HelloCoffee
//
//  Created by Mohammad Azam on 8/18/22.
//

import Foundation


extension NumberFormatter {
    
    static var currency: NumberFormatter {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        return formatter 
    }
    
} 
