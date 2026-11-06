//
//  LoginView.swift
//  Parcial 2
//
//  Created by Emiliano Montes Gómez on 05/11/26.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject private var session: SessionStore
    
    @State private var username = ""
    @State private var password = ""
    
    private var canSubmit: Bool{
        !username.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !password.isEmpty && !session.isLoading
    }
    
    var body: some View {
        NavigationStack{
            Form {
                Section ("Cuenta"){
                    TextField("Usuario", text: $username)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .textContentType(.username)
                    SecureField("Contraseña", text: $password)
                        .textContentType(.password)
                }
                
                if let errorMessage = session.errorMessage {
                    Section{
                        Label(errorMessage, systemImage: "exclamationmark.triangle.fill")
                            .foregroundStyle(.red)
                    }
                }
                
                Section {
                    Button{
                        Task{
                            await session.login(username: username, password: password)
                        }
                    } label : {
                        if session.isLoading {
                            ProgressView()
                                .frame(maxWidth: .infinity)
                        } else {
                            Text("Log in")
                                .frame(maxWidth: .infinity)
                        }
                    }
                    .disabled(!canSubmit)
                } footer: {
                    Text("Usuario de prueba: emilys / emilyspass")
                }
            }
            .navigationTitle("Iniciar sesión")
            .sensoryFeedback(trigger: session.errorMessage){
                _, newValue in
                newValue == nil ? nil : .error
            }
        }
    }
}

#Preview {
    LoginView()
        .environmentObject(SessionStore())
}
