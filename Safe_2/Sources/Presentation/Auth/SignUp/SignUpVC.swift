//
//  SignUpVC.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 07.08.23.
//

import UIKit
import Combine

final class SignUpVC: BaseVC {
    
    // MARK: - Properties
    
    let SCItems = ["Phone number", "Email"]
    static var emailAddress: String = ""
    static var userName: String = ""

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

        v.addTarget(self, action: #selector(didChangeSelectedSegment(_ :)),
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
        v.keyboardType = .emailAddress
        v.textColor = .white
        v.attributedPlaceholder = NSAttributedString(
            string: "Phone Number",
            attributes: [NSAttributedString.Key.foregroundColor: AppColors.labelColor]
        )

        return v
    }()
    
    lazy var userNameStackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [
            userNameTextField,
            createLineView()
        ])
        v.axis = .vertical
        v.distribution = .fill
        v.alignment = .fill
        
        return v
    }()

    let userNameTextField: UITextField = {
        let v = UITextField()
        v.keyboardType = .emailAddress
        v.textColor = .white
        v.attributedPlaceholder = NSAttributedString(
            string: "Username",
            attributes: [NSAttributedString.Key.foregroundColor: AppColors.labelColor]
        )

        return v
    }()

    let continueButton: UIButton = {
        let v = UIButton()
        v.layer.cornerRadius = 8
        v.setTitle("Continue", for: .normal)
        v.backgroundColor = AppColors.continueButtonColor
        
        return v
    }()

    lazy var signInStackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [
            signInLabel,
            signInButton
        ])
        v.axis = .horizontal
        v.distribution = .fill
        v.alignment = .center
        v.spacing = 4

        return v
    }()

    let signInLabel: UILabel = {
        let v = UILabel()
        v.text = "Already have an account?"
        v.textColor = .white
        v.font = .systemFont(ofSize: 16)

        return v
    }()

    let signInButton: UIButton = {
        let v = UIButton()
        v.isUserInteractionEnabled = true
        v.setTitle("Sign In", for: .normal)
        v.setTitleColor(AppColors.signButtonColor, for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 16)

        return v
    }()
    
    private let presenter: SignUpPresenterProtocol
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(presenter: SignUpPresenterProtocol) {
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
        continueButton
            .publisher(for: .touchUpInside)
            .sink{ [weak self] _ in
                guard let self,
                      let email = emailOrPhoneTextField.text, !email.isEmpty,
                        let userName = userNameTextField.text, !userName.isEmpty
                else { return }
                
                SignUpVC.emailAddress = email
                SignUpVC.userName = userName
                
                self.presenter.moveToPassword()
            }
            .store(in: &cancellables)
        
        signInButton
            .publisher(for: .touchUpInside)
            .sink{ [weak self] _ in
                guard let self else { return }
                self.dismiss(animated: false)
            }
            .store(in: &cancellables)
    
        setupTitle()
    }
    
    // MARK: - Setup
    
    public override func setupSubviews() {
        view.addSubviews([
            signInTypesSegmentedControl,
            linesStackView,
            emailOrPhoneStackView,
            userNameStackView,
            continueButton,
            signInStackView
        ])
    }
    
    public override func setupAutolayout() {
        
        signInTypesSegmentedControl.pin(edges: [.top], to: view, inset: 20, toSafeArea: true)
        signInTypesSegmentedControl.pin(edges: [.leading, .trailing], to: view, inset: 15)
        linesStackView.pin(edges: [.leading, .trailing], to: view, inset: 15)
        emailOrPhoneTextField.pin(edges: [.leading, .trailing], to: view, inset: 60)
        userNameStackView.pin(edges: [.leading, .trailing], to: view, inset: 60)
        continueButton.pin(edges: [.leading, .trailing], to: view, inset: 60)
        signInStackView.pin(edges: [.leading, .trailing], to: view, inset: 75)

        signInTypesSegmentedControl.set(height: 40)
        linesStackView.set(height: 3)
        leftLineView.set(height: 1.5)
        rightLineView.set(height: 1.5)
        continueButton.set(height: 50)
        emailOrPhoneTextField.set(height: 44)
        userNameTextField.set(height: 44)

        NSLayoutConstraint.activate([
            linesStackView.topAnchor.constraint(
                equalTo: signInTypesSegmentedControl.bottomAnchor, constant: 5),
            emailOrPhoneStackView.topAnchor.constraint(
                equalTo: linesStackView.bottomAnchor, constant: 100),
            userNameStackView.topAnchor.constraint(
                equalTo: emailOrPhoneStackView.bottomAnchor, constant: 20),
            continueButton.topAnchor.constraint(
                equalTo: userNameStackView.bottomAnchor, constant: 60),
            signInStackView.topAnchor.constraint(
                equalTo: continueButton.bottomAnchor, constant: 10),
        ])
        
    }
    
    private func setupTitle() {
        title = "Sign Up"
        navigationItem.hidesBackButton = true
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

    @objc func didChangeSelectedSegment(_ sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
            case 0:
                leftLineView.backgroundColor = .white
                rightLineView.backgroundColor = AppColors.signViewBackground
                emailOrPhoneTextField.placeholder = "Phone Number"
             //   emailOrPhoneTextField.keyboardType = .numberPad
            case 1:
                leftLineView.backgroundColor = AppColors.signViewBackground
                rightLineView.backgroundColor = .white
                emailOrPhoneTextField.placeholder = "Email Address"
             //   emailOrPhoneTextField.keyboardType = .emailAddress
            default:
               break
        }
    }
  
}
