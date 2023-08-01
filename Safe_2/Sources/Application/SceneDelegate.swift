//
//  SceneDelegate.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 28.07.23.
//


import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    static var router: Routable?
    static var screenWidth: CGFloat?
    var window: UIWindow?

    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        window = UIWindow(windowScene: windowScene)
        SceneDelegate.screenWidth = windowScene.screen.bounds.width
        
        let nv = UINavigationController()
        window?.rootViewController = nv
        SceneDelegate.router = DefaultRouter(rootController: nv)
        
        window.flatMap(willConnectToSession)
    }
    
    func sceneDidBecomeActive(_ scene: UIScene) {
        let currentDate = Int(Date().timeIntervalSince1970)
        UserDefaults.standard.setValue(currentDate, forKey: "currentSessionSec")
    }
    
    func sceneWillResignActive(_ scene: UIScene) {
        let currentDate = Int(Date().timeIntervalSince1970)
        let oldDate = UserDefaults.standard.integer(forKey: "currentSessionSec")
        
        if oldDate != 0, currentDate > oldDate {
            var totalSessionSec = UserDefaults.standard.integer(forKey: "totalSessionSec")
            
            totalSessionSec += currentDate - oldDate
            
            UserDefaults.standard.setValue(totalSessionSec, forKey: "totalSessionSec")
        }
    }
}

// MARK: - Private methods
private extension SceneDelegate {
    func willConnectToSession(window: UIWindow) {
        window.makeKeyAndVisible()
        let vc = DefaultScreensFactory.shared.makeGuessOnly()
        SceneDelegate.router?.setRoot(module: vc)
    }
}
