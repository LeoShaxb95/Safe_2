//
//  CreatePasswordPresenter.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 01.08.23.
//

import Foundation

protocol CreatePasswordPresenterProtocol {
    func moveToWithComputerScreen()
    func moveToPlayOnlineScreen()
}

struct CreatePasswordOutput {
    var onMoveToWithComputer: (() -> Void)!
    var onMoveToPlayOnline: (() -> Void)!
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
    
    func moveToPlayOnlineScreen() {
        output.onMoveToPlayOnline()
    }
}

