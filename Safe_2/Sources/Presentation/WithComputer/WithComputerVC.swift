//
//  WithComputerVC.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 30.07.23.
//

import UIKit
import Combine
import Firebase

final class WithComputerVC: BaseVC {
    
    // MARK: - Properties
    
    let loopingMargin: Int = 20
    var gameConfigs = GameConfigs()
    var difficulty: GameConfigs.Difficulty?
    var difficultyUrishIndex: Int = 0
    var passwordArray: [String] = []
    var usersPassword = CreatePasswordVC.newPassword
    var realPass = ""
    var newCompAnswer = ""
    var userPasswordArray: [String] = []
    var rightNumbersArray: [String] = []
    var wrongNumbersArray: [String] = []
    var compAnswersArray: [String] = []
    var usersTimer = Timer()
    var computersTimer = Timer()
    var computersThinkingTimer = Timer()
    var minutes: Int = 0
    var seconds: Int = 0
    var answersCounter = 0
    var index = 0
    var firstX: String = "_"
    var secondX: String = "_"
    var thirdX: String = "_"
    var forthX: String = "_"
    var leftResultTextViewText = ""
    var rightResultTextViewText = ""
    var errorLabelText = ""
    var arrayOfNumberButtons: [NumberButton] = []
    var arrayOfNumberIndexes = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    var arrayOfPickerViewNumbers: [String] = ["_", "0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var arrayOfNumbers: [String] = ["0", "1", "2", "3", "4", "5", "6", "7", "8", "9"]
    var usersClockIsActive = true
    var isUsersTurn = true
    var replayButtonPressed = false
    var gameIsOver = false
    var compAnswersCounter = 0
    var numberIndex: Int = 0
    var diffType: Int = 0
    var computerThinkingTime = 0
    var usersTime = 0 {
        didSet {
            usersTimeLabel.text = "\(usersTime)"
        }
    }
    var computersTime = 0 {
        didSet {
            computersTimeLabel.text = "\(computersTime)"
        }
    }
    
    var isSafeOpened = false
    
    let numbers = [0, 1, 2, 3, 4, 5, 6, 7, 8, 9]
    var arrayOfRealDoublicates: [Int] = []
    var arrayOfRealEquals: [Int] = []
    var shuffledNumbers: [Int] = []
    
    var countOfRealDoublicates = 0
    var countOfRealEquals = 0
    
    var countOfDoublicates = 0
    var countOfEquals = 0
    
    var arrayOfUsedVariants: [String] = []
    var arrayOfRightVariants: [String] = []
    var arrayOfAllVariants: [String] = []
    
    var newElement: String = ""
    var movesCounter = 0
    var tryingPass: String = ""
    
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
    
    // Result Stack View
    
    lazy var resultStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            leftResultStackView,
            rightResultStackView
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .horizontal
        stackView.alignment = .fill
        stackView.distribution = .fillEqually
        stackView.spacing = 5
        
        return stackView
    }()
    
    lazy var leftResultStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            leftResultLabel,
            leftResultTextView,
            usersTimeLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        
        return stackView
    }()
    
    let leftResultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.backgroundColor = .systemGray5
        label.text = "Me"
        label.textColor = .black
        label.layer.cornerRadius = 12
        
        return label
    }()
    
    let leftResultTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.font = UIFont(name:"Courier", size: 16)
        return textView
    }()
    
    let usersTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.backgroundColor = .systemGray5
        label.textColor = .black
        label.layer.cornerRadius = 12
        
        return label
    }()
    
    lazy var rightResultStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            rightResultLabel,
            rightResultTextView,
            computersTimeLabel
        ])
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fill
        stackView.spacing = 5
        
        return stackView
    }()
    
    let rightResultLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.backgroundColor = .systemGray5
        label.textColor = .black
        label.text = "Computer"
        label.layer.cornerRadius = 12
        
        return label
    }()
    
    let rightResultTextView: UITextView = {
        let textView = UITextView()
        textView.backgroundColor = .white
        textView.font = UIFont(name:"Courier", size: 16)
        return textView
    }()
    
    let computersTimeLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 17, weight: .regular)
        label.textAlignment = .center
        label.backgroundColor = .systemGray5
        label.textColor = .black
        label.text = "Computer"
        label.layer.cornerRadius = 12
        
        return label
    }()
    
    //Numbers Stack View
    
    lazy var numbersStackView: NumbersStackView = {
        let v = NumbersStackView()
        
        return v
    }()
    
    lazy var labelsStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            errorLabel,
            infoLabelsStackView
        ])
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        stackView.axis = .vertical
        stackView.alignment = .fill
        stackView.distribution = .fillProportionally
        stackView.spacing = 5
        
        return stackView
    }()
    
    let errorLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 15, weight: .regular)
        label.textAlignment = .center
        label.text = " "
        label.backgroundColor = .systemGray5
        label.textColor = .systemRed
        
        return label
    }()
    
    lazy var infoLabelsStackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [
            passwordLabel,
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
    
    //PickerView
    
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
    
    private let presenter: WithComputerPresenter
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(presenter: WithComputerPresenter) {
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
        
        //diffType = StartPageViewController.difficultyType
        view.backgroundColor = .systemGray5
        navigationItem.hidesBackButton = true
        shuffledNumbers = numbers.shuffled()
        
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
        
        createComputersAnswersArray()
        configureView()
        pickerViewProtocolConfirm()
        pickerViewStartPoint()
    }
    
    // MARK: - Setup
    
    public override func setupSubviews() {
        view.addSubviews([
            homeButton,
            replayButton,
            resultStackView,
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
        resultStackView.pin(edges: [.leading, .trailing], to: view, inset: 10)
        numbersStackView.pin(edges: [.leading, .trailing], to: view, inset: 30)
        labelsStackView.pin(edges: [.leading, .trailing], to: view, inset: 30)
        pickerViewStackView.pin(edges: [.leading, .trailing], to: view, inset: 30)

        homeButton.set(width: 150, height: 40)
        replayButton.set(width: 150, height: 40)
        resultStackView.set(height: 250)
        leftResultLabel.set(height: 20)
        rightResultLabel.set(height: 20)
        numbersStackView.set(height: 35)
        labelsStackView.set(height: 90)
        errorLabel.set(height: 30)
        infoLabelsStackView.set(height: 30)
        pickerView1.set(width: 50, height: 150)
        pickerView2.set(width: 50, height: 150)
        pickerView3.set(width: 50, height: 150)
        pickerView4.set(width: 50, height: 150)

        NSLayoutConstraint.activate([
            resultStackView.topAnchor.constraint(
                equalTo: homeButton.bottomAnchor, constant: 15),
            numbersStackView.topAnchor.constraint(
                equalTo: resultStackView.bottomAnchor, constant: 15),
            labelsStackView.topAnchor.constraint(
                equalTo: numbersStackView.bottomAnchor, constant: 15),
            pickerViewStackView.topAnchor.constraint(
                equalTo: labelsStackView.bottomAnchor, constant: 15),
            pickerViewStackView.leftAnchor.constraint(
                equalTo: view.leftAnchor, constant: 30)
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
            leftResultTextViewText = " 01. \(userPassword) - \(countOfDoublicates) : \(countOfEquals)"
            answersCounter += 1
        } else if answersCounter < 9 {
            leftResultTextViewText = "\(leftResultTextViewText) \n " + "0\(answersCounter + 1). \(userPassword) - \(countOfDoublicates) : \(countOfEquals)"
            answersCounter += 1
        } else {
            leftResultTextViewText = "\(leftResultTextViewText) \n " + "\(answersCounter + 1). \(userPassword) - \(countOfDoublicates) : \(countOfEquals)"
            answersCounter += 1
        }
        
        leftResultTextView.text = leftResultTextViewText
        if countOfEquals == 4 {
            gameOverWith(result: .win)
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
    
    // MARK: - Time
    
    func timeString(time: Int) -> String {
        minutes = Int(time) / 60 % 60
        seconds = Int(time) % 60
        return String(format:"%02i:%02i", minutes, seconds)
    }
    
    @objc private func usersClock() {
        usersTime -= 1
        usersTimeLabel.text = self.timeString(time: usersTime)
        if usersTime == 0 {
            gameOverWith(result: .lose)
        }
    }
    
    @objc private func computersClock() {
        computersTime -= 1
        computersTimeLabel.text = self.timeString(time: computersTime)
        if computersTime == 0 {
            computersTimer.invalidate()
        }
    }
    
    func timeConfigs() {
        switch diffType {
        case 0:
            usersTime = 540
            computersTime = 540
        case 1:
            usersTime = 360
            computersTime = 360
        case 2:
            usersTime = 180
            computersTime = 180
        default:
            break
        }
        usersTimeLabel.text = self.timeString(time: usersTime)
        computersTimeLabel.text = self.timeString(time: computersTime)
    }
    
    func usersTimerGetStarted() {
        usersTimer.invalidate()
        usersTimer = Timer.scheduledTimer(
            timeInterval: 1, target: self, selector: #selector(usersClock),
            userInfo: nil, repeats: true)
    }
    
    func computersTimerGetStarted() {
        computersTimer = Timer.scheduledTimer(
            timeInterval: 1, target: self, selector: #selector(computersClock),
            userInfo: nil, repeats: true)
    }
    
    func switchClocks() {
        if usersClockIsActive {
            usersTimer.invalidate()
            computersTimerGetStarted()
            usersClockIsActive = false
        } else {
            computersTimer.invalidate()
            usersTimerGetStarted()
            usersClockIsActive = true
        }
    }
    
    func gameOverWith(result: gameResult) {
        gameIsOver = true
        replayButtonPressed = false
        usersTimer.invalidate()
        computersTimer.invalidate()
        checkButton.isEnabled = false
        errorLabel.text = "Password was \(realPass)"
        errorLabel.textColor = .black
        
        switch result {
        case .win:
            view.backgroundColor = .green
            errorLabel.backgroundColor = .green
            updateUserInfoFor(
                points: BetsPageVC.possibleWin - BetsPageVC.currentBet,
                wins: 1,
                losses: 0
            )
        case .lose:
            view.backgroundColor = .red
            errorLabel.backgroundColor = .red
            updateUserInfoFor(
                points: -BetsPageVC.currentBet,
                wins: 0,
                losses: 1
            )
        }
    }
    
    @objc func didTapReplayButton() {
        alertMessageReplay()
    }
    
    func configureView() {
        passwordCreater()
        timeConfigs()
        usersTimerGetStarted()
    }
    
    func passwordCreater() {
        var random: String
        var counter = 0
        
        while counter < 4 {
            random = String(Int.random(in: 0...9))
            if !passwordArray.contains(random) {
                passwordArray.append(random)
                counter += 1
            }
        }
        for i in 0...3 {
            realPass += passwordArray[i]
        }
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
                self?.presenter.moveToCreatePasswordScreen()
        }
    }
    
    func changeNumberOf(index: Int) -> Int {
        var newIndex = 0
        
        switch index {
        case 0:
            newIndex = 1
        case 1:
            newIndex = 2
        case 2:
            newIndex = 0
        default:
            break
        }
        return newIndex
    }
    
    func changeButtonColor(button: UIButton, index: Int) {
        switch index {
        case 0:
            button.backgroundColor = .systemGray2
        case 1:
            button.backgroundColor = .systemGreen
        case 2:
            button.backgroundColor = .systemRed
        default:
            break
        }
    }
    
    func unColoringNumberButtons() {
        for button in arrayOfNumberButtons {
            button.backgroundColor = .systemGray2
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
        usersMove()
    }
    
    func usersMove() {
        if let userAnswer = passwordLabel.text {
            if errorOfInputed(text: userAnswer) {
                errorLabel.text = errorLabelText
            } else if doublicationOfInputed(text: userAnswer) {
                errorLabel.text = errorLabelText
            } else {
                errorLabel.text = " "
                let usersPassword = getUsersPassword(
                    password: userAnswer)
                checkPassword(
                    realPassword: passwordArray,
                    usersPassword: usersPassword
                )
                checkButton.isEnabled = false
                switchClocks()
                if !gameIsOver {
                    computersMove()
                }
            }
        }
    }
    
    // MARK: - Computers Move
    
    func createComputersAnswersArray() {
        for a in 0...9 {
            for b in 0...9 {
                for c in 0...9 {
                    for d in 0...9 {
                        if a != b && a != c && a != d && b != c && b != d && c != d {
                            newElement = String(a) + String(b) + String(c) + String(d)
                            if !arrayOfAllVariants.contains(newElement) {
                                arrayOfAllVariants.append(newElement)
                            }
                        }
                    }
                }
            }
        }
        
        func checkDoublicates(str1: String, str2: String) -> Int {
            var doublicates = 0
            for symbols in str2 {
                if str1.contains(symbols) {
                    doublicates += 1
                }
            }
            return doublicates
        }
        
        func checkEquals(str1: String, str2: String) -> Int {
            var equals = 0
            let firstString = Array(str1)
            let secondString = Array(str2)
            
            for index in 0...3 {
                if firstString[index] == secondString[index] {
                    equals += 1
                }
            }
            return equals
        }
        
        func chooseTryingPass() {
            switch movesCounter {
            case 0:
                tryingPass = String(shuffledNumbers[0]) + String(shuffledNumbers[1]) +
                String(shuffledNumbers[2]) + String(shuffledNumbers[3])
            case 1:
                tryingPass = String(shuffledNumbers[4]) + String(shuffledNumbers[5]) +
                String(shuffledNumbers[6]) + String(shuffledNumbers[7])
            default:
                if arrayOfAllVariants.count > 0 {
                    tryingPass = arrayOfAllVariants[0]
                } else {
                    tryingPass = "0123"
                }
            }
            arrayOfUsedVariants.append(tryingPass)
        }
        
        while isSafeOpened == false {
            chooseTryingPass()
            
            countOfRealDoublicates = checkDoublicates(
                str1: usersPassword,
                str2: tryingPass
            )
            countOfRealEquals = checkEquals(
                str1: usersPassword,
                str2: tryingPass
            )
            
            if countOfRealEquals == 4 {
                arrayOfAllVariants == []
                arrayOfRightVariants == []
                arrayOfRightVariants.append(tryingPass)
                arrayOfRealDoublicates.append(countOfRealDoublicates)
                arrayOfRealEquals.append(countOfRealEquals)
                isSafeOpened = true
            } else {
                for index in 0...(arrayOfAllVariants.count - 1) {
                    countOfDoublicates = checkDoublicates(
                        str1: tryingPass,
                        str2: arrayOfAllVariants[index]
                    )
                    countOfEquals = checkEquals(
                        str1: tryingPass,
                        str2: arrayOfAllVariants[index]
                    )
                    
                    if countOfRealDoublicates == countOfDoublicates &&
                        countOfRealEquals == countOfEquals {
                        arrayOfRightVariants.append(arrayOfAllVariants[index])
                    }
                }
                movesCounter += 1
                
                arrayOfRealDoublicates.append(countOfRealDoublicates)
                arrayOfRealEquals.append(countOfRealEquals)
                
                arrayOfAllVariants = arrayOfRightVariants
                arrayOfRightVariants = []
                
                if arrayOfAllVariants.count == 1 {
                    isSafeOpened = true
                    if !arrayOfUsedVariants.contains(arrayOfAllVariants[0]) {
                        arrayOfUsedVariants.append(arrayOfAllVariants[0])
                        arrayOfRealDoublicates.append(4)
                        arrayOfRealEquals.append(4)
                    }
                }
            }
        }
    }
    
    @objc func newComputerAnswer() {
        if !replayButtonPressed {
            let newAnswer = arrayOfUsedVariants[index]
            let newDoublicatesCount = arrayOfRealDoublicates[index]
            let newEqualsCount = arrayOfRealEquals[index]
            
            if compAnswersCounter == 0 {
                rightResultTextViewText = " 01. \(newAnswer) - \(newDoublicatesCount) : \(newEqualsCount)"
                compAnswersCounter += 1
            } else if compAnswersCounter < 9 {
                rightResultTextViewText = "\(rightResultTextViewText) \n " + "0\(compAnswersCounter + 1). \(newAnswer) - \(newDoublicatesCount) : \(newEqualsCount)"
                compAnswersCounter += 1
            } else {
                rightResultTextViewText = "\(rightResultTextViewText) \n " + "\(compAnswersCounter + 1). \(newAnswer) - \(newDoublicatesCount) : \(newEqualsCount)"
                compAnswersCounter += 1
            }
            if newEqualsCount == 4 {
                gameOverWith(result: .lose)
            } else {
                checkButton.isEnabled = true
            }
            rightResultTextView.text = rightResultTextViewText
            index += 1
        }
        if !gameIsOver {
            switchClocks()
        }
        replayButtonPressed = false
    }
    
    func computersMove() {
        switch index {
        case 0:
            computerThinkingTime = Int.random(in: 3...4)
        case 1, 2, 3:
            computerThinkingTime = Int.random(in: 3...6)
        case 4, 5, 6:
            computerThinkingTime = Int.random(in: 3...8)
        case 7, 8, 9:
            computerThinkingTime = Int.random(in: 3...10)
        default:
            computerThinkingTime = Int.random(in: 3...12)
        }
        perform(#selector(newComputerAnswer), with: nil,
                afterDelay: TimeInterval(computerThinkingTime)
        )
        
    }
    
}

extension WithComputerVC: UIPickerViewDelegate, UIPickerViewDataSource {
    
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
        pickerView1.selectRow((loopingMargin / 2) * arrayOfPickerViewNumbers.count, inComponent: 0, animated: false)
        pickerView2.selectRow((loopingMargin / 2) * arrayOfPickerViewNumbers.count, inComponent: 0, animated: false)
        pickerView3.selectRow((loopingMargin / 2) * arrayOfPickerViewNumbers.count, inComponent: 0, animated: false)
        pickerView4.selectRow((loopingMargin / 2) * arrayOfPickerViewNumbers.count, inComponent: 0, animated: false)
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return loopingMargin * arrayOfPickerViewNumbers.count
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        
        return arrayOfPickerViewNumbers[row % arrayOfPickerViewNumbers.count]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        switch pickerView.tag {
        case 0:
            let currentIndex = row % arrayOfPickerViewNumbers.count
            pickerView.selectRow((loopingMargin / 2) * arrayOfPickerViewNumbers.count + currentIndex, inComponent: 0, animated: false)
            firstX = String(arrayOfPickerViewNumbers[currentIndex])
        case 1:
            let currentIndex = row % arrayOfPickerViewNumbers.count
            pickerView.selectRow((loopingMargin / 2) * arrayOfPickerViewNumbers.count + currentIndex, inComponent: 0, animated: false)
            secondX = String(arrayOfPickerViewNumbers[currentIndex])
        case 2:
            let currentIndex = row % arrayOfPickerViewNumbers.count
            pickerView.selectRow((loopingMargin / 2) * arrayOfPickerViewNumbers.count + currentIndex, inComponent: 0, animated: false)
            thirdX = String(arrayOfPickerViewNumbers[currentIndex])
        case 3:
            let currentIndex = row % arrayOfPickerViewNumbers.count
            pickerView.selectRow((loopingMargin / 2) * arrayOfPickerViewNumbers.count + currentIndex, inComponent: 0, animated: false)
            forthX = String(arrayOfPickerViewNumbers[currentIndex])
        default:
            break
        }
        passwordLabel.text = "\(firstX)\(secondX)\(thirdX)\(forthX)"
    }
    
}
