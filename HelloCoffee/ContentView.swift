//
//  ContentView.swift
//  HelloCoffee
//
//  Created by Mohammad Azam on 8/18/22.
//

import SwiftUI

struct ContentView: View {
    
    @State private var isPresented: Bool = false
    @EnvironmentObject private var service: Webservice
    
    private func populateOrders() async {
        do {
            try await service.getOrders()
        } catch {
            print(error)
        }
    }
    
    private func deleteOrder(_ indexSet: IndexSet) {
       
        indexSet.forEach { index in
            let order = service.orders[index]
            guard let orderId = order.id else {
                return
            }
              
            Task {
                do {
                    try await service.deleteOrder(orderId: orderId)
                } catch {
                    print(error)
                }
            }
        }
    }
    
    var body: some View {
        let _ = print(Self._printChanges())
        VStack {
            
            if service.orders.isEmpty {
                Text("No orders available.")
                    .accessibilityIdentifier("noOrdersText")
            } else {
                List {
                    ForEach(service.orders) { order in
                        NavigationLink(value: Route.detail(order.id!)) {
                            OrderCellView(order: order)
                        }
                    }.onDelete(perform: deleteOrder)
                }
            }
        }
        .task {
            await populateOrders()
        }.navigationTitle("Orders")
        .sheet(isPresented: $isPresented, content: {
            AddCoffeeView()
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

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationStack {
            ContentView().environmentObject(Webservice(baseURL: URL(string: "https://island-bramble.glitch.me/test/orders")!))
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
}


