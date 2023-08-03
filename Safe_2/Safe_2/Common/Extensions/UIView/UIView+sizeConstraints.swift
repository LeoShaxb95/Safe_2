//
//  UIView+sizeConstraints.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 29.07.23.
//

import UIKit

public extension UIView {
    
    func set(size: CGSize) {
        set(width: size.width, height: size.height)
    }
    
    func set(width: CGFloat, height: CGFloat) {
        set(width: width)
        set(height: height)
    }
    
    func set(width: CGFloat) {
        addConstraint(widthAnchor.constraint(equalToConstant: width))
    }
    
    func set(height: CGFloat) {
        addConstraint(heightAnchor.constraint(equalToConstant: height))
    }
}
