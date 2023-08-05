//
//  VariantButton.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 29.07.23.
//

import UIKit

public class VariantButton: UIButton {
    
    // MARK: - Properties
    
    public enum ButtonState {
        case active
        case inactive
    }
    
    public var buttonState: ButtonState = .inactive {
        didSet {
            updateButtonAppearance()
        }
    }
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {

        updateButtonAppearance()
    }
    
    // MARK: - State Update
    
    private func updateButtonAppearance() {
        switch buttonState {
        case .active:
            self.backgroundColor = AppColors.VariantButtonActiveBackground
            self.setTitleColor(AppColors.VariantButtonActiveTextColor, for: .normal)
        case .inactive:
            self.backgroundColor = AppColors.VariantButtonInactiveBackground
            self.setTitleColor(AppColors.VariantButtonInactiveTextColor, for: .normal)
        }
        self.layer.cornerRadius = 15
        self.set(height: 40)
    }

}
