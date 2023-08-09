//
//  PasswordPresenter.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 08.08.23.
//

protocol PasswordPresenterProtocol {
    func moveToStartPageScreen()
}

struct PasswordOutput {
    var onMoveToStartPage: (() -> Void)!
}

final class PasswordPresenter {
    private let output: PasswordOutput
    
    //MARK: - Init
    
    init(output: PasswordOutput) {
        self.output = output
    }
}

extension PasswordPresenter: PasswordPresenterProtocol {
    func moveToStartPageScreen() {
        output.onMoveToStartPage()
    }
}
