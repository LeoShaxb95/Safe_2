//
//  CreatePasswordPresenter.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 01.08.23.
//

import Foundation

protocol CreatePasswordPresenterProtocol {
    func moveToWithComputerScreen()
}

struct CreatePasswordOutput {
    var onMoveToWithComputer: (() -> Void)!
}

final class CreatePasswordPresenter {
    private let output: CreatePasswordOutput
    
    //MARK: - Init
    
    init(output: CreatePasswordOutput) {
        self.output = output
    }
}

extension CreatePasswordPresenter: CreatePasswordPresenterProtocol {
    func moveToWithComputerScreen() {
        output.onMoveToWithComputer()
    }
}

