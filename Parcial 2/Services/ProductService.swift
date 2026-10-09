//
//  ProductService.swift
//  Parcial 2
//
//  Created by Emiliano Montes Gómez on 24/09/26.
//

import Foundation

protocol ProductServiceProtocol : Sendable {
    func fetchProducts() async throws -> [Product]
}

enum ProductServiceError : LocalizedError, Sendable {
    
    case invalidURL
    
    case invalidResponse
    
    case serverError(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "No se pudo construir la dirección del servicio"
        case .invalidResponse:
            return "El servidor envio una respuesta no valida"
        case .serverError(let statusCode):
            return "El servidor respondio con el codigo \(statusCode)"
        }
    }
    
}

struct ProductService: ProductServiceProtocol {
    private let endpoint = "https://dummyjson.com/products?limit=30"
    
    func fetchProducts() async throws -> [Product] {
        guard let url = URL(string: endpoint) else {
            throw ProductServiceError.invalidURL
        }
        
        let(data, response) = try await URLSession.shared.data(from: url)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw ProductServiceError.invalidResponse
        }
        
        guard (200..<300).contains(httpResponse.statusCode) else {
            throw ProductServiceError.serverError(statusCode: httpResponse.statusCode)
        }
        
        let responseModel = try JSONDecoder().decode(ProductResponse.self, from: data)
        
        return responseModel.products
    }
    
}
