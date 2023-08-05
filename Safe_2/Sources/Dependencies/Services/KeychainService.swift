//
//  KeychainService.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 29.07.23.
//

import Foundation
import KeychainSwift

open class KeychainService {
    private let keychain = KeychainSwift()
    
    public func get(_ key: String) -> String? {
        return keychain.get(key)
    }
    
    public func getData(_ key: String) -> Data? {
        keychain.getData(key)
    }
    
    public func set(key: String, value: String) {
        keychain.set(value, forKey: key)
    }
    
    public func setData(key: String, value: Data) {
        keychain.set(value, forKey: key)
    }
    
    public func remove(key: String) {
        keychain.delete(key)
    }
    
    public func clearAll() {
        keychain.clear()
    }
}

