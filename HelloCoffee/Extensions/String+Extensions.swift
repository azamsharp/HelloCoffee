//
//  String+Extensions.swift
//  HelloCoffee
//
//  Created by Mohammad Azam on 8/19/22.
//

import Foundation

extension String {
    
    var isNotEmpty: Bool {
        !self.isEmpty
    }
    
    var isNumeric: Bool {
        Double(self) != nil
    }
    
    func isLessThan(_ number: Double) -> Bool {
        if !self.isNumeric {
            return false
        }
        
        guard let value = Double(self) else { return false }
        return value < number
    }
    
}

