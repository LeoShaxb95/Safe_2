//
//  WithComputerPresenter.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 30.07.23.
//

import Foundation

protocol WithComputerPresenterProtocol {
    func moveToStartPageScreen()
    func moveToCreatePasswordScreen()
}

struct WithComputerOutput {
    var onMoveToStartPage: (() -> Void)!
    var onMoveCreatePasswordPage: (() -> Void)!
}

final class WithComputerPresenter {
    private let output: WithComputerOutput
    
    //MARK: - Init
    
    init(output: WithComputerOutput) {
        self.output = output
    }
}

extension WithComputerPresenter: WithComputerPresenterProtocol {
    func moveToStartPageScreen() {
        output.onMoveToStartPage()
    }
    
    func moveToCreatePasswordScreen() {
        output.onMoveCreatePasswordPage()
    }
}
