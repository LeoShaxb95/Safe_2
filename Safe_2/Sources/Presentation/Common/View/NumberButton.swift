//
//  NumberButton.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 01.08.23.
//

import UIKit

public class NumberButton: UIButton {
    
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
        self.backgroundColor = .systemGray2
        self.tintColor = .darkGray
        self.isUserInteractionEnabled = true
        self.layer.cornerRadius = 12
    }
    
}
