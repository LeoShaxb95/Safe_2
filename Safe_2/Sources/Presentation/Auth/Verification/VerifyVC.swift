//
//  VerifyVC.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 07.08.23.
//

import UIKit
import Combine

final class VerifyVC: BaseVC {
    
    // MARK: - Properties
    
    var realSmsCode = "1234"
    var inputedSmsCode = ""
    let CodeFieldsWidthHeight = 46
    var fillTextFieldsCounter = 0
    var activeTextField = UITextField()
    var timer = Timer()
    var minutes: Int = 0
    var seconds: Int = 0
    var time = 10 {
        didSet {
            timeLabel.text = "\(time)"
        }
    }
    
    // MARK: - Subviews
    
    // Message stack View

    lazy var messageStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            timeLabel,
            messageLabel,
        ])
        stackView.axis = .vertical
        stackView.distribution = .fill
        stackView.alignment = .fill
        stackView.spacing = 10

        return stackView
    }()

    let timeLabel: UILabel = {
        let v = UILabel()
        v.text = "00:59"
        v.textAlignment = .center
        v.font = .systemFont(ofSize: 40, weight: .regular)
        v.textColor = .white
        v.backgroundColor = AppColors.signViewBackground
        return v
    }()

    let messageLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 2
        v.textAlignment = .center
        v.text = "We sent the verification code\nto +374-55-22-80-50"
        v.font = .systemFont(ofSize: 16, weight: .regular)
        v.textColor = AppColors.labelColor
        v.backgroundColor = AppColors.signViewBackground

        return v
    }()

    let sendAgainButton: UIButton = {
        let v = UIButton()
        v.setTitle("Send Again", for: .normal)
        v.setTitleColor(AppColors.desabledButtonColor, for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 16)
        v.isUserInteractionEnabled = false
        v.addTarget(
            self, action: #selector(didTapSendAgain),
            for: .touchUpInside
        )

        return v
    }()

    // VerifyCode Stack View

    lazy var VerifyCodeStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.alignment = .center
        stackView.distribution = .fillEqually
        stackView.spacing = 15
        [
            configureTextField(textField: code1TextField),
            configureTextField(textField: code2TextField),
            configureTextField(textField: code3TextField),
            configureTextField(textField: code4TextField),
        ].forEach { stackView.addArrangedSubview($0) }

        return stackView
    }()

    let code1TextField = UITextField()
    let code2TextField = UITextField()
    let code3TextField = UITextField()
    let code4TextField = UITextField()

    // error Message

    let incorrectCodeMessageLabel: UILabel = {
        let v = UILabel()
        v.text = "Code is incorrect"
        v.textColor = AppColors.signViewBackground
        v.font = .systemFont(ofSize: 12, weight: .regular)

        return v
    }()

    // Submit button

    let submitButton: UIButton = {
        let v = UIButton()
        v.setTitle("Submit", for: .normal)
        v.setTitleColor(AppColors.labelColor, for: .normal)
        v.backgroundColor = AppColors.desabledButtonColor
        v.titleLabel?.font = .systemFont(ofSize: 16)
        v.layer.cornerRadius = 8

        return v
    }()

    private let presenter: VerifyPresenterProtocol
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(presenter: VerifyPresenterProtocol) {
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
        navigationItem.hidesBackButton = true

        bind()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        code1TextField.becomeFirstResponder()

    }

    
    // MARK: - Bind
    
    public override func bind() {
        submitButton
            .publisher(for: .touchUpInside)
            .sink{ [weak self] _ in
                guard let self else { return }
                self.didTapSubmit()
            }
            .store(in: &cancellables)
        
        setUpDelegates()
        timerGetStarted()
        timeConfigs()
    }
    
    // MARK: - Setup
    
    public override func setupSubviews() {
        view.addSubviews([
            messageStackView,
            sendAgainButton,
            VerifyCodeStackView,
            incorrectCodeMessageLabel,
            submitButton
        ])
    }
    
    public override func setupAutolayout() {
        
        messageStackView.pin(edges: [.top], to: view, inset: 40, toSafeArea: true)
        messageStackView.pin(edges: [.leading, .trailing], to: view, inset: 40)
        sendAgainButton.pin(edges: [.leading, .trailing], to: view, inset: 40)
        VerifyCodeStackView.pin(edges: [.leading, .trailing], to: view, inset: 80)
        submitButton.pin(edges: [.leading, .trailing], to: view, inset: 40)

        timeLabel.set(height: 40)
        submitButton.set(height: 46)

        NSLayoutConstraint.activate([
            sendAgainButton.topAnchor.constraint(
                equalTo: messageStackView.bottomAnchor, constant: 5),
            VerifyCodeStackView.topAnchor.constraint(
                equalTo: sendAgainButton.bottomAnchor, constant: 40),
            incorrectCodeMessageLabel.topAnchor.constraint(
                equalTo: VerifyCodeStackView.bottomAnchor, constant: 5),
            incorrectCodeMessageLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            submitButton.topAnchor.constraint(
                equalTo: incorrectCodeMessageLabel.bottomAnchor, constant: 30),
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
        code1TextField.delegate = self
        code2TextField.delegate = self
        code3TextField.delegate = self
        code4TextField.delegate = self
    }

    // Timer

    func timerGetStarted() {
        timer = Timer.scheduledTimer(timeInterval: 1,
                                     target: self, selector: #selector(timerik),
                                     userInfo: nil, repeats: true)
    }

    @objc private func timerik() {
        time -= 1
        timeLabel.text = self.timeString(time: time)
        if time == 0 {
            timer.invalidate()
            sendAgainButton.isUserInteractionEnabled = true
            sendAgainButton.setTitleColor(AppColors.signButtonColor, for: .normal)
            timeLabel.isHidden = true
        }
    }

    func timeString(time: Int) -> String {
        minutes = Int(time) / 60 % 60
        seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }


    func timeConfigs() {
        timeLabel.text = self.timeString(time: time)
    }

    
    // MARK: Callbacks

    @objc func didTapSendAgain() {
        let textFields = [code1TextField, code2TextField, code3TextField, code4TextField]

        for tf in textFields {
            tf.text = ""
            empty(textField: tf)
        }
        code1TextField.becomeFirstResponder()
        fillTextFieldsCounter = 0
        sendAgainButton.isUserInteractionEnabled = false
        sendAgainButton.setTitleColor(AppColors.desabledButtonColor, for: .normal)
        timeLabel.isHidden = false
        time = 10
        timerGetStarted()
        timerik()
    }

    @objc func didTapSubmit() {
        inputedSmsCode = String(code1TextField.text ?? "")  + String(code2TextField.text ?? "") + String(code3TextField.text ?? "") + String(code4TextField.text ?? "")
        if inputedSmsCode == realSmsCode {
            incorrectCodeMessageLabel.textColor = AppColors.signViewBackground
            self.presenter.moveToPasswordScreen()
        } else {
            incorrectCodeMessageLabel.textColor = .white
        }
    }

    // TextFields Configs

    @objc private func textFieldCharLimit(_ textField: UITextField) {
        guard let text = textField.text else { return }

        if let selectedRange = textField.selectedTextRange {
            let cursorPosition = textField.offset(from: textField.beginningOfDocument,
                                                  to: selectedRange.start
            )

            switch cursorPosition {
                case 1:
                    let newText = String(text.prefix(1))
                    if text.count <= 1 {
                        textField.text = text
                    } else {
                        textField.text = newText
                    }
                case 2:
                    let newText = String(text.suffix(1))
                    if text.count <= 1 {
                        textField.text = text
                    } else {
                        textField.text = newText
                    }
                default:
                    print("mrint")
            }
        }
    }

    @objc
    func changeTextField(textField: UITextField) {
        guard let text = textField.text else { return }
        guard let text1 = code1TextField.text else { return }
        guard let text2 = code2TextField.text else { return }
        guard let text3 = code3TextField.text else { return }
        guard let text4 = code4TextField.text else { return }
        let textFields = [code1TextField, code2TextField, code3TextField, code4TextField]

        if text.utf8.count == 1 {
            fillTextFieldsCounter += 1
            switch textField {
                case code1TextField:
                    if text2.isEmpty {
                        code2TextField.becomeFirstResponder()
                    } else if text3.isEmpty {
                        code3TextField.becomeFirstResponder()
                    } else if text4.isEmpty {
                        code4TextField.becomeFirstResponder()
                    }
                case code2TextField:
                    if text3.isEmpty {
                        code3TextField.becomeFirstResponder()
                    } else if text4.isEmpty {
                        code4TextField.becomeFirstResponder()
                    } else if text1.isEmpty {
                        code1TextField.becomeFirstResponder()
                    }
                case code3TextField:
                    if text4.isEmpty {
                        code4TextField.becomeFirstResponder()
                    } else if text1.isEmpty {
                        code1TextField.becomeFirstResponder()
                    } else if text2.isEmpty {
                        code2TextField.becomeFirstResponder()
                    }
                case code4TextField:
                    if text1.isEmpty {
                        code1TextField.becomeFirstResponder()
                    } else if text2.isEmpty {
                        code2TextField.becomeFirstResponder()
                    } else if text3.isEmpty {
                        code3TextField.becomeFirstResponder()
                    }
                default:
                    break
            }
        } else if text.isEmpty {
            fillTextFieldsCounter -= 1
            switch textField {
                case code4TextField:
                    if !text3.isEmpty {
                        code3TextField.becomeFirstResponder()
                    } else if !text2.isEmpty {
                        code2TextField.becomeFirstResponder()
                    } else if !text1.isEmpty {
                        code1TextField.becomeFirstResponder()
                    } else {
                        code1TextField.becomeFirstResponder()
                    }
                case code3TextField:
                    if !text2.isEmpty {
                        code2TextField.becomeFirstResponder()
                    } else if !text1.isEmpty {
                        code1TextField.becomeFirstResponder()
                    } else if !text4.isEmpty {
                        code4TextField.becomeFirstResponder()
                    } else {
                        code1TextField.becomeFirstResponder()
                    }
                case code2TextField:
                    if !text1.isEmpty {
                        code1TextField.becomeFirstResponder()
                    } else if !text4.isEmpty {
                        code4TextField.becomeFirstResponder()
                    } else if !text3.isEmpty {
                        code3TextField.becomeFirstResponder()
                    } else {
                        code1TextField.becomeFirstResponder()
                    }
                case code1TextField:
                    if !text4.isEmpty {
                        code4TextField.becomeFirstResponder()
                    } else if !text3.isEmpty {
                        code3TextField.becomeFirstResponder()
                    } else if !text2.isEmpty {
                        code2TextField.becomeFirstResponder()
                    } else {
                        code1TextField.becomeFirstResponder()
                    }
                default:
                    break
            }
        }

        if !text.isEmpty {
            fill(textField: textField)
        } else {
            empty(textField: textField)
        }
        switch fillTextFieldsCounter {
            case 4:
                submitButton.isEnabled = true
                submitButton.backgroundColor = AppColors.continueButtonColor
                submitButton.setTitleColor(.white, for: .normal)
            default:
                submitButton.isEnabled = false
                submitButton.backgroundColor = AppColors.desabledButtonColor
                submitButton.setTitleColor(AppColors.labelColor, for: .normal)
        }

    }

    func fill(textField: UITextField) {
        textField.backgroundColor = AppColors.codeFillBackgroundColor
        textField.layer.borderColor = AppColors.codeTextFieldBorderColor.cgColor
    }

    func empty(textField: UITextField) {
        textField.backgroundColor = AppColors.codeEmptyBackgroundColor
        textField.layer.borderColor = AppColors.signViewBackground.cgColor
    }

    private func configureTextField(textField: UITextField) -> UITextField {

        textField.keyboardType = .phonePad
        textField.textColor = .white
        textField.textAlignment = .center
        textField.backgroundColor = AppColors.verifyCodeColor
        textField.layer.cornerRadius = 8
        textField.layer.borderWidth = 1.5
        textField.layer.borderColor = AppColors.signViewBackground.cgColor
        textField.addTarget(
            self, action: #selector(changeTextField(textField:)),
            for: .editingChanged
        )
        textField.addTarget(self, action: #selector(textFieldCharLimit),
                            for: .editingChanged
        )

        textField.set(
            width: CGFloat(CodeFieldsWidthHeight),
            height: CGFloat(CodeFieldsWidthHeight)
        )

        return textField
    }
  
}

extension VerifyVC: UITextFieldDelegate {

    func textField(_ textField: UITextField,
                   shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {

        let aSet = NSCharacterSet(charactersIn:"0123456789").inverted
        let compSepByCharInSet = string.components(separatedBy: aSet)
        let numberFiltered = compSepByCharInSet.joined(separator: "")
        return string == numberFiltered
    }

}
