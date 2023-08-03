//
//  Dependencies.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 29.07.23.
//

import Foundation

open class Dependencies {
    public static let shared = Dependencies()
    
    public lazy var keychainService: KeychainService = .init()
    
    private init() {}
}

