//
//  SignUpPresenter.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 07.08.23.
//

import Foundation

protocol SignUpPresenterProtocol {
    func moveToVerifyScreen()
    func moveToPassword()
}

struct SignUpOutput {
    var onMoveToVerify: (() -> Void)!
    var onMoveToPassword: (() -> Void)!
}

final class SignUpPresenter {
    private let output: SignUpOutput
    
    //MARK: - Init
    
    init(output: SignUpOutput) {
        self.output = output
    }
}

extension SignUpPresenter: SignUpPresenterProtocol {
    func moveToVerifyScreen() {
        output.onMoveToVerify()
    }
    
    func moveToPassword() {
        output.onMoveToPassword()
    }
}

