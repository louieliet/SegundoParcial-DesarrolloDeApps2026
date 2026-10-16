//
//  LoadStateViews.swift
//  Parcial 2
//
//  Created by Emiliano Montes Gómez on 15/10/26.
//

import SwiftUI

struct LoadingProductsView: View {
    var body: some View{
        VStack(spacing: 12){
            ProgressView()
            Text("Cargando productos...")
                .foregroundStyle(.secondary)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
    }
}


struct ProductErrorView: View {
    let message: String
    let retryAction: () -> Void
    
    var body: some View {
        ContentUnavailableView {
            Label("No se pudo cargar", systemImage: "wifi.exclamationmark")
        } description: {
            Text(message)
        } actions: {
            Button("Reintentar", action: retryAction)
                .buttonStyle(.borderedProminent)
        }
    }
}
