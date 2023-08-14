//
//  SignInVC.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 07.08.23.
//

import UIKit
import Combine
import FirebaseAuth

final class SignInVC: BaseVC {
    
    // MARK: - Properties
    
    let SCItems = ["Phone number", "Email"]
    static var userId = ""
    
    // MARK: - Subviews
    
    lazy var signInTypesSegmentedControl: UISegmentedControl = {
        let v = UISegmentedControl(items: SCItems )
        v.selectedSegmentIndex = 0
        v.layer.masksToBounds = true
        v.tintColor = AppColors.signViewBackground
        v.layer.borderColor = AppColors.signViewBackground.cgColor
        v.backgroundColor = AppColors.signViewBackground
        v.selectedSegmentTintColor = AppColors.signViewBackground

        let font = UIFont.systemFont(ofSize: 40)
        let segmentFont = [NSAttributedString.Key.font: font]
        v.setTitleTextAttributes(segmentFont, for: .selected)

        let selectedSegment = [NSAttributedString.Key.foregroundColor: AppColors.selectedText]
        v.setTitleTextAttributes(selectedSegment, for:.selected)

        let deselectedSegment = [NSAttributedString.Key.foregroundColor: AppColors.deselectedText]
        v.setTitleTextAttributes(deselectedSegment, for:.normal)

        v.addTarget(self,
                          action: #selector(didChangeSelectedSegment(_ :)),
                          for: .valueChanged)

        return v
    }()

    lazy var linesStackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [
            leftLineView,
            rightLineView
        ])
        v.axis = .horizontal
        v.distribution = .fillEqually
        v.alignment = .fill
        v.spacing = 5

        return v
    }()

    let leftLineView: UIView = {
        let view = UIView()
        view.backgroundColor = .white

        return view
    }()

    let rightLineView: UIView = {
        let view = UIView()
        view.backgroundColor = AppColors.signViewBackground

        return view
    }()

    // Login stack View

    lazy var loginStackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [
            emailOrPhoneStackView,
            passwordStackView
        ])
        v.axis = .vertical
        v.distribution = .fill
        v.alignment = .fill
        v.spacing = 26

        return v
    }()

    lazy var emailOrPhoneStackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [
            emailOrPhoneTextField,
            createLineView()
        ])
        v.axis = .vertical
        v.distribution = .fill
        v.alignment = .fill
        
        return v
    }()

    let emailOrPhoneTextField: UITextField = {
        let v = UITextField()
        v.text = "Leo-1995@mail.ru"
        v.keyboardType = .emailAddress
        v.textColor = .white
        v.attributedPlaceholder = NSAttributedString(
            string: "Phone Number",
            attributes: [NSAttributedString.Key.foregroundColor: AppColors.labelColor]
        )

        return v
    }()

    lazy var passwordStackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [
            passwordTextField,
            createLineView()
        ])
        v.axis = .vertical
        v.distribution = .fill
        v.alignment = .fill

        return v
    }()

    let passwordTextField: UITextField = {
        let v = UITextField()
        v.isSecureTextEntry = true
        v.text = "Leo-31415"
        v.textColor = .white
        v.attributedPlaceholder = NSAttributedString(
            string: "Password",
            attributes: [NSAttributedString.Key.foregroundColor: AppColors.labelColor]
        )

        return v
    }()

    let forgotPasswordButton: UIButton = {
        let v = UIButton()
        v.setTitle("Forgot password?", for: .normal)
        v.setTitleColor(AppColors.labelColor, for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 16)
        v.titleLabel?.textAlignment = .right
        v.backgroundColor = AppColors.signViewBackground
        v.addTarget(
            self, action: #selector(didTapForgotButton),
            for: .touchUpInside
        )

        return v
    }()

    lazy var buttonStackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [
            logInButton,
            signUpVerticalStackView
        ])
        v.axis = .vertical
        v.distribution = .fill
        v.alignment = .fill
        v.spacing = 10

        return v
    }()

    let logInButton: UIButton = {
        let v = UIButton()
        v.layer.cornerRadius = 8
        v.setTitle("Log In", for: .normal)
        v.backgroundColor = AppColors.continueButtonColor

        return v
    }()

    lazy var signUpVerticalStackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [
            signUpStackView
        ])
        v.axis = .vertical
        v.distribution = .fill
        v.alignment = .center

        return v
    }()

    lazy var signUpStackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [
            signUpLabel,
            signUpButton
        ])
        v.axis = .horizontal
        v.distribution = .fill
        v.alignment = .center
        v.spacing = 4

        return v
    }()

    let signUpLabel: UILabel = {
        let v = UILabel()
        v.text = "Don't have an account?"
        v.textColor = .white
        v.font = .systemFont(ofSize: 16)

        return v
    }()
    
    let errorLabel: UILabel = {
        let v = UILabel()
        v.text = "Invalid Email or Password"
        v.textAlignment = .center
        v.textColor = AppColors.signViewBackground
        v.font = .systemFont(ofSize: 12)

        return v
    }()

    let signUpButton: UIButton = {
        let v = UIButton()
        v.setTitle("Sign Up", for: .normal)
        v.setTitleColor(AppColors.signButtonColor, for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 16)

        return v
    }()

    private let presenter: SignInPresenterProtocol
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(presenter: SignInPresenterProtocol) {
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

        setupSubviews()
        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        emailOrPhoneTextField.becomeFirstResponder()

    }
    
    // MARK: - Bind
    
    public override func bind() {
        logInButton
            .publisher(for: .touchUpInside)
            .sink{ [weak self] _ in
                guard let self else { return }
                self.didTapLogIn()
            }
            .store(in: &cancellables)
        
        signUpButton
            .publisher(for: .touchUpInside)
            .sink{ [weak self] _ in
                guard let self else { return }
                self.presenter.moveToSignUpScreen()
            }
            .store(in: &cancellables)
    
        setupTitle()
    }
    
    // MARK: - Setup
    
    public override func setupSubviews() {
        view.addSubviews([
            signInTypesSegmentedControl,
            linesStackView,
            loginStackView,
            forgotPasswordButton,
            errorLabel,
            buttonStackView
        ])
    }
    
    public override func setupAutolayout() {
        
        signInTypesSegmentedControl.pin(edges: [.top], to: view, inset: 20, toSafeArea: true)
        signInTypesSegmentedControl.pin(edges: [.leading, .trailing], to: view, inset: 15)
        linesStackView.pin(edges: [.leading, .trailing], to: view, inset: 15)
        loginStackView.pin(edges: [.leading, .trailing], to: view, inset: 60)
        buttonStackView.pin(edges: [.leading, .trailing], to: view, inset: 30)
        errorLabel.pin(edges: [.leading, .trailing], to: view, inset: 30)
        forgotPasswordButton.pin(edges: [.trailing], to: view, inset: 60)

        logInButton.pin(edges: [.leading, .trailing], to: view, inset: 60)

        signInTypesSegmentedControl.set(height: 40)
        linesStackView.set(height: 3)
        leftLineView.set(height: 1.5)
        rightLineView.set(height: 1.5)
        emailOrPhoneTextField.set(height: 44)
        passwordTextField.set(height: 44)
        errorLabel.set(height: 20)
        logInButton.set(height: 50)

        NSLayoutConstraint.activate([
            linesStackView.topAnchor.constraint(
                equalTo: signInTypesSegmentedControl.bottomAnchor, constant: 5),
            loginStackView.topAnchor.constraint(
                equalTo: linesStackView.bottomAnchor, constant: 100),
            buttonStackView.topAnchor.constraint(
                equalTo: loginStackView.bottomAnchor, constant: 30),
            forgotPasswordButton.topAnchor.constraint(
                equalTo: passwordStackView.bottomAnchor, constant: 15),
            errorLabel.topAnchor.constraint(
                equalTo: forgotPasswordButton.bottomAnchor, constant: 40),
            logInButton.topAnchor.constraint(
                equalTo: errorLabel.bottomAnchor, constant: 5),
        ])
        
    }
    
    private func setupTitle() {
        title = "Sign In"
        let textAttributes = [NSAttributedString.Key.foregroundColor: AppColors.labelColor]
        navigationController?.navigationBar.titleTextAttributes = textAttributes
    }
    
   
    // MARK: - other funcs
    
    private func createLineView() -> UIView {
        let view = UIView()
        view.backgroundColor = AppColors.textFieldBackground
        view.set(height: 1.5)

        return view
    }
    
    // MARK: Callbacks

    @objc func didTapForgotButton() {
        //Gloxd moranayir
    }

    @objc func didTapLogIn() {
        guard let email = emailOrPhoneTextField.text, !email.isEmpty,
              let password = passwordTextField.text, !password.isEmpty else {
            print("Missing Field Data")
            return
        }
        
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password,
                                        completion: { [weak self ] result, error in
            
            if let user = result?.user {
                // User signed in successfully, get the user's unique ID
                let userId = user.uid
                
                print("Sign-in with userId: \(userId)")
                SignInVC.userId = userId
            } else {
                // Handle sign-in failure
                if let error = error {
                    print("Sign-in error: \(error)")
                }
            }
            
            guard let strongSelf = self else {
                return
            }
            
            guard error == nil else {
                strongSelf.errorLabel.textColor = .red
                return
            }
            
            strongSelf.errorLabel.textColor = AppColors.signViewBackground
            strongSelf.presenter.moveToStartPageScreen()
        })
    }

    @objc func didTapSignUp() {
        dismiss(animated: false)
    }


    @objc func didChangeSelectedSegment(_ sender: UISegmentedControl) {

        switch sender.selectedSegmentIndex {
            case 0:
                leftLineView.backgroundColor = .white
                rightLineView.backgroundColor = AppColors.signViewBackground
                emailOrPhoneTextField.placeholder = "Phone Number"
//                emailOrPhoneTextField.keyboardType = .numberPad

            case 1:
                leftLineView.backgroundColor = AppColors.signViewBackground
                rightLineView.backgroundColor = .white
                emailOrPhoneTextField.placeholder = "Email Address"
//                emailOrPhoneTextField.keyboardType = .emailAddress

            default:
                print("Mrint")
        }

    }
    
}
