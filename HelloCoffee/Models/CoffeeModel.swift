//
//  CoffeeModel.swift
//  HelloCoffee
//
//  Created by Mohammad Azam on 8/22/22.
//

import Foundation
import SwiftUI

@MainActor
class CoffeeModel: ObservableObject {
    
    // USE CONTRACT TO SUPPORT MORE VARIATIONS IF NEEDED
    let webservice: Webservice
    @Published private(set) var orders: [Order] = []
    
    init(webservice: Webservice) {
        self.webservice = webservice
    }
    
    func orderById(_ id: Int) -> Order? {
        
        guard let index = orders.firstIndex(where: { $0.id == id }) else {
           return nil 
        }
        return orders[index]
    }
    
    func populateOrders() async throws {
        orders = try await webservice.getOrders()
    }
    
    func placeOrder(_ order: Order) async throws {
        let newOrder = try await webservice.placeOrder(order: order)
        orders.append(newOrder)
    }
    
    func updateOrder(_ order: Order) async throws {
        let updatedOrder = try await webservice.updateOrder(order: order)
        guard let index = orders.firstIndex(where: { $0.id == updatedOrder.id }) else {
            throw CoffeeOrderError.invalidOrderId
        }
        orders[index] = updatedOrder
    }
    
    func deleteOrder(_ orderId: Int) async throws {
        let deletedOrder = try await webservice.deleteOrder(orderId: orderId)
        orders = orders.filter { $0.id != deletedOrder.id }
    }
    
}
