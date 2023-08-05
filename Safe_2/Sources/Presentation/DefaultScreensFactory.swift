//
//  DefaultScreensFactory.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 29.07.23.
//

import UIKit

protocol ScreensFactory {
    func makeStartPage() -> StartPageVC
    func makeBetsPage() -> BetsPageVC
    func makeGuessOnly() -> GuessOnlyVC
    func makeWithComputer() -> WithComputerVC
    func makePlayOnline() -> PlayOnlineVC
}

class DefaultScreensFactory: ScreensFactory {
  
    public static let shared: ScreensFactory  = DefaultScreensFactory()
    
    private init() {}
    
    func makeStartPage() -> StartPageVC {
        var output = StartPageOutput()
        
        output.onMoveToBetsPage = { [weak self] in
            guard let self else { return }
            let vc = self.makeBetsPage()
            SceneDelegate.router?.push(module: vc, animated: true)
        }
        
        let presenter = StartPagePresenter(output: output)
        return StartPageVC(presenter: presenter)
    }
    
    func makeBetsPage() -> BetsPageVC {
        var output = BetsPageOutput()
        
        output.onMoveToGuessOnly = { [weak self] in
            guard let self else { return }
            let vc = self.makeGuessOnly()
            SceneDelegate.router?.push(module: vc, animated: true)
        }
        
        output.onMoveToCreatePassword = { [weak self] in
            guard let self else { return }
            let vc = self.makeCreatePassword()
            SceneDelegate.router?.push(module: vc, animated: true)
        }
        
        let presenter = BetsPagePresenter(output: output)
        return BetsPageVC(presenter: presenter)
    }
    
    func makeGuessOnly() -> GuessOnlyVC {
        var output = GuessOnlyOutput()
        
        output.onMoveToStartPage = { [weak self] in
            guard let self else { return }
            let vc = self.makeStartPage()
            SceneDelegate.router?.push(module: vc, animated: true)
        }
        
        let presenter = GuessOnlyPresenter(output: output)
        return GuessOnlyVC(presenter: presenter)
    }
    
    func makeCreatePassword() -> CreatePasswordVC {
        var output = CreatePasswordOutput()
        
        output.onMoveToWithComputer = { [weak self] in
            guard let self else { return }
            let vc = self.makeWithComputer()
            SceneDelegate.router?.push(module: vc, animated: true)
        }
        
        output.onMoveToPlayOnline = { [weak self] in
            guard let self else { return }
            let vc = self.makePlayOnline()
            SceneDelegate.router?.push(module: vc, animated: true)
        }
        
        let presenter = CreatePasswordPresenter(output: output)
        return CreatePasswordVC(presenter: presenter)
    }
    
    func makeWithComputer() -> WithComputerVC {
        var output = WithComputerOutput()
        
        output.onMoveToStartPage = { [weak self] in
            guard let self else { return }
            let vc = self.makeStartPage()
            SceneDelegate.router?.push(module: vc, animated: true)
        }
        
        output.onMoveCreatePasswordPage = { [weak self] in
            guard let self else { return }
            let vc = self.makeCreatePassword()
            SceneDelegate.router?.push(module: vc, animated: true)
        }
        
        let presenter = WithComputerPresenter(output: output)
        return WithComputerVC(presenter: presenter)
    }
    
    func makePlayOnline() -> PlayOnlineVC {
        var output = PlayOnlineOutput()
        
        output.onMoveToStartPage = { [weak self] in
            guard let self else { return }
            let vc = self.makeStartPage()
            SceneDelegate.router?.push(module: vc, animated: true)
        }
        
        let presenter = PlayOnlinePresenter(output: output)
        return PlayOnlineVC(presenter: presenter)
    }
}

private extension DefaultScreensFactory {

}

