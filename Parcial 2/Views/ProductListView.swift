//
//  ProductListView.swift
//  Parcial 2
//
//  Created by Emiliano Montes Gómez on 21/10/26.
//



import SwiftUI

struct ProductListView: View {
    @ObservedObject var viewModel: ProductListViewModel
    @ObservedObject var favoritesStore: FavoriteStores

    var body: some View {
        NavigationStack {
            content
                .navigationTitle("Product Explorer")
                .searchable(text: $viewModel.searchText, prompt: "Buscar por nombre, marca o categoria")
                .refreshable {
                    await viewModel.loadProducts()
                }
        }
    }

    @ViewBuilder
    private var content: some View {
        switch viewModel.state {
        case .idle:
            LoadingProductsView()

        case .loading:
            LoadingProductsView()

        case .empty:
            ContentUnavailableView(
                "No hay productos",
                systemImage: "shippingbox",
                description: Text("El servicio no devolvio contenido en este momento.")
            )

        case .loaded:
            loadedContent

        case .failed(let message):
            ProductErrorView(message: message) {
                Task {
                    await viewModel.loadProducts()
                }
            }
        }
    }

    @ViewBuilder
    private var loadedContent: some View {
        if viewModel.filteredProducts.isEmpty {
            ContentUnavailableView(
                "Sin resultados",
                systemImage: "magnifyingglass",
                description: Text("No encontramos coincidencias para \"\(viewModel.searchText)\".")
            )
        } else {
            List(viewModel.filteredProducts) { product in
                NavigationLink {
                    ProductDetailView(product: product, favoritesStore: favoritesStore)
                } label: {
                    ProductRowView(
                        product: product,
                        isFavorite: favoritesStore.contains(product)
                    )
                }
               //Borrar favorito
            }
            .listStyle(.plain)
        }
    }
}

