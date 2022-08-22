//
//  ProductListView.swift
//  HelloCoffee
//
//  Created by Mohammad Azam on 8/19/22.
//

import SwiftUI

struct Product: Decodable {
    let id: Int
    let title: String
}

private var baseURL: URL {
    return URL(string: "https://fakestoreapi.com")!
}



struct ProductListView: View {
    
    @State private var products: [Product] = []
    
    @MainActor
    private func populateProducts() async throws {
        
        guard let url = URL(string: "/products", relativeTo: baseURL) else {
            throw NetworkError.badUrl
        }
        
        let (data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse,
              httpResponse.statusCode == 200 else {
            throw NetworkError.badRequest
        }
        
        guard let products = try? JSONDecoder().decode([Product].self, from: data) else {
            throw NetworkError.decodingError
        }
        
        self.products = products
    }
    
    var body: some View {
        List(products, id: \.id) { product in
            Text(product.title)
        }.task {
            do {
                try await populateProducts()
            } catch {
                print(error)
            }
        }
    }
}

struct ProductListView_Previews: PreviewProvider {
    static var previews: some View {
        ProductListView()
    }
}
