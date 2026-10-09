//
//  ProductListViewModel.swift
//  Parcial 2
//
//  Created by Emiliano Montes Gómez on 08/10/26.
//

import Foundation
import Combine

enum ProductLoadState: Equatable {
    case idle
    
    case loading
    
    case loaded
    
    case empty
    
    case failed(message: String)
}

@MainActor
final class ProductListViewModel : ObservableObject {
    @Published private(set) var products: [Product] = []
    
    @Published private(set) var state: ProductLoadState = .idle
    
    @Published var searchText = ""
    
    private let service: any ProductServiceProtocol
    
    init(){
        self.service = ProductService()
    }
    
    var filteredProducts: [Product] {
        let query = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        
        guard !query.isEmpty else{
            return products
        }
        
        return products.filter{ product in
            product.title.localizedCaseInsensitiveContains(query)
            || product.formattedCategory.localizedCaseInsensitiveContains(query)
            ||
            (product.brand?.localizedCaseInsensitiveContains(query) ?? false)
            
        }
    }
    
    func loadProductsIfNeeded() async {
        guard products.isEmpty, state != .loading else {
            return
        }
        await loadProducts()
    }
    
    func loadProducts() async {
        state = .loading
        
        do{
            let downloadedProducts = try await service.fetchProducts()
            
            products = downloadedProducts
            
            state = downloadedProducts.isEmpty ? .empty : .loaded
        } catch {
            products = []
            state = .failed(message: error.localizedDescription)
        }
        
    }
    
    
}
