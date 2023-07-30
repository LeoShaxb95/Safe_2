//
//  DefaultScreensFactory.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 29.07.23.
//

import UIKit

protocol ScreensFactory {
    func makeStartPage() -> StartPageVC
}

class DefaultScreensFactory: ScreensFactory {
    
    public static let shared: ScreensFactory  = DefaultScreensFactory()
    
    private init() {}
    
    func makeStartPage() -> StartPageVC {
        let presenter = StartPagePresenter()
        return StartPageVC()
    }
}

private extension DefaultScreensFactory {

}

