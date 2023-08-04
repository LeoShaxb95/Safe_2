//
//  NumbersStackView.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 03.08.23.
//

import Foundation

import UIKit

class NumbersStackView: UIStackView {
    
    var arrayOfNumberIndexes = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    private var numberButtons: [NumberButton] = []

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        axis = .horizontal
        distribution = .fillEqually
        spacing = 8

        for number in 0...9 {
            let button = NumberButton()
            button.tag = number
            button.setImage(UIImage(systemName: "\(number).circle"), for: .normal)
            button.addTarget(self, action: #selector(numberButtonsPressed), for: .touchUpInside)
            addArrangedSubview(button)
            numberButtons.append(button)
        }
    }

    @objc private func numberButtonsPressed(_ sender: UIButton) {
        let numberIndex = sender.tag

        // Assuming you have a function named `changeNumberOf` and `arrayOfNumberIndexes`
        let newIndex = changeNumberOf(index: arrayOfNumberIndexes[numberIndex])
        arrayOfNumberIndexes[numberIndex] = newIndex

        changeButtonColor(button: sender, index: arrayOfNumberIndexes[numberIndex])
    }
    
    func changeNumberOf(index: Int) -> Int {
        var newIndex = 0
        
        switch index {
        case 0:
            newIndex = 1
        case 1:
            newIndex = 2
        case 2:
            newIndex = 0
        default:
            break
        }
        return newIndex
    }

    private func changeButtonColor(button: UIButton, index: Int) {
        switch index {
        case 0:
            button.backgroundColor = .systemGray2
        case 1:
            button.backgroundColor = .systemGreen
        case 2:
            button.backgroundColor = .systemRed
        default:
            break
        }
    }
    
    func unColoringNumberButtons() {
        
        for button in numberButtons {
            button.backgroundColor = .systemGray2
        }
    }
}
