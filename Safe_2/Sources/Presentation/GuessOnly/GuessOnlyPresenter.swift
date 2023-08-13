//
//  GuessOnlyPresenter.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 30.07.23.
//

protocol GuessOnlyPresenterRouterProtocol {
    func moveToStartPageScreen()
}

protocol GuessOnlyPresenterStoreProtocol {
    func getUser(completion: @escaping (UserModel?) -> Void)
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

extension GuessOnlyPresenter: GuessOnlyPresenterRouterProtocol {
    func moveToStartPageScreen() {
        output.onMoveToStartPage()
    }
}

extension GuessOnlyPresenter: GuessOnlyPresenterStoreProtocol {
    
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

