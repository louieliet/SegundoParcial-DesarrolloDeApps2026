//
//  FavoriteStores.swift
//  Parcial 2
//
//  Created by Emiliano Montes Gómez on 07/10/26.
//

import Foundation
import Combine

@MainActor
final class FavoriteStores: ObservableObject {
    @Published private(set) var favoriteProductIDs: Set<Int>
    
    private let storageKey = "favoriteProductsIDs"
    
    private let userDefaults: UserDefaults
    
    init(userDefaults: UserDefaults = .standard){
        self.userDefaults = userDefaults
        let storedIDs = userDefaults.array(forKey: storageKey) as? [Int] ?? []
        self.favoriteProductIDs = Set(storedIDs)
    }
    
    func contains(_ product: Product) -> Bool {
        favoriteProductIDs.contains(product.id)
    }
    
    func toggle(_ product: Product){
        if contains(product){
            favoriteProductIDs.remove(product.id)
        }
        else{
            favoriteProductIDs.insert(product.id)
        }
        
        save()
    }
    
    private func save(){
        let sortedIDs = favoriteProductIDs.sorted()
        userDefaults.set(sortedIDs, forKey: storageKey)
    }
    
}
