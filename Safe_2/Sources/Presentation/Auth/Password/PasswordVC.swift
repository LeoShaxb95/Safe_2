//
//  PasswordVC.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 08.08.23.
//

import UIKit
import Combine
import Firebase
import FirebaseAuth
import SwiftKeychainWrapper

final class PasswordVC: BaseVC {
    
    // MARK: - Properties
    
    var allConfigsPass1 = false
    var allConfigsPass2 = false
    var showPasswordIsOn = false
    var showPassword2IsOn = false
    var newName = ""
    
    // MARK: - Subviews
    
    // Login stack View

    lazy var passwordsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            passStackView,
            repeatPassStackView
        ])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 15

        return stackView
    }()

    lazy var passStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            passShowStackView,
            createLineView(),
            chehckLinesStackView
        ])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5

        return stackView
    }()

    lazy var passShowStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            passTextField,
            showPassButton
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5

        return stackView
    }()

    let passTextField: UITextField = {
        let textField = UITextField()
        textField.text = "Leo-31415"
        textField.keyboardType = .default
        textField.isSecureTextEntry = true
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: AppColors.labelColor]
        )
        textField.addTarget(self, action: #selector(pass1Configs(textField:)),
                            for: .editingChanged
        )
        textField.addTarget(self, action: #selector(pass2Configs(textField:)),
                            for: .editingChanged
        )

        return textField
    }()

    let showPassButton: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.addTarget(self, action: #selector(didTapShowPass),
                         for: .touchUpInside
        )
        button.tintColor = .white

        return button
    }()

    // Check Lines Stack View

    lazy var chehckLinesStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            checkLine1StackView,
            checkLine2StackView,
            checkLine3StackView
        ])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5

        return stackView
    }()

    //CheckLine 1
    lazy var checkLine1StackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            checkButton1,
            checkLabel1
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill

        return stackView
    }()

    let checkButton1: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        button.tintColor = .white

        return button
    }()

    let checkLabel1: UILabel = {
        let label = UILabel()
        label.text = "Lenght greater than 8"
        label.textColor = AppColors.labelColor
        label.backgroundColor = AppColors.signViewBackground
        label.font = .systemFont(ofSize: 10, weight: .regular)

        return label
    }()

    //CheckLine 2
    lazy var checkLine2StackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            checkButton2,
            checkLabel2
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill

        return stackView
    }()

    let checkButton2: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        button.tintColor = .white

        return button
    }()

    let checkLabel2: UILabel = {
        let label = UILabel()
        label.text = "1 uppercase letter"
        label.textColor = AppColors.labelColor
        label.backgroundColor = AppColors.signViewBackground
        label.font = .systemFont(ofSize: 10, weight: .regular)

        return label
    }()

    //CheckLine 3
    lazy var checkLine3StackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            checkButton3,
            checkLabel3
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill

        return stackView
    }()

    let checkButton3: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "circle.fill"), for: .normal)
        button.tintColor = .white

        return button
    }()

    let checkLabel3: UILabel = {
        let label = UILabel()
        label.text = "1 number"
        label.textColor = AppColors.labelColor
        label.backgroundColor = AppColors.signViewBackground
        label.font = .systemFont(ofSize: 10, weight: .regular)

        return label
    }()

    lazy var repeatPassStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            pass2ShowStackView,
            createLineView()
        ])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5

        return stackView
    }()

    lazy var pass2ShowStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            repeatPassTextField,
            showPass2Button
        ])
        stackView.axis = .horizontal
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 5

        return stackView
    }()

    let repeatPassTextField: UITextField = {
        let textField = UITextField()
        textField.text = "Leo-31415"
        textField.keyboardType = .default
        textField.isSecureTextEntry = true
        textField.textColor = .white
        textField.attributedPlaceholder = NSAttributedString(
            string: "Repeat password",
            attributes: [NSAttributedString.Key.foregroundColor: AppColors.labelColor]
        )
        textField.addTarget(self, action: #selector(pass2Configs(textField:)),
                            for: .editingChanged
        )
        textField.addTarget(self, action: #selector(pass1Configs(textField:)),
                            for: .editingChanged
        )

        return textField
    }()

    let showPass2Button: UIButton = {
        let button = UIButton()
        button.setImage(UIImage(systemName: "eye"), for: .normal)
        button.addTarget(self, action: #selector(didTapShowPass2),
                         for: .touchUpInside
        )
        button.tintColor = .white

        return button
    }()

    let signUpButton: UIButton = {
        let button = UIButton()
        button.layer.cornerRadius = 8
        button.setTitle("Sign Up", for: .normal)
        button.backgroundColor = AppColors.desabledButtonColor

        return button
    }()

    private let presenter: PasswordPresenterProtocol
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(presenter: PasswordPresenterProtocol) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = AppColors.signViewBackground

        setUpDelegates()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        passTextField.becomeFirstResponder()

    }
    
    // MARK: - Bind
    
    public override func bind() {
        signUpButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] in
                guard let self else { return }
                self.didTapSignUp()
            }
            .store(in: &cancellables)
        
    }
    
    // MARK: - Setup
    
    public override func setupSubviews() {
        view.addSubviews([
            passwordsStackView,
            signUpButton
        ])
    }
    
    public override func setupAutolayout() {
        
        passwordsStackView.pin(edges: [.top], to: view, inset: 60, toSafeArea: true)
        passwordsStackView.pin(edges: [.leading, .trailing], to: view, inset: 60)
        signUpButton.pin(edges: [.leading, .trailing], to: view, inset: 60)
        
        checkLine1StackView.pin(edges: [.leading], to: view, inset: 60)
        checkLine2StackView.pin(edges: [.leading], to: view, inset: 60)
        checkLine3StackView.pin(edges: [.leading], to: view, inset: 60)

        passTextField.set(height: 44)
        repeatPassTextField.set(height: 44)
        signUpButton.set(height: 50)
        
        showPassButton.set(width: 40, height: 40)
        showPass2Button.set(width: 40, height: 40)
        checkButton1.set(width: 15, height: 15)
        checkButton2.set(width: 15, height: 15)
        checkButton3.set(width: 15, height: 15)

        NSLayoutConstraint.activate([
            signUpButton.topAnchor.constraint(
                equalTo: passwordsStackView.bottomAnchor, constant: 40),
        ])
        
    }
    
    // MARK: - other funcs
    
    private func createLineView() -> UIView {
        let view = UIView()
        view.backgroundColor = AppColors.textFieldBackground

        view.set(height: 1.5)

        return view
    }

    private func setUpDelegates() {
        passTextField.delegate = self
        repeatPassTextField.delegate = self
    }
    
    // MARK: Callbacks

    @objc func didTapSignUp() {
        let email = SignUpVC.emailAddress
        let name = SignUpVC.userName
        
        guard let flag = SignUpVC.country.flag,
                let country = SignUpVC.country.country
        else { return }
        
        guard let password = passTextField.text, !password.isEmpty else { return }
        KeychainWrapper.standard.set(password, forKey: "userPassword")
        
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { [weak self ] result, error in
            
            if let user = result?.user {
                let userId = user.uid
                SignInVC.userId = userId
                
                self?.createUserDocument(
                    userId: userId,
                    name: name,
                    email: email,
                    country: country,
                    flag: flag,
                    points: 1000,
                    level: 1,
                    status: "novice",
                    wins: 0,
                    losses: 0,
                    profilePictureURL: "profilePicture/Url")
            } else {
                if let error = error {
                    print("Registration error: \(error)")
                }
            }
            
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                return
            }
            
            self?.presenter.moveToStartPageScreen()
            print("You have signed up")
        })
    }
    
    func createUserDocument(
        userId: String,
        name: String,
        email: String,
        country: String,
        flag: String,
        points: Int,
        level: Int,
        status: String,
        wins: Int,
        losses: Int,
        profilePictureURL: String
    ) {
        let db = Firestore.firestore()
        let usersCollection = db.collection("users")
        let initialPoints = 1000
        
        usersCollection.document(userId).setData([
            "Name": name,
            "Email": email,
            "Country": country,
            "Flag": flag,
            "Points": initialPoints,
            "Level": level,
            "Status": status,
            "Wins": wins,
            "Losses": losses,
            "ProfilePictureURL": profilePictureURL
        ]) { error in
            if let error = error {
                print("Error creating user document: \(error)")
            } else {
                print("User document created successfully")
            }
        }
    }

    @objc func didTapShowPass() {

        showPasswordIsOn = !showPasswordIsOn

        if showPasswordIsOn {
            passTextField.isSecureTextEntry = false
            showPassButton.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            passTextField.isSecureTextEntry = true
            showPassButton.setImage(UIImage(systemName: "eye"), for: .normal)
        }

    }

    @objc func didTapShowPass2() {

        showPassword2IsOn = !showPassword2IsOn

        if showPassword2IsOn {
            repeatPassTextField.isSecureTextEntry = false
            showPass2Button.setImage(UIImage(systemName: "eye.slash"), for: .normal)
        } else {
            repeatPassTextField.isSecureTextEntry = true
            showPass2Button.setImage(UIImage(systemName: "eye"), for: .normal)
        }

    }

// Password 1 configs

    @objc func pass1Configs(textField: UITextField) {
        guard let text = passTextField.text else { return }

        var counter = 0

        // Condition 1
        if text.count >= 8 {
            checkButton1.tintColor = .green
            counter += 1
        } else {
            checkButton1.tintColor = .white
            counter -= 1
        }

        // Condition 2
        if isThereUppercase(In: text) == true {
            checkButton2.tintColor = .green
            counter += 1
        } else {
            checkButton2.tintColor = .white
            counter -= 1
        }

        // Condition 3
        if isThereNumber(In: text) == true {
            checkButton3.tintColor = .green
            counter += 1
        } else {
            checkButton3.tintColor = .white
            counter -= 1
        }

//        // Condition 4
//        if passTextField.text == repeatPassTextField.text {
//            counter += 1
//        } else {
//            counter -= 1
//        }

        if counter == 3 {
            allConfigsPass1 = true
        } else {
            allConfigsPass1 = false
        }

        signInButtonEnable()
    }

    func isThereUppercase(In text: String) -> Bool {
        var containsNumber = false

        for symbol in text {
            if symbol.isUppercase {
                containsNumber = true
            }
        }
        return containsNumber

    }

    func isThereNumber(In text: String) -> Bool {
        var containsNumber = false

        for symbol in text {
            if symbol.isNumber {
                containsNumber = true
            }
        }
        return containsNumber

    }
// password 2 configs

    @objc func pass2Configs(textField: UITextField) {
        guard let text = repeatPassTextField.text else { return }

        if text.count > 0 && text == passTextField.text {
            allConfigsPass2 = true
        } else {
            allConfigsPass2 = false
        }

        signInButtonEnable()
    }

    func signInButtonEnable() {
        if allConfigsPass1 == true && allConfigsPass2 == true {
            signUpButton.backgroundColor = AppColors.continueButtonColor
        } else {
            signUpButton.backgroundColor = AppColors.desabledButtonColor
        }
    }
  
}

extension PasswordVC: UITextFieldDelegate {

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {

        switch textField {
            case passTextField:
                repeatPassTextField.becomeFirstResponder()
            case repeatPassTextField:
                passTextField.resignFirstResponder()
                repeatPassTextField.resignFirstResponder()
                didTapSignUp()
            default:
                print("mrint")
        }

        return true
    }

}


