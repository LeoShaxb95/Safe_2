//
//  CustomAlertReplay.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 03.08.23.
//

import UIKit

class CustomAlertReplay {
    static func showAlert(on viewController: UIViewController, actionTitle: String, actionStyle: UIAlertAction.Style, actionHandler: ((UIAlertAction) -> Void)?) {
        
        let alert = UIAlertController(title: "Confirm reload",
                                      message: "Are You sure You want to replay?",
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
