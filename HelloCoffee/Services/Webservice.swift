//
//  Store.swift
//  HelloCoffee
//
//  Created by Mohammad Azam on 8/18/22.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case decodingError
    case badUrl
}

@MainActor
class Webservice: ObservableObject {
    
    private var baseURL: URL
    @Published var selectedOrder: Order = Order.preview 
    @Published private(set) var orders: [Order] = []
    
    nonisolated init(baseURL: URL) {
        self.baseURL = baseURL
    }
    
    func orderById(_ id: Int) -> Order {
        
        guard let index = orders.firstIndex(where: { $0.id == id }) else {
            return Order.preview
        }
        
        return orders[index]
    }
    
    func deleteOrder(orderId: Int) async throws {
        
        guard let url = URL(string: Endpoints.deleteOrder(orderId).path, relativeTo: baseURL) else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "DELETE"
        
        let (data, response) = try await URLSession.shared.data(for: request)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        // check the response
        guard let successResponse = try? JSONDecoder().decode(SuccessResponse.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        if successResponse.success {
            // remove the orders from local orders
            orders = orders.filter { $0.id != orderId }
        } else {
            throw NetworkError.badRequest
        }
    }
    
    func updateOrder(order: Order) async throws {
        
        guard let orderId = order.id else {
            throw NetworkError.badRequest
        }
            
        guard let url = URL(string: Endpoints.updateOrder(orderId).path, relativeTo: baseURL) else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "PUT"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(order)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        // decode to the update order
        guard let updatedOrder = try? JSONDecoder().decode(Order.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        // update the orders array
        if let index = orders.firstIndex(where: { $0.id == updatedOrder.id }) {
            selectedOrder = updatedOrder
        }
    }
    
    func placeOrder(order: Order) async throws {
        
        guard let url = URL(string: Endpoints.placeOrder.path, relativeTo: baseURL) else {
            throw NetworkError.badUrl
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try JSONEncoder().encode(order)
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let newOrder = try? JSONDecoder().decode(Order.self, from: data) else {
            throw NetworkError.decodingError
        }
        
        orders.append(newOrder)
    }
    
    func getOrders() async throws {
        
        guard let url = URL(string: Endpoints.allOrders.path, relativeTo: baseURL) else {
            throw NetworkError.badUrl
        }
        
        print(url.absoluteString)
        
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let orders = try? JSONDecoder().decode([Order].self, from: data) else {
            throw NetworkError.decodingError
        }
        
        self.orders = orders
    }
    
}
