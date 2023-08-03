//
//  UIStackView+addArrangedSubviews.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 29.07.23.
//

import UIKit

public extension UIStackView {
    
    func addArrangedSubviews(_ views: [UIView], prepareForAutolayout needToPrepare: Bool = true) {
        views.forEach { addArrangedSubview(needToPrepare ? prepareForAutolayout($0) : $0) }
    }
}
