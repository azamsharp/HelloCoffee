//
//  OrderDetailView.swift
//  HelloCoffee
//
//  Created by Mohammad Azam on 8/20/22.
//

import SwiftUI

struct OrderDetailView: View {
    
    let orderId: Int
    @Environment(\.dismiss) private var dismiss
    @EnvironmentObject private var model: CoffeeModel
    @State private var isPresented: Bool = false
    
    private func deleteOrder() async {
        
        do {
            try await model.deleteOrder(orderId)
            dismiss()
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        
        VStack {
            
            if let order = model.orderById(orderId) {
                VStack(alignment: .leading, spacing: 10) {
                    Text(order.coffeeName)
                        .font(.title)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .accessibilityIdentifier("coffeeNameText")
                    Text(order.size.rawValue)
                        .opacity(0.5)
                    Text(order.total as NSNumber, formatter: NumberFormatter.currency)
                    
                    HStack {
                        Spacer()
                        Button("Delete Order", role: .destructive) {
                            Task {
                                await deleteOrder() // orderId was originally passed
                            }
                        }
                        
                        Button("Edit Order") {
                            isPresented = true
                        }.accessibilityIdentifier("editOrderButton")
                        
                        Spacer()
                    }
                    Spacer()
                        .navigationTitle(order.name)
                    
                }.sheet(isPresented: $isPresented, content: {
                    AddCoffeeView(order: order)
                })
            } else {
                Text("Order details not found...")
            }
            
               

        }.padding()
        
    }
}

/*
struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            NavigationStack {
                OrderDetailView(orderId: Order.preview.id!)
            }
        }
        
    }
} */
