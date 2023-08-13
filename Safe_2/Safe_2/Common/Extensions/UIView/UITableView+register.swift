//
//  UITableView+register.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 11.08.23.
//

import UIKit

public extension UITableView {
    func register(_ cellClass: AnyClass) {
        register(cellClass, forCellReuseIdentifier: String(describing: cellClass))
    }
}
