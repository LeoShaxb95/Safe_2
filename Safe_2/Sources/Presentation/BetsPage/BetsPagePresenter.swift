//
//  BetsPagePresenter.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 30.07.23.
//

import Foundation

protocol BetsPagePresenterProtocol {
    func moveToGuessOnlyScreen()
    func moveToCreatePasswordScreen()
}

protocol BetsPagePresenterStoreProtocol {
    func getUser(completion: @escaping (UserModel?) -> Void)
}

struct BetsPageOutput {
    var onMoveToGuessOnly: (() -> Void)!
    var onMoveToCreatePassword: (() -> Void)!
}

final class BetsPagePresenter {
    private let output: BetsPageOutput
    
    // MARK: - Init
    
    init(output: BetsPageOutput) {
        self.output = output
    }
}

extension BetsPagePresenter: BetsPagePresenterProtocol {
    func moveToGuessOnlyScreen() {
        output.onMoveToGuessOnly()
    }
    
    func moveToCreatePasswordScreen() {
        output.onMoveToCreatePassword()
    }
}



extension BetsPagePresenter: BetsPagePresenterStoreProtocol {
    
    func getUser(completion: @escaping (UserModel?) -> Void) {
        let usersCollection = db.collection("users")
        let userId = SignInVC.userId
        let userDocRef = db.collection("users").document(userId)
        
        usersCollection.document(userId).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                
                if let points = data?["Points"] as? Int {
                    
                    let userModel = UserModel(userId: userId, level: nil, status: nil, name: nil, email: nil, points: points, winCount: nil, loseCount: nil, profilePictureURL: nil)
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
