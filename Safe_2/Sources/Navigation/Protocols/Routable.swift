//
//  Routable.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 29.07.23.
//

import Foundation

public protocol Routable: Presentable {
    
    func present(module: Presentable?)
    func present(module: Presentable?, animated: Bool)
    
    func push(module: Presentable?)
    func push(module: Presentable?, hideBottomBar: Bool)
    func push(module: Presentable?, animated: Bool)
    func push(module: Presentable?, animated: Bool, completion: (() -> Void)?)
    func push(module: Presentable?, animated: Bool, hideBottomBar: Bool, completion: (() -> Void)?)
    
    func pop()
    func pop(animated: Bool)
    
    func dismiss()
    func dismiss(animated: Bool, completion: (() -> Void)?)
    
    func setRoot(module: Presentable?)
    func setRoot(module: Presentable?, hideBar: Bool)
    
    func popToRoot(animated: Bool)
    func popTo(module: AnyClass, animated: Bool)
}
