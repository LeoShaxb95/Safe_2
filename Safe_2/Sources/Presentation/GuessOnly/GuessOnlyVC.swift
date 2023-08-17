//
//  GuessOnlyVC.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 30.07.23.
//

import UIKit
import Combine
import Firebase

final class GuessOnlyVC: BaseVC {
    
    // MARK: - Properties
    
    var gameConfigs = GameConfigs()
    var difficulty: GameConfigs.Difficulty?
    
    var gameIsOver = false
    
    let loopingMargin: Int = 20
    var minutes: Int = 0
    var seconds: Int = 0
    var answersCounter: Int = 0
    var numberIndex: Int = 0
    var diffType: Int = 0
    
    var firstX: String = "_"
    var secondX: String = "_"
    var thirdX: String = "_"
    var forthX: String = "_"
    var realPass = ""
    var resultTextViewText = ""
    var errorLabelText = ""
    var passwordArray: [String] = []
    var userPasswordArray: [String] = []
    var arrayOfNumbers: [String] = ["_", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var arrayOfNumberIndexes = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var arrayOfNumberButtons: [NumberButton] = []
    
    var timer = Timer()
    
    var attempts = 12 {
        didSet {
            messageLabel.text = "Safe will be locked after \(attempts) attempts!!!"
        }
    }
    var time = 0 {
        didSet {
            timeLabel.text = "\(time)"
        }
    }
    
    // MARK: - Subviews
    
    let homeButton: AlertButton = {
        let v = AlertButton()
        v.setTitle("Home Page", for: .normal)
        
        return v
    }()
    
    let replayButton: AlertButton = {
        let v = AlertButton()
        v.setTitle("Replay", for: .normal)
        v.addTarget(self, action: #selector(didTapReplayButton),
                    for: .touchUpInside)
        
        return v
    }()
    
    let messageLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 20, weight: .regular)
        v.textAlignment = .center
        v.backgroundColor = .clear
        
        return v
    }()
    
    let resultTextView: UITextView = {
        let v = UITextView()
        v.backgroundColor = .white
        v.font = UIFont(name:"Courier", size: 20)
        v.isEditable = false
        return v
    }()
        
    lazy var numbersStackView: NumbersStackView = {
        let v = NumbersStackView()
        
        return v
    }()
    
    lazy var labelsStackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [
            errorLabel,
            infoLabelsStackView
        ])
        
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .vertical
        v.alignment = .fill
        v.distribution = .fillProportionally
        v.spacing = 5
        
        return v
    }()
    
    let errorLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 15, weight: .regular)
        v.textAlignment = .center
        v.text = " "
        v.backgroundColor = .clear
        v.textColor = .systemRed
        
        return v
    }()
    
    lazy var infoLabelsStackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [
            passwordLabel,
            timeLabel,
            checkButton
        ])
        
        v.axis = .horizontal
        v.alignment = .fill
        v.distribution = .fillEqually
        v.spacing = 5
        
        return v
    }()
    
    let passwordLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 22, weight: .regular)
        v.textAlignment = .center
        v.text = "____"
        v.backgroundColor = .white
        v.textColor = .black
        
        return v
    }()
    
    let timeLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = .systemFont(ofSize: 17, weight: .regular)
        v.textAlignment = .center
        v.backgroundColor = .lightGray
        v.textColor = .black
        v.layer.cornerRadius = 12
        
        return v
    }()
    
    var checkButton: UIButton = {
        let v = UIButton()
        v.setImage(UIImage(systemName: "lock.open.fill"), for: .normal)
        v.backgroundColor = .systemGray2
        v.tintColor = .darkGray
        v.isUserInteractionEnabled = true
        v.addTarget(self, action: #selector(checkButtonPressed),
                    for: .touchUpInside
        )
        
        return v
    }()
    
    lazy var pickerViewStackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [
            pickerView1,
            pickerView2,
            pickerView3,
            pickerView4
        ])
        
        v.translatesAutoresizingMaskIntoConstraints = false
        v.axis = .horizontal
        v.alignment = .fill
        v.distribution = .fillEqually
        v.spacing = 5
        
        return v
    }()
    
    let pickerView1: UIPickerView = {
        let v = UIPickerView()
        v.contentMode = .scaleToFill
        v.tag = 0
        v.isUserInteractionEnabled = true
        
        return v
    }()
    
    let pickerView2: UIPickerView = {
        let v = UIPickerView()
        v.contentMode = .scaleToFill
        v.tag = 1
        v.isUserInteractionEnabled = true
        
        return v
    }()
    
    let pickerView3: UIPickerView = {
        let v = UIPickerView()
        v.contentMode = .scaleToFill
        v.tag = 2
        v.isUserInteractionEnabled = true
        
        return v
    }()
    
    let pickerView4: UIPickerView = {
        let v = UIPickerView()
        v.contentMode = .scaleToFill
        v.tag = 3
        v.isUserInteractionEnabled = true
        
        return v
    }()
    
    private let presenter: GuessOnlyPresenterRouterProtocol
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(presenter: GuessOnlyPresenterRouterProtocol) {
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
        
        view.backgroundColor = .systemGray5
        navigationItem.hidesBackButton = true
        
        diffType = BetsPageVC.difficultyType
        
        bind()
    }
    
    // MARK: - Bind
    
    public override func bind() {
        
        homeButton
            .publisher(for: .touchUpInside)
            .sink{ [weak self] _ in
                self?.alertMessageHome()
            }
            .store(in: &cancellables)
        
        configureView()
        pickerViewProtocolConfirm()
        pickerViewStartPoint()
    }
    
    // MARK: - Setup
    
    public override func setupSubviews() {
        view.addSubviews([
            homeButton,
            replayButton,
            messageLabel,
            resultTextView,
            numbersStackView,
            labelsStackView,
            pickerViewStackView
        ])
    }
    
    public override func setupAutolayout() {
        
        homeButton.pin(edges: [.top], to: view, inset: 0, toSafeArea: true)
        homeButton.pin(edges: [.leading], to: view, inset: 40)
        replayButton.pin(edges: [.top], to: view, inset: 0, toSafeArea: true)
        replayButton.pin(edges: [.trailing], to: view, inset: 40)
        resultTextView.pin(edges: [.leading, .trailing], to: view, inset: 30)
        numbersStackView.pin(edges: [.leading, .trailing], to: view, inset: 30)
        labelsStackView.pin(edges: [.leading, .trailing], to: view, inset: 30)
        pickerViewStackView.pin(edges: [.leading, .trailing], to: view, inset: 30)
        
        homeButton.set(width: 150, height: 40)
        replayButton.set(width: 150, height: 40)
        pickerView1.set(width: 50, height: 150)
        pickerView2.set(width: 50, height: 150)
        pickerView3.set(width: 50, height: 150)
        pickerView4.set(width: 50, height: 150)
        resultTextView.set(height: 250)
        numbersStackView.set(height: 35)
        labelsStackView.set(height: 90)
        errorLabel.set(height: 30)
        infoLabelsStackView.set(height: 30)
        
        passwordLabel.layer.cornerRadius = 12
        timeLabel.layer.cornerRadius = 12
        checkButton.layer.cornerRadius = 12
        
        passwordLabel.layer.masksToBounds = true
        timeLabel.layer.masksToBounds = true
        
        NSLayoutConstraint.activate([
            messageLabel.topAnchor.constraint(
                equalTo: homeButton.bottomAnchor, constant: 10),
            messageLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            resultTextView.topAnchor.constraint(
                equalTo: messageLabel.bottomAnchor, constant: 10),
            numbersStackView.topAnchor.constraint(
                equalTo: resultTextView.bottomAnchor, constant: 15),
            labelsStackView.topAnchor.constraint(
                equalTo: numbersStackView.bottomAnchor, constant: 15),
            pickerViewStackView.topAnchor.constraint(
                equalTo: labelsStackView.bottomAnchor, constant: 15),
            pickerViewStackView.leftAnchor.constraint(
                equalTo: view.leftAnchor, constant: 30),
        ])
        
    }
    
    // MARK: - other funcs
    
    func getUsersPassword(password: String) -> [String] {
        userPasswordArray = password.map { String($0) }
        
        return(userPasswordArray)
    }
    
    func checkPassword(realPassword: [String], usersPassword: [String]) {
        var countOfDoublicates = 0
        var countOfEquals = 0
        
        let userPassword = passwordLabel.text ?? "0000"
        
        for i in 0...3 {
            if realPassword.contains(usersPassword[i]) {
                countOfDoublicates += 1
            }
        }
        for j in 0...3 {
            if realPassword[j] == usersPassword[j] {
                countOfEquals += 1
            }
        }
        if answersCounter == 0 {
            resultTextViewText = " 01. \(userPassword) - \(countOfDoublicates) : \(countOfEquals)"
            answersCounter += 1
        } else if answersCounter < 9 {
            resultTextViewText = "\(resultTextViewText) \n " + "0\(answersCounter + 1). \(userPassword) - \(countOfDoublicates) : \(countOfEquals)"
            answersCounter += 1
        } else {
            resultTextViewText = "\(resultTextViewText) \n " + "\(answersCounter + 1). \(userPassword) - \(countOfDoublicates) : \(countOfEquals)"
            answersCounter += 1
        }
        
        resultTextView.text = resultTextViewText
        if countOfEquals == 4 {
            gameOverWith(result: .win)
            messageLabel.text = "Hands up!!! You're under arrest"
        }
    }
    
    func errorOfInputed(text: String) -> Bool {
        var result = false
        for symbol in text {
            if symbol.isNumber == false {
                result = true
                errorLabelText = "Enter full password !!!"
            }
        }
        return result
    }
    
    func doublicationOfInputed(text: String) -> Bool {
        var result = false
        var emptyArray: [String] = []
        
        for symbol in text {
            if emptyArray.contains(String(symbol)) {
                result = true
                errorLabelText = "Use each number only once !!!"
            } else {
                emptyArray.append(String(symbol))
            }
        }
        return result
    }
    
    func timeString(time: Int) -> String {
        minutes = Int(time) / 60 % 60
        seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    @objc private func setTime() {
        time -= 1
        timeLabel.text = self.timeString(time: time)
        if time == 0 {
            gameOverWith(result: .lose)
        }
    }
    
    @objc func didTapReplayButton() {
        alertMessageReplay()
    }
    
    func replay() {
        
        self.presenter.moveToBetsPageScreen()
//        getStartPosition()
//        configureView()
    }
    
    func getStartPosition() {
        passwordArray = []
        realPass = ""
        userPasswordArray = []
        answersCounter = 0
        firstX = "_"
        secondX = "_"
        thirdX = "_"
        forthX = "_"
        resultTextView.text = ""
        errorLabelText = ""
        numberIndex = 0
        messageLabel.text = "Safe will be locked after \(attempts) attempts!!!"
        view.backgroundColor = .systemGray5
        messageLabel.backgroundColor = .systemGray5
        errorLabel.backgroundColor = .systemGray5
        numbersStackView.unColoringNumberButtons()
        errorLabel.text = " "
        passwordLabel.text = "____"
        pickerViewStartPoint()
        timer.invalidate()
    }
    
    func configureView() {
        passwordCreater()
        setupDifficultyOptions()
        timerGetStarted()
    }
    
    func passwordCreater() {
        var random: String
        var counter = 0
        
        while counter < 4 {
            random = String(Int.random(in: 0...9))
            if passwordArray.contains(random) == false {
                passwordArray.append(random)
                counter += 1
            }
        }
        for i in 0...3 {
            realPass += passwordArray[i]
        }
        
    }
    
    func setupDifficultyOptions() {
        switch diffType {
        case 0:
            time = 540
            attempts = 12
        case 1:
            time = 360
            attempts = 9
        case 2:
            time = 180
            attempts = 6
        default:
            break            
        }
        timeLabel.text = self.timeString(time: time)
    }
    
    func timerGetStarted() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(setTime), userInfo: nil, repeats: true)
    }
    
    func alertMessageHome() {
        CustomAlertHome.showAlert(
            on: self, actionTitle: "Yes",
            actionStyle: .default) { [weak self] _ in
                if self?.gameIsOver == false {
                    self?.updateUserInfoFor(
                        points: -BetsPageVC.currentBet,
                        wins: 0, losses: 1
                    )
                }
                self?.presenter.moveToStartPageScreen()
        }
    }
    
    func alertMessageReplay() {
        CustomAlertReplay.showAlert(
            on: self, actionTitle: "Yes",
            actionStyle: .default) { [weak self] _ in
            self?.replay()
        }
    }
    
    //other func-s
    func checkAttempts() {
        attempts -= 1
        if attempts == 0 {
            gameOverWith(result: .lose)
            messageLabel.text = " You have exceeded attempts limit "
        }
    }
    
    func gameOverWith(result: gameResult) {
        gameIsOver = true
        checkButton.isEnabled = false
        errorLabel.text = "Password was \(realPass)"
        errorLabel.textColor = .black
        timer.invalidate()
        
        switch result {
        case .win:
            view.backgroundColor = .green
            messageLabel.backgroundColor = .green
            errorLabel.backgroundColor = .green
            updateUserInfoFor(
                points: BetsPageVC.possibleWin - BetsPageVC.currentBet,
                wins: 1, losses: 0
            )
            
        case .lose:
            view.backgroundColor = .red
            messageLabel.backgroundColor = .red
            errorLabel.backgroundColor = .red
            updateUserInfoFor(
                points: -BetsPageVC.currentBet,
                wins: 0, losses: 1
            )
        }
    }
    
    func updateUserInfoFor(points: Int, wins: Int, losses: Int) {
        let db = Firestore.firestore()
        let userId = SignInVC.userId

        let userDocRef = db.collection("users").document(userId)

        userDocRef.updateData([
            "Points": FieldValue.increment(Int64(points)),
            "Wins": FieldValue.increment(Int64(wins)),
            "Losses": FieldValue.increment(Int64(losses))
        ]) { error in
            if let error = error {
                print("Error updating points: \(error)")
            } else {
                print("Points updated successfully")
            }
        }
    }
    
    // MARK: - Callbacks
    
    @objc func checkButtonPressed(_ sender: UIButton) {
        if attempts > 0 {
            if let userAnswer = passwordLabel.text {
                if errorOfInputed(text: userAnswer) {
                    errorLabel.text = errorLabelText
                } else if doublicationOfInputed(text: userAnswer) {
                    errorLabel.text = errorLabelText
                } else {
                    errorLabel.text = " "
                    let usersPassword = getUsersPassword(password: userAnswer)
                    checkPassword(realPassword: passwordArray, usersPassword: usersPassword)
                    checkAttempts()
                }
            }
            else {
                fatalError()
            }
        }
        
    }
}
extension GuessOnlyVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
    func pickerViewProtocolConfirm() {
        pickerView1.delegate = self
        pickerView1.dataSource = self
        pickerView2.delegate = self
        pickerView2.dataSource = self
        pickerView3.delegate = self
        pickerView3.dataSource = self
        pickerView4.delegate = self
        pickerView4.dataSource = self
    }
    
    func pickerViewStartPoint() {
        pickerView1.selectRow((loopingMargin / 2) * arrayOfNumbers.count, inComponent: 0, animated: false)
        pickerView2.selectRow((loopingMargin / 2) * arrayOfNumbers.count, inComponent: 0, animated: false)
        pickerView3.selectRow((loopingMargin / 2) * arrayOfNumbers.count, inComponent: 0, animated: false)
        pickerView4.selectRow((loopingMargin / 2) * arrayOfNumbers.count, inComponent: 0, animated: false)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return loopingMargin * arrayOfNumbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return arrayOfNumbers[row % arrayOfNumbers.count]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            let currentIndex = row % arrayOfNumbers.count
            pickerView.selectRow((loopingMargin / 2) * arrayOfNumbers.count + currentIndex, inComponent: 0, animated: false)
            firstX = String(arrayOfNumbers[currentIndex])
        case 1:
            let currentIndex = row % arrayOfNumbers.count
            pickerView.selectRow((loopingMargin / 2) * arrayOfNumbers.count + currentIndex, inComponent: 0, animated: false)
            secondX = String(arrayOfNumbers[currentIndex])
        case 2:
            let currentIndex = row % arrayOfNumbers.count
            pickerView.selectRow((loopingMargin / 2) * arrayOfNumbers.count + currentIndex, inComponent: 0, animated: false)
            thirdX = String(arrayOfNumbers[currentIndex])
        case 3:
            let currentIndex = row % arrayOfNumbers.count
            pickerView.selectRow((loopingMargin / 2) * arrayOfNumbers.count + currentIndex, inComponent: 0, animated: false)
            forthX = String(arrayOfNumbers[currentIndex])
        default:
            break
        }
        passwordLabel.text = "\(firstX)\(secondX)\(thirdX)\(forthX)"
    }
    
}
