//
//  PlayOnlinePresenter.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 03.08.23.
//

protocol PlayOnlinePresenterProtocol {
    func moveToStartPageScreen()
}

struct PlayOnlineOutput {
    var onMoveToStartPage: (() -> Void)!
}

final class PlayOnlinePresenter {
    private let output: PlayOnlineOutput
    
    //MARK: - Init
    
    init(output: PlayOnlineOutput) {
        self.output = output
    }
}

extension PlayOnlinePresenter: PlayOnlinePresenterProtocol {
    func moveToStartPageScreen() {
        output.onMoveToStartPage()
    }
}
