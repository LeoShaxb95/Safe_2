//
//  GuessOnlyPresenter.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 30.07.23.
//

protocol GuessOnlyPresenterProtocol {
    func moveToStartPageScreen()
}

struct GuessOnlyOutput {
    var onMoveToStartPage: (() -> Void)!
}

final class GuessOnlyPresenter {
    private let output: GuessOnlyOutput
    
    //MARK: - Init
    
    init(output: GuessOnlyOutput) {
        self.output = output
    }
}

extension GuessOnlyPresenter: GuessOnlyPresenterProtocol {
    func moveToStartPageScreen() {
        output.onMoveToStartPage()
    }
}
