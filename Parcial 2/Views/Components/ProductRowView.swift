//
//  ProductRowView.swift
//  Parcial 2
//
//  Created by Emiliano Montes Gómez on 15/10/26.
//

import SwiftUI

struct ProductRowView: View {
    let product: Product
    let isFavorite: Bool
    
    var body: some View {
        HStack(spacing: 12){
            ProductImageView(imageURL: product.thumbnail, size: 76)
            
            VStack(alignment: .leading, spacing: 5) {
                Text(product.title)
                    .font(.headline)
                Text(product.brand ?? product.formattedCategory)
                    .font(.subheadline)
                
            }
        }
    }
    
    
}
