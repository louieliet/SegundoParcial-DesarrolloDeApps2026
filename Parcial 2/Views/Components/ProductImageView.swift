//
//  ProductImageView.swift
//  Parcial 2
//
//  Created by Emiliano Montes Gómez on 15/10/26.
//

import SwiftUI

struct ProductImageView: View {
    let imageURL: String
    let size: CGFloat
    var body: some View {
        AsyncImage(url: URL(string: imageURL)){ phase in
            switch phase {
            case .empty:
                ProgressView()
                    .frame(width: size, height: size)
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(width: size, height: size)
            case .failure:
                Image(systemName: "photo")
                    .font(.system(size: size * 0.32))
                    .foregroundStyle(.secondary)
                    .frame(width: size, height: size)
            }
        }
        .clipShape(RoundedRectangle(cornerRadius: 8))
        .accessibilityLabel("Imagen del producto")
    }
}

#Preview{
    ProductImageView(imageURL: Product.example.thumbnail, size: 200)
}
