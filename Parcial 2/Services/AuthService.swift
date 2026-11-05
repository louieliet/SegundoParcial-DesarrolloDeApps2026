//
//  AuthService.swift
//  Parcial 2
//
//  Created by Emiliano Montes Gómez on 29/10/26.
//

import Foundation

struct LoginRequest: Encodable, Sendable {
    let username: String
    let password: String
}

struct LoginResponse: Decodable, Sendable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let image: String
    let accessToken: String
    
    var profile: UserProfile {
        UserProfile(
            id: id,
            username: username,
            email: email,
            firstName: firstName,
            lastName: lastName,
            image: image
        )
    }
}

struct UserProfile: Codable, Sendable, Equatable {
    let id: Int
    let username: String
    let email: String
    let firstName: String
    let lastName: String
    let image: String
    
    var fullName: String{
        "\(firstName) \(lastName)"
    }
}

enum AuthServiceError: LocalizedError, Sendable {
    case invalidURL
    case invalidResponse
    case invalidCredentials
    case sessionExpired
    case serverError(statusCode: Int)
    
    var errorDescription: String? {
        switch self {
        case .invalidURL:
            return "No se pudo construir la dirección del servicio"
        case .invalidResponse:
            return "El servidor envío una respuesta no válida"
        case .invalidCredentials:
            return "Usuario o contraseña incorrectos"
        case .sessionExpired:
            return "Tu sesión expiró, inicia sesión de nuevo"
        case .serverError(let statusCode):
            return "El servidor respondió: \(statusCode)"
        }
    }
}

struct AuthService : Sendable {
    private let baseURL = "https://dummyjson.com/auth"
    
    func login(username: String, password: String) async throws -> LoginResponse {
        guard let url = URL(string: "\(baseURL)/login") else {
            throw AuthServiceError.invalidURL
        }
        
        var request = URLRequest(url: url)
        
        request.httpMethod = "POST"
        
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        request.httpBody = try JSONEncoder().encode(LoginRequest(username: username, password: password))
        
        let (data, response) = try await URLSession.shared.data(for: request)
        
        guard let httpResponse = response as? HTTPURLResponse else {
            throw AuthServiceError.invalidResponse
        }
        
        if httpResponse.statusCode == 400{
            throw AuthServiceError.invalidCredentials
        }
        
        guard(200..<300).contains(httpResponse.statusCode) else {
            throw AuthServiceError.serverError(statusCode: httpResponse.statusCode)
        }
        
        return try JSONDecoder().decode(LoginResponse.self, from: data)
        
    }
    
    
    
    
}


