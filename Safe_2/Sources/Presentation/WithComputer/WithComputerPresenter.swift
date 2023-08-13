//
//  WithComputerPresenter.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 30.07.23.
//

import Foundation

protocol WithComputerPresenterRouterProtocol {
    func moveToStartPageScreen()
    func moveToCreatePasswordScreen()
}

protocol WithComputerPresenterStoreProtocol {
    func getUser(completion: @escaping (UserModel?) -> Void)
}

struct WithComputerOutput {
    var onMoveToStartPage: (() -> Void)!
    var onMoveCreatePasswordPage: (() -> Void)!
}

final class WithComputerPresenter {
    private let output: WithComputerOutput
    
    //MARK: - Init
    
    init(output: WithComputerOutput) {
        self.output = output
    }
}

extension WithComputerPresenter: WithComputerPresenterRouterProtocol {
    func moveToStartPageScreen() {
        output.onMoveToStartPage()
    }
    
    func moveToCreatePasswordScreen() {
        output.onMoveCreatePasswordPage()
    }
}

extension WithComputerPresenter: WithComputerPresenterStoreProtocol {
    
    func getUser(completion: @escaping (UserModel?) -> Void) {
        let usersCollection = db.collection("users")
        let userId = SignInVC.userId
        let userDocRef = db.collection("users").document(userId)
        
        usersCollection.document(userId).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                
                if let points = data?["Points"] as? Int,
                   let winCount = data?["Wins"] as? Int,
                   let lossesCount = data?["Losses"] as? Int {
                    
                    let userModel = UserModel(userId: userId, level: nil, status: nil, name: nil, email: nil, points: points, winCount: winCount, loseCount: lossesCount)
                    completion(userModel)
                } else {
                    completion(nil)
                }
            } else {
                completion(nil)
            }
        }
    }
    
}

