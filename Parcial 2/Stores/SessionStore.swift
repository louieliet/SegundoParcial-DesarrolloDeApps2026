//
//  SessionStore.swift
//  Parcial 2
//
//  Created by Emiliano Montes Gómez on 29/10/26.
//

import Foundation

@MainActor
final class SessionStore: ObservableObject {
    @Published private(set) var token: String? = nil
    @Published private(set) var user: UserProfile? = nil
    @Published private(set) var isLoading = false
    @Published private(set) var errorMessage: String? = nil
    
    var isLoggedIn: Bool {
        token != nil
    }
    
    private let tokenKey = "sessionToken"
    private let userKey = "sessionUser"
    
    private let userDefaults: UserDefaults
    
    private let sevice = AuthService()
    
}
