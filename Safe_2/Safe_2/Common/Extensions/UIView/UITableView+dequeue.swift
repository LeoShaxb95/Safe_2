//
//  UITableView+dequeue.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 11.08.23.
//

import UIKit

public extension UITableView {
    
    func dequeue<T: AnyObject>(
        cell cellType: T.Type,
        for indexPath: IndexPath
    ) -> T {
        dequeueReusableCell(
            withIdentifier: String(describing: cellType),
            for: indexPath
        ) as! T
    }
}
