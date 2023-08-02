//
//  passwordNumberButton.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 01.08.23.
//

import UIKit

public class PasswordNumberButton: UIButton {
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupButton()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setupButton()
    }
    
    // MARK: - Customization
    
    private func setupButton() {
        self.tintColor = AppColors.passwordNumberButtonColor
        self.backgroundColor = .white
        self.isUserInteractionEnabled = true
    }
    
}
