import SwiftUI


struct ContentView: View {
    
    @EnvironmentObject private var session: SessionStore
    
    @StateObject private var viewModel = ProductListViewModel()
    
    @StateObject private var favoritesStore = FavoriteStores()
    
    var body: some View {
        Group{
            if session.isLoggedIn{
                tabs
            } else {
                LoginView()
            }
        }
        // Punto extra (Subir a blackboard ContentView): Agregar haptico de exito
    }
    
    private var tabs: some View{
        TabView{
            ProductListView(viewModel: viewModel, favoritesStore: favoritesStore)
                .tabItem{
                    Label("Explorar", systemImage: "square.grid.2x2")
                }
            
            FavoritesView(viewModel: viewModel, favoritesStore: favoritesStore)
                .tabItem{
                    Label("Favoritos", systemImage: "heart")
                }
            
            ProfileView()
                .tabItem{
                    Label("Perfil", systemImage: "person.crop.circle")
                }
        }
        .task{
            await viewModel.loadProductsIfNeeded()
        }
        //Punto extra: Vibrar al guardar o quitar un favorito desde cualquier pantalla
    }
}

#Preview {
    ContentView()
        .environmentObject(SessionStore())
}

