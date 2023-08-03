//
//  CustomAlertHome.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 03.08.23.
//

import UIKit

class CustomAlertHome {
    static func showAlert(on viewController: UIViewController, actionTitle: String, actionStyle: UIAlertAction.Style, actionHandler: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: "Confirm exit",
                                      message: "Are You sure You want to exit?\n" +
                                      "All changes you made will be lost",
                                      preferredStyle: UIAlertController.Style.alert)
        
        alert.addAction(UIAlertAction(title: actionTitle,
                                      style: actionStyle,
                                      handler: actionHandler))
        
        alert.addAction(UIAlertAction(title: "Cancel",
                                      style: .cancel,
                                      handler: nil))
        
        viewController.present(alert, animated: true)
    }
}
