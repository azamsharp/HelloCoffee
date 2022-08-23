//
//  XCUIElement+Extensions.swift
//  HelloCoffeeUITests
//
//  Created by Mohammad Azam on 8/23/22.
//

import Foundation
import XCTest

// https://stackoverflow.com/questions/32821880/ui-test-deleting-text-in-text-field
extension XCUIElement {
    
    func clearAndEnterText(text: String) {
        
        guard let stringValue = self.value as? String else {
            XCTFail("Failed to clear TextField")
            return
        }
        
        self.tap(withNumberOfTaps: 2, numberOfTouches: 1)
        
        //self.tap()
        //let deleteString = String(repeating: XCUIKeyboardKey.delete.rawValue, count: stringValue.count)
        let exists = self.waitForExistence(timeout: 2.0)
        if exists {
            self.typeText(text)
        }
    }
}
