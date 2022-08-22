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
    @EnvironmentObject private var service: Webservice
    @State private var isPresented: Bool = false
    
    
    private func deleteOrder() async {
        do {
            guard let orderId = service.selectedOrder.id else {
                throw CoffeeOrderError.invalidOrderId
            }
            try await service.deleteOrder(orderId: orderId)
            // go to the list screen when the item has been deleted
            dismiss()
        } catch {
            print(error)
        }
    }
    
    var body: some View {
        
        let order = service.selectedOrder
        
        VStack(alignment: .leading, spacing: 10) {
            Text(order.coffeeName)
                .font(.title)
                .frame(maxWidth: .infinity, alignment: .leading)
            Text(order.size.rawValue)
                .opacity(0.5)
            Text(order.total as NSNumber, formatter: NumberFormatter.currency)
            
            HStack {
                Spacer()
                Button("Delete Order", role: .destructive) {
                    Task {
                        await deleteOrder()
                    }
                }
                
                Button("Edit Order") {
                    isPresented = true
                }
                
                Spacer()
            }
            Spacer()
            .navigationTitle(order.name)
            
        }.onAppear {
            service.selectedOrder = service.orderById(orderId)
        }
        .sheet(isPresented: $isPresented, content: {
            AddCoffeeView(order: order)
        })
        .padding()
    }
}

struct OrderDetailView_Previews: PreviewProvider {
    static var previews: some View {
        
        Group {
            NavigationStack {
                OrderDetailView(orderId: Order.preview.id!)
            }
        }
      
    }
}
