import SwiftUI


struct ContentView: View {
    
    @StateObject private var viewModel = ProductListViewModel()
    
    @StateObject private var favoritesStore = FavoriteStores()

    var body: some View {
        TabView {
            ProductListView(viewModel: viewModel, favoritesStore: favoritesStore)
                .tabItem {
                    Label("Explorar", systemImage: "square.grid.2x2")
                }
            FavoritesView(viewModel: viewModel, favoritesStore: favoritesStore)
                .tabItem {
                    Label("Favoritos", systemImage: "heart")
                }
        }
        .task {
            await viewModel.loadProductsIfNeeded()
        }
    }
}

#Preview {
    ContentView()
}

