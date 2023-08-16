//
//  ProfilePresenter.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 10.08.23.
//

import Foundation

protocol ProfilePresenterProtocol {
    func moveToSignInScreen()
}

struct ProfileOutput {
    var onMoveToSignIn: (() -> Void)!
}

final class ProfilePresenter {
    var output: ProfileOutput
    
    //MARK: - Init
    
    init(output: ProfileOutput) {
        self.output = output
    }
}

extension ProfilePresenter: ProfilePresenterProtocol {
    func moveToSignInScreen() {
        output.onMoveToSignIn()
    }
}
