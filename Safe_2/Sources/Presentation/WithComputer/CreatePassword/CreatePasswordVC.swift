//
//  CreatePasswordVC.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 01.08.23.
//

import UIKit
import Combine

final class CreatePasswordVC: BaseVC {
    
    // MARK: - Properties
    
    var arrayOfNumberIndexes = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var numberIndex: Int = 0
    var passwordLength = 0
    var arrayOfButtons: [UIButton] = []
    static var newPassword: String = "0000"
    
    // MARK: - Subviews
    
    let helpLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.backgroundColor = .white
        v.text = "Create password \nfor your safe"
        //        v.textColor = .black
        v.textAlignment = .center
        v.font = .systemFont(ofSize: 29, weight: .heavy)
        
        return v
    }()
    
    let passwordTextField: UITextField = {
        let v = UITextField()
        v.backgroundColor = .white
        v.placeholder = "0123"
        v.textAlignment = .center
        v.font = .systemFont(ofSize: 14)
        v.layer.borderColor = UIColor.black.cgColor
        v.layer.borderWidth = 1
        v.layer.cornerRadius = 14
        v.isUserInteractionEnabled = false
        
        return v
    }()
    
    let errorLabel: UILabel = {
        let v = UILabel()
        v.text = " "
        v.textAlignment = .center
        v.textColor = .red
        v.backgroundColor = .white
        v.font = .systemFont(ofSize: 12)
        
        return v
    }()
    
    lazy var numbers1StackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            number1Button,
            number2Button,
            number3Button,
        ])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 20
        
        return stack
    }()
    
    var number1Button: PasswordNumberButton = {
        let v = PasswordNumberButton()
        v.makeImageLarger(systemName: "1.circle", button: v)
        v.tag = 1
        v.addTarget(self, action: #selector(numberButtonsPressed),
                         for: .touchUpInside)
        return v
    }()
    
    var number2Button: PasswordNumberButton = {
        let v = PasswordNumberButton()
        v.makeImageLarger(systemName: "2.circle", button: v)
        v.tag = 2
        v.addTarget(self, action: #selector(numberButtonsPressed),
                         for: .touchUpInside)
        return v
    }()
    
    var number3Button: PasswordNumberButton = {
        let v = PasswordNumberButton()
        v.makeImageLarger(systemName: "3.circle", button: v)
        v.tag = 3
        v.addTarget(self, action: #selector(numberButtonsPressed),
                         for: .touchUpInside)
        return v
    }()
    
    lazy var numbers2StackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            number4Button,
            number5Button,
            number6Button
        ])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 20
        
        return stack
    }()
    
    var number4Button: PasswordNumberButton = {
        let v = PasswordNumberButton()
        v.makeImageLarger(systemName: "4.circle", button: v)
        v.tag = 4
        v.addTarget(self, action: #selector(numberButtonsPressed),
                         for: .touchUpInside)
        return v
    }()
    
    var number5Button: PasswordNumberButton = {
        let v = PasswordNumberButton()
        v.makeImageLarger(systemName: "5.circle", button: v)
        v.tag = 5
        v.addTarget(self, action: #selector(numberButtonsPressed),
                         for: .touchUpInside)
        return v
    }()
    
    var number6Button: PasswordNumberButton = {
        let v = PasswordNumberButton()
        v.makeImageLarger(systemName: "6.circle", button: v)
        v.tag = 6
        v.addTarget(self, action: #selector(numberButtonsPressed),
                         for: .touchUpInside)
        return v
    }()
    
    lazy var numbers3StackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            number7Button,
            number8Button,
            number9Button,
        ])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 20
        
        return stack
    }()
    
    var number7Button: PasswordNumberButton = {
        let v = PasswordNumberButton()
        v.makeImageLarger(systemName: "7.circle", button: v)
        v.tag = 7
        v.addTarget(self, action: #selector(numberButtonsPressed),
                         for: .touchUpInside)
        return v
    }()
    
    var number8Button: PasswordNumberButton = {
        let v = PasswordNumberButton()
        v.makeImageLarger(systemName: "8.circle", button: v)
        v.tag = 8
        v.addTarget(self, action: #selector(numberButtonsPressed),
                         for: .touchUpInside)
        return v
    }()
    
    var number9Button: PasswordNumberButton = {
        let v = PasswordNumberButton()
        v.makeImageLarger(systemName: "9.circle", button: v)
        v.tag = 9
        v.addTarget(self, action: #selector(numberButtonsPressed),
                         for: .touchUpInside)
        return v
    }()
    
    lazy var numbers4StackView: UIStackView = {
        let stack = UIStackView(arrangedSubviews: [
            resetButton,
            number0Button,
            doneButton
        ])
        stack.axis = .horizontal
        stack.alignment = .fill
        stack.distribution = .fillEqually
        stack.spacing = 20
        
        return stack
    }()
    
    let resetButton: UIButton = {
        let v = UIButton()
        v.setTitle("Reset", for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 10)
        v.backgroundColor = .systemGray
        v.layer.cornerRadius = 16
        v.addTarget(self, action: #selector(resetButtonPressed),
                         for: .touchUpInside)
        return v
    }()
    
    var number0Button: PasswordNumberButton = {
        let v = PasswordNumberButton()
        v.makeImageLarger(systemName: "0.circle", button: v)
        v.tag = 0
        v.addTarget(self, action: #selector(numberButtonsPressed),
                         for: .touchUpInside)
        return v
    }()
    
    let doneButton: UIButton = {
        let v = UIButton()
        v.setTitle("Done", for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 10)
        v.backgroundColor = .systemGray
        v.layer.cornerRadius = 16
        
        return v
    }()
    
    private let presenter: CreatePasswordPresenterProtocol
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(presenter: CreatePasswordPresenterProtocol) {
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
        
        view.backgroundColor = .white
        
        makeButtonsArray()
        setupSubviews()
        
        let largeConfig = UIImage.SymbolConfiguration(
            pointSize: 140, weight: .bold, scale: .large)
        let largeNumber = UIImage(
            systemName: "1.circle", withConfiguration: largeConfig)
        
        number1Button.setImage(largeNumber, for: .normal)
        
        bind()
    }
    
    // MARK: - Bind
    
    public override func bind() {        
        doneButton
            .publisher(for: .touchUpInside)
            .sink{ [weak self] _ in
                guard let self else { return }
                self.doneButtonPressed()
            }
            .store(in: &cancellables)
        
    }
    
    // MARK: - Setup
    
    public override func setupSubviews() {
        view.addSubviews([
            helpLabel,
            passwordTextField,
            errorLabel,
            numbers1StackView,
            numbers2StackView,
            numbers3StackView,
            numbers4StackView
        ])
    }
    
    public override func setupAutolayout() {
        
        helpLabel.pin(edges: [.top], to: view, inset: 20, toSafeArea: true)
        helpLabel.pin(edges: [.leading, .trailing], to: view, inset: 30)
        helpLabel.pin(edges: [.leading, .trailing], to: view, inset: 30)
        passwordTextField.pin(edges: [.leading, .trailing], to: view, inset: 150)
        errorLabel.pin(edges: [.leading, .trailing], to: view, inset: 30)
        numbers1StackView.pin(edges: [.leading, .trailing], to: view, inset: 30)
        numbers2StackView.pin(edges: [.leading, .trailing], to: view, inset: 30)
        numbers3StackView.pin(edges: [.leading, .trailing], to: view, inset: 30)
        numbers4StackView.pin(edges: [.leading, .trailing], to: view, inset: 30)
        
        helpLabel.set(height: 100)
        passwordTextField.set(width: 100, height: 35)
        errorLabel.set(height: 20)
        number1Button.set(height: 55)
        number4Button.set(height: 55)
        number7Button.set(height: 55)
        resetButton.set(height: 55)
        errorLabel.set(height: 20)
        
        NSLayoutConstraint.activate([
            passwordTextField.topAnchor.constraint(
                equalTo: helpLabel.bottomAnchor, constant: 10),
            errorLabel.topAnchor.constraint(
                equalTo: passwordTextField.bottomAnchor, constant: 10),
            numbers1StackView.topAnchor.constraint(
                equalTo: errorLabel.bottomAnchor, constant: 10),
            numbers2StackView.topAnchor.constraint(
                equalTo: numbers1StackView.bottomAnchor, constant: 10),
            numbers3StackView.topAnchor.constraint(
                equalTo: numbers2StackView.bottomAnchor, constant: 10),
            numbers4StackView.topAnchor.constraint(
                equalTo: numbers3StackView.bottomAnchor, constant: 10),
        ])
        
    }
    
    // MARK: - other funcs
    
    func makeButtonsArray() {
        arrayOfButtons = [number0Button, number1Button, number2Button, number3Button, number4Button, number5Button, number6Button, number7Button,number8Button, number9Button
        ]
    }
    
    func disableNumberButtons() {
        arrayOfButtons.forEach { button in
            button.isUserInteractionEnabled = false
        }
    }
    
    func updatePassword(newNumber: String) {
        var password = passwordTextField.text ?? ""
        if password.count < 3 {
            password = password + newNumber
        } else if password.count == 3 {
            password = password + newNumber
            CreatePasswordVC.newPassword = password
        }
        passwordTextField.text = password
    }
    
    func uncoloringButtons() {
        for buttons in arrayOfButtons {
            buttons.tintColor = AppColors.passwordNumberButtonColor
        }
    }
    
    func makeUserInteractionOn() {
        for buttons in arrayOfButtons {
            buttons.isUserInteractionEnabled = true
        }
    }
    
    // MARK: - Callbacks
    
    @objc func numberButtonsPressed(_ sender: UIButton) {
        numberIndex = sender.tag
        updatePassword(newNumber: String(numberIndex))
        passwordLength += 1
        
        if passwordLength <= 4 {
            sender.isUserInteractionEnabled = false
            sender.tintColor = .systemGray4
            sender.flash()
        } else {
            disableNumberButtons()
        }
    }
    
    @objc func resetButtonPressed() {
        passwordTextField.text = ""
        uncoloringButtons()
        passwordLength = 0
        makeUserInteractionOn()
    }
    
    @objc func doneButtonPressed() {
        let length = passwordTextField.text?.count ?? 0
        if passwordLength < 4 {
            errorLabel.text = "Password must have 4 symbols"
        } else {
            errorLabel.text = " "
            self.presenter.moveToWithComputerScreen()
        }
    }
}
