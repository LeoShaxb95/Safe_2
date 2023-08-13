//
//  StartPagePresenter.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 29.07.23.
//

import UIKit
import Firebase

let db = Firestore.firestore()
var userModel: UserModel?

protocol StartPagePresenterRouterProtocol {
    func moveToBetsPageScreen(_ finiks: Int)
    func moveToProfileScreen(_ model: UserModel)
}

protocol StartPagePresenterStoreProtocol {
    func getUser(completion: @escaping (UserModel?) -> Void)
}

struct StartPageOutput {
    var onMoveToBetsPage: ((Int) -> Void)!
    var onMoveToProfile: ((UserModel) -> Void)!
}

final class StartPagePresenter {
    private let output: StartPageOutput
    
    // MARK: - Init
    
    init(output: StartPageOutput) {
        self.output = output
    }
}

extension StartPagePresenter: StartPagePresenterRouterProtocol {
    
    func moveToBetsPageScreen(_ finiks: Int) {
        output.onMoveToBetsPage(finiks)
    }
    
    func moveToProfileScreen(_ model: UserModel) {
        output.onMoveToProfile(model)
    }
    
}

extension StartPagePresenter: StartPagePresenterStoreProtocol {
    
    func getUser(completion: @escaping (UserModel?) -> Void) {
        let usersCollection = db.collection("users")
        let userId = SignInVC.userId
        let userDocRef = db.collection("users").document(userId)
        
        usersCollection.document(userId).getDocument { (document, error) in
            if let document = document, document.exists {
                let data = document.data()
                
                if let level = data?["Level"] as? Int,
                   let status = data?["Status"] as? String,
                   let name = data?["Name"] as? String,
                   let email = data?["Email"] as? String,
                   let points = data?["Points"] as? Int,
                   let winCount = data?["Wins"] as? Int,
                   let lossesCount = data?["Losses"] as? Int {
                    
                    let userModel = UserModel(userId: userId, level: level, status: status, name: name, email: email, points: points, winCount: winCount, loseCount: lossesCount)
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
