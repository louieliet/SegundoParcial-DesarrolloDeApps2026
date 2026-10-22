//
//  FavoritesView.swift
//  Parcial 2
//
//  Created by Emiliano Montes Gómez on 21/10/26.
//

import SwiftUI


struct FavoritesView: View {
    @ObservedObject var viewModel: ProductListViewModel
    @ObservedObject var favoritesStore: FavoriteStores
    
    
    private var favoriteProducts: [Product] {
        viewModel.products.filter { product in
            favoritesStore.contains(product)
        }
    }
    
    var body: some View {
        NavigationStack{
            content
                .navigationTitle("Favoritos")
        }
    }
    
    @ViewBuilder
    private var content: some View {
        if viewModel.state == .idle || viewModel.state == .loading {
            LoadingProductsView()
        } else if favoriteProducts.isEmpty {
            ContentUnavailableView("Aún no tienes favoritos", systemImage: "heart")
        } else {
            List(favoriteProducts) { product in
                NavigationLink {
                    //ProductDetailView(product: product, favoritesStore: favoritesStore)
                } label : {
                    ProductRowView(product: product, isFavorite: true)
                }
                //La lógica de quitar un favorito
                //.swipeActions()
            }
            .listStyle(.plain)
        }
    }
    
}
