//
//  AddCoffeeView.swift
//  HelloCoffee
//
//  Created by Mohammad Azam on 8/18/22.
//

import SwiftUI

struct AddCoffeeErrors {
    var name: String = ""
    var coffeeName: String = ""
    var price: String = ""
}

struct AddCoffeeView: View {
    
    var order: Order? = nil 
    @State private var name: String = ""
    @State private var coffeeName: String = ""
    @State private var price: String = ""
    @State private var coffeeSize: CoffeeSize = .medium
    @State private var errors: AddCoffeeErrors = AddCoffeeErrors()
    
    @Environment(\.dismiss) private var dismiss 
    @EnvironmentObject private var model: CoffeeModel
    
    private func populateExistingOrder() {
        if let order = order {
            name = order.name
            coffeeName = order.coffeeName
            price = String(order.total)
            coffeeSize = order.size
        }
    }
    
    var isValid: Bool {
        
        errors = AddCoffeeErrors()
        
        if name.isEmpty {
            errors.name = "Name cannot be empty!"
        }
        
        if coffeeName.isEmpty {
            errors.coffeeName = "Coffee name cannot be empty"
        }
        
        if price.isEmpty {
            errors.price = "Price cannot be empty"
        } else if(!price.isNumeric) {
            errors.price = "Price needs to be a number"
        } else if(price.isLessThan(1)) {
            errors.price = "Price needs to be more than 0"
        }
        
        return errors.name.isEmpty && errors.price.isEmpty && errors.coffeeName.isEmpty
    }
    
    private func placeOrder(_ order: Order) async {
        
        do {
            try await model.placeOrder(order)
        } catch {
            print(error)
        }
    }
    
    private func updateOrder(_ order: Order) async {
        do {
            try await model.updateOrder(order)
        } catch {
            print(error)
        }
    }
    
    private func saveOrUpdate() async {
        if let order {
            // update the order
            var editOrder = order
            editOrder.name = name
            editOrder.total = Double(price) ?? 0.0
            editOrder.coffeeName = coffeeName
            editOrder.size = coffeeSize
            // call to update the order
            await updateOrder(editOrder)
        } else {
            // save a new order
            let order = Order(name: name, coffeeName: coffeeName, total: Double(price) ?? 0.0, size: coffeeSize)
            // place the order
            await placeOrder(order)
        }
        dismiss()
    }
    
    var body: some View {
        NavigationStack {
            Form {
                TextField("Name", text: $name)
                    .accessibilityIdentifier("name")
                
                Text(errors.name).visible(!errors.name.isEmpty)
                    .font(.caption)
                TextField("Coffee name", text: $coffeeName)
                    .accessibilityIdentifier("coffeeName")
                
                // easier to write but still injects an EmptyView
                Text(errors.coffeeName).visible(errors.coffeeName.isNotEmpty)
                    .font(.caption)
                TextField("Price", text: $price)
                    .accessibilityIdentifier("price")
                
                Text(errors.price).visible(!errors.price.isEmpty)
                    .font(.caption)
                
                Picker("Select size", selection: $coffeeSize) {
                    ForEach(CoffeeSize.allCases, id: \.rawValue) { size in
                        Text(size.rawValue).tag(size)
                    }
                }.pickerStyle(.segmented)
                
                Button(order != nil ? "Update Order": "Place Order") {
                    if isValid {
                        Task {
                            await saveOrUpdate()
                        }
                    }
                }
                .accessibilityIdentifier("placeOrderButton")
                .centerHorizontally()
            }.navigationTitle(order == nil ? "Add Coffee": "Update Coffee")
            .onAppear {
                populateExistingOrder()
            }
        }
    }
}

/*
struct AddCoffeeView_Previews: PreviewProvider {
    static var previews: some View {
        AddCoffeeView(order: Order.preview)
    }
} */
