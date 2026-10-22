//
//  ProductDetailView.swift
//  Parcial 2
//
//  Created by Emiliano Montes Gómez on 21/10/26.
//

import SwiftUI

struct ProductDetailView: View {
    let product: Product

    @ObservedObject var favoritesStore: FavoriteStores

    private var isFavorite: Bool {
        favoritesStore.contains(product)
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                HStack {
                    Spacer()
                    ProductImageView(imageURL: product.thumbnail, size: 240)
                    Spacer()
                }

                VStack(alignment: .leading, spacing: 8) {
                    Text(product.title)
                        .font(.title2)
                        .fontWeight(.bold)

                    Text(product.brand ?? product.formattedCategory)
                        .font(.subheadline)
                        .foregroundStyle(.secondary)
                }

                HStack(spacing: 16) {
                    Label(product.price.formatted(.currency(code: "USD")), systemImage: "tag")

                    Label(product.rating.formatted(.number.precision(.fractionLength(1))), systemImage: "star.fill")
                        .foregroundStyle(.yellow)

                    Spacer()

                    Text("Stock: \(product.stock)")
                        .font(.caption)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 5)
                        .background(Color(.secondarySystemBackground))
                        .clipShape(RoundedRectangle(cornerRadius: 8))
                }
                .font(.subheadline)

                Divider()

                VStack(alignment: .leading, spacing: 8) {
                    Text("Descripcion")
                        .font(.headline)

                    Text(product.description)
                        .foregroundStyle(.secondary)
                }

               //Botón para borrar favorito
            }
            .padding()
        }
        .navigationTitle("Detalle")
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack {
        ProductDetailView(product: Product.example, favoritesStore: FavoriteStores())
    }
}
