//
//  ProfileView.swift
//  Parcial 2
//
//  Created by Emiliano Montes Gómez on 11/11/26.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject private var session: SessionStore
    
    var body: some View {
        NavigationStack{
            List{
                if let user = session.user {
                    Section{
                        HStack(spacing: 16){
                            AsyncImage(url: URL(string: user.image)) { image in
                                image
                                    .resizable()
                                    .scaledToFill()
                            } placeholder: {
                                Image(systemName: "person.crop.circle.fill")
                                    .resizable()
                                    .foregroundStyle(.secondary)
                            }
                            .frame(width: 72, height: 72)
                            .clipShape(Circle())
                            
                            VStack(alignment: .leading, spacing: 4){
                                Text(user.fullName)
                                    .font(.title3)
                                    .fontWeight(.semibold)
                                Text("@\(user.username)")
                                    .foregroundStyle(.secondary)
                            }
                        }
                    }
                    
                    Section("Datos"){
                        LabeledContent("Correo:", value: user.email)
                        LabeledContent("ID de usuario:", value: "\(user.id)")
                    }
                }
                
                if let errorMessage = session.errorMessage{
                    Section{
                        Label(errorMessage, systemImage: "exclamationmark.triangle")
                            .foregroundStyle(.orange)
                    }
                }
                
                Section{
                    Button("Cerrar sesión", role: .destructive){
                        session.logout()
                    }
                }
            }
            .navigationTitle("Perfil")
            .task{
                await session.refreshProfile()
            }
            .refreshable {
                await session.refreshProfile()
            }
        }
    }
}

#Preview {
    ProfileView()
        .environmentObject(SessionStore())
}
