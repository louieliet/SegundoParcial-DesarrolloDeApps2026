//
//  Product.swift
//  Parcial 2
//
//  Created by Emiliano Montes Gómez on 23/09/26.
//

import Foundation

struct ProductResponse: Decodable, Sendable{
    let products: [Product]
}

struct Product: Identifiable, Decodable, Sendable, Equatable {
    let id: Int
    let title: String
    let description: String
    let category: String
    let price: Double
    let rating: Double
    let stock: Int
    let brand: String?
    let thumbnail: String
    
    var formattedCategory: String{
        category
            .replacingOccurrences(of: "-", with: " ")
            .capitalized
    }
    
    static let example = Product(
        id: 1,
        title: "Ejemplo",
        description: "Descripcion",
        category: "categoria",
        price: 9.99,
        rating: 4.9,
        stock: 5,
        brand: "patito",
        thumbnail: "https://i.ytimg.com/vi/d2QMdIuk7Xk/hq720.jpg?sqp=-oaymwE7CK4FEIIDSFryq4qpAy0IARUAAAAAGAElAADIQj0AgKJD8AEB-AG2CIAC0AWKAgwIABABGHIgSCg7MA8%3D&rs=AOn4CLA96jistx6xmB_OzSeBvFhrSTqdtA"
    )
    
}
