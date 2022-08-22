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
    
    let webservice: Webservice
    @Published var selectedOrder: Order?
    @Published private(set) var orders: [Order] = []
    
    init(webservice: Webservice) {
        self.webservice = webservice
    }
    
    public func orderBinding(for id: Order.ID) -> Binding<Order> {
        Binding<Order> {
            guard let index = self.orders.firstIndex(where: { $0.id == id }) else {
                fatalError()
            }
            return self.orders[index]
        } set: { newValue in
            guard let index = self.orders.firstIndex(where: { $0.id == id }) else {
                fatalError()
            }
            return self.orders[index] = newValue
        }
    }
    
    func orderById(_ id: Int) -> Order {
        
        guard let index = orders.firstIndex(where: { $0.id == id }) else {
            return Order.preview
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
        selectedOrder = updatedOrder
    }
    
    func deleteOrder(_ orderId: Int) async throws {
        let deletedOrder = try await webservice.deleteOrder(orderId: orderId)
        orders = orders.filter { $0.id != deletedOrder.id }
    }
    
}
