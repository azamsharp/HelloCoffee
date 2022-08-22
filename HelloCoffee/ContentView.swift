//
//  ContentView.swift
//  HelloCoffee
//
//  Created by Mohammad Azam on 8/18/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isPresented: Bool = false
    @EnvironmentObject private var model: CoffeeModel
    
    private func populateOrders() async {
        do {
            try await model.populateOrders()
        } catch {
            print(error)
        }
    }
    
    private func deleteOrder(_ indexSet: IndexSet) {
       
        indexSet.forEach { index in
            let order = model.orders[index]
            guard let orderId = order.id else {
                return
            }
              
            Task {
                do {
                    try await model.deleteOrder(orderId)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    var body: some View {
        let _ = print(Self._printChanges())
        VStack {
            
            if model.orders.isEmpty {
                Text("No orders available.")
                    .accessibilityIdentifier("noOrdersText")
            } else {
                List {
                    ForEach(model.orders) { order in
                        NavigationLink(value: order) {
                            OrderCellView(order: order)
                        }
                    }.onDelete(perform: deleteOrder)
                }.navigationDestination(for: Order.self) { order in
                    OrderDetailView(order: model.orderBinding(for: order.id))
                }
            }
        }
        .task {
            await populateOrders()
        }.navigationTitle("Orders")
        .sheet(isPresented: $isPresented, content: {
            AddCoffeeView(order: .constant(nil))
        })
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button("Add New Order") {
                    isPresented = true
                }.accessibilityIdentifier("addNewOrderButton")
            }  
        }
    }
}
/*
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView().environmentObject(CoffeeModel(webservice: Webservice(baseURL: URL(string: "")!)))
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
        }
    }
} */


