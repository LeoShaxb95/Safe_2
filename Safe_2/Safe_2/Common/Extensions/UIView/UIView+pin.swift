//
//  UIView+pin.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 29.07.23.
//

import UIKit

public extension UIView {
    
    // MARK: - Edge

    enum Edge {
        case top
        case bottom
        case leading
        case trailing
    }
    
    // MARK: - Pin
    
    func pin(to view: UIView, inset: CGFloat = 0, toSafeArea: Bool = false) {
        pin(edges: [.top, .bottom, .leading, .trailing], to: view, inset: inset, toSafeArea: toSafeArea)
    }
    
    func pin(
        edges: [Edge],
        to view: UIView,
        inset: CGFloat,
        toSafeArea: Bool = false
    ) {
        pin(
            edges: edges,
            to: view,
            top: inset,
            bottom: inset,
            leading: inset,
            trailing: inset,
            toSafeArea: toSafeArea
        )
    }
    
    func pin(
        edges: [Edge],
        to view: UIView,
        top: CGFloat = 0,
        bottom: CGFloat = 0,
        leading: CGFloat = 0,
        trailing: CGFloat = 0,
        toSafeArea: Bool = false
    ) {
        edges.forEach { edge in
            var constraints = [NSLayoutConstraint]()
            switch edge {
            case .top:
                constraints.append(
                    topAnchor.constraint(
                        equalTo: toSafeArea ? view.safeAreaLayoutGuide.topAnchor : view.topAnchor,
                        constant: top
                    )
                )
            case .bottom:
                constraints.append(
                    bottomAnchor.constraint(
                        equalTo: toSafeArea ? view.safeAreaLayoutGuide.bottomAnchor : view.bottomAnchor,
                        constant: -bottom
                    )
                )
            case .leading:
                constraints.append(
                    leadingAnchor.constraint(
                        equalTo: toSafeArea ? view.safeAreaLayoutGuide.leadingAnchor : view.leadingAnchor,
                        constant: leading
                    )
                )
            case .trailing:
                constraints.append(
                    trailingAnchor.constraint(
                        equalTo: toSafeArea ? view.safeAreaLayoutGuide.trailingAnchor : view.trailingAnchor,
                        constant: -trailing
                    )
                )
            }
            
            view.addConstraints(constraints)
        }
    }
}
