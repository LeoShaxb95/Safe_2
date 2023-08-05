//
//  SubmitButton.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 29.07.23.
//

import UIKit

public class SubmitButton: UIButton {

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
            self.backgroundColor = AppColors.submutButtonEnabledBackground
            self.setTitleColor(AppColors.submutButtonEnabledTitleColor, for: .normal)
        case .inactive:
            self.backgroundColor = AppColors.submutButtonDisabledBackground
            self.setTitleColor(AppColors.submutButtonDisabledTitleColor, for: .normal)
        }
        self.layer.cornerRadius = 16
        self.titleLabel?.font = .systemFont(ofSize: 20, weight: .bold)
    }

}

