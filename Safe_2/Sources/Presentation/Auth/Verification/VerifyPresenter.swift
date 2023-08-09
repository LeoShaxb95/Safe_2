//
//  VerifyPresenter.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 07.08.23.
//

protocol VerifyPresenterProtocol {
    func moveToPasswordScreen()
}

struct VerifyOutput {
    var onMoveToPassword: (() -> Void)!
}

final class VerifyPresenter {
    private let output: VerifyOutput
    
    //MARK: - Init
    
    init(output: VerifyOutput) {
        self.output = output
    }
}

extension VerifyPresenter: VerifyPresenterProtocol {
    func moveToPasswordScreen() {
        output.onMoveToPassword()
    }
}
