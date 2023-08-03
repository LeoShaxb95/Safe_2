//
//  BetsPagePresenter.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 30.07.23.
//

import Foundation

protocol BetsPagePresenterProtocol {
    func moveToGuessOnlyScreen()
    func moveToCreatePasswordScreen()
}

struct BetsPageOutput {
    var onMoveToGuessOnly: (() -> Void)!
    var onMoveToCreatePassword: (() -> Void)!
}

final class BetsPagePresenter {
    private let output: BetsPageOutput
    
    // MARK: - Init
    
    init(output: BetsPageOutput) {
        self.output = output
    }
}

extension BetsPagePresenter: BetsPagePresenterProtocol {
    func moveToGuessOnlyScreen() {
        output.onMoveToGuessOnly()
    }
    
    func moveToCreatePasswordScreen() {
        output.onMoveToCreatePassword()
    }
}
