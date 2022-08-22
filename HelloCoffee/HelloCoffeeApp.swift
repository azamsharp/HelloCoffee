//
//  HelloCoffeeApp.swift
//  HelloCoffee
//
//  Created by Mohammad Azam on 8/18/22.
//

import SwiftUI

enum Route: Hashable {
    case add
    case detail(Int)
    case edit(Order)
}

@main
struct HelloCoffeeApp: App {
    
    @StateObject private var service: Webservice
    
    init() {
        var config = Configuration()
        _service = StateObject(wrappedValue: Webservice(baseURL: config.environment.baseURL))
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                            case .add:
                                AddCoffeeView()
                            case .detail(let orderId):
                                OrderDetailView(orderId: orderId)
                            case .edit(let order):
                                AddCoffeeView(order: order)
                        }
                    }
            }.environmentObject(service)
        }
    }
}
