//
//  SessionStore.swift
//  Parcial 2
//
//  Created by Emiliano Montes Gómez on 29/10/26.
//

import Foundation
import Combine

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
    
    private let service = AuthService()
    
    init(userDefaults: UserDefaults = .standard){
        self.userDefaults = userDefaults
        self.token = userDefaults.string(forKey: tokenKey)
        
        if let data = userDefaults.data(forKey: userKey){
            self.user = try? JSONDecoder().decode(UserProfile.self, from: data)
        }
    }
    
    func login(username: String, password: String) async {
        errorMessage = nil
        isLoading = true
        
        do{
            let response = try await service.login(username: username.trimmingCharacters(in: .whitespacesAndNewlines), password: password)
            
            token = response.accessToken
            user = response.profile
            
            save()
            
        } catch {
            errorMessage = error.localizedDescription
        }
        
        isLoading = false
        
    }
    
    func logout(){
        token = nil
        user = nil
        errorMessage = nil
        
        userDefaults.removeObject(forKey: tokenKey)
        userDefaults.removeObject(forKey: userKey)
    }
    
    func save(){
        userDefaults.set(token, forKey: tokenKey)
        
        if let user, let data = try? JSONEncoder().encode(user) {
            userDefaults.set(data, forKey: userKey)
        }
    }
    
    func refreshProfile() async {

        guard let token else {
            return
        }
        
        do{
            user = try await service.fetchProfile(token: token)
            errorMessage = nil
            save()
            
        } catch AuthServiceError.sessionExpired {
            logout()
        } catch {
            errorMessage = error.localizedDescription
        }
        
        
    }
    
    
}
