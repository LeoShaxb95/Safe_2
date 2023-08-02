//
//  AlertButton.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 01.08.23.
//

import UIKit

public class AlertButton: UIButton {
    
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
        self.backgroundColor = .systemGray
        self.titleLabel?.font = .systemFont(ofSize: 17, weight: .bold)
        self.layer.cornerRadius = 20
        self.clipsToBounds = true // Clip subviews to rounded corners
        self.isUserInteractionEnabled = true
        self.isEnabled = true
    }
    
}
