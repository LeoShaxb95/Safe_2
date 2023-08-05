//
//  StartPagePresenter.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 29.07.23.
//

import Foundation

protocol StartPagePresenterProtocol {
    func moveToBetsPageScreen()
}

struct StartPageOutput {
    var onMoveToBetsPage: (() -> Void)!
}

final class StartPagePresenter {
    private let output: StartPageOutput
    
    // MARK: - Init
    
    init(output: StartPageOutput) {
        self.output = output
    }
}

extension StartPagePresenter: StartPagePresenterProtocol {
    func moveToBetsPageScreen() {
        output.onMoveToBetsPage()
    }
}
