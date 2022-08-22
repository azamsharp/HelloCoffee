//
//  View+Extensions.swift
//  HelloCoffee
//
//  Created by Mohammad Azam on 8/19/22.
//

import Foundation
import SwiftUI

extension View {
    
    func centerHorizontally() -> some View {
        self.frame(maxWidth: .infinity, alignment: .center)
    }
    
    @ViewBuilder
    func visible(_ value: Bool) -> some View {
        // you can use if-else also
        switch value {
            case true:
                self
            case false:
                EmptyView()
        }
    }
    
}
