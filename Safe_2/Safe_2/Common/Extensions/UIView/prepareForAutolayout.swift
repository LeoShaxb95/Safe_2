//
//  prepareForAutolayout.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 29.07.23.
//

import UIKit

public func prepareForAutolayout<T: UIView>(_ view: T) -> T {
    view.translatesAutoresizingMaskIntoConstraints = false
    
    return view
}
