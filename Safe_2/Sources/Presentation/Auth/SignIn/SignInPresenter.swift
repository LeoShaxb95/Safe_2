//
//  SignInPresenter.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 07.08.23.
//

import Foundation

protocol SignInPresenterProtocol {
    func moveToSignUpScreen()
    func moveToStartPageScreen()
}

struct SignInOutput {
    var onMoveToSignUp: (() -> Void)!
    var onMoveToStartPage: (() -> Void)!
}

final class SignInPresenter {
    private let output: SignInOutput
    
    //MARK: - Init
    
    init(output: SignInOutput) {
        self.output = output
    }
}

extension SignInPresenter: SignInPresenterProtocol {
    func moveToSignUpScreen() {
        output.onMoveToSignUp()
    }
    
    func moveToStartPageScreen() {
        output.onMoveToStartPage()
    }
}

