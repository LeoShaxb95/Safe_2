//
//  BaseVC.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 29.07.23.
//

import UIKit

open class BaseVC: UIViewController {

    // MARK: - Lifecycle
    
    override open func viewDidLoad() {
        super.viewDidLoad()
            
        setupSubviews()
        setupAutolayout()
    }
    
    // MARK: - Setup
    
    open func setupSubviews() {
        assertionFailure("\(#function) needs to be overriden.")
    }
    
    open func setupAutolayout() {
        assertionFailure("\(#function) needs to be overriden.")
    }
    
    open func bind() {}
    
}
