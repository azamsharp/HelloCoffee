//
//  HelloCoffeeApp.swift
//  HelloCoffee
//
//  Created by Mohammad Azam on 8/18/22.
//

import SwiftUI

enum Route: Hashable {
    case add
    //case detail(Int)
    //case edit(Order)
}

@main
struct HelloCoffeeApp: App {
    
    @StateObject private var model: CoffeeModel
    
    init() {
        var config = Configuration()
        let webservice = Webservice(baseURL: config.environment.baseURL)
        _model = StateObject(wrappedValue: CoffeeModel(webservice: webservice))
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                ContentView()
                    .navigationDestination(for: Route.self) { route in
                        switch route {
                            case .add:
                                AddCoffeeView(order: .constant(nil))
                          //  case .edit(let order):
                            //    AddCoffeeView(order: order)
                        }
                    }
            }.environmentObject(model)
        }
    }
}
