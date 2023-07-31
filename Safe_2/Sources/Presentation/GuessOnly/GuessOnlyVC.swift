//
//  GuessOnlyVC.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 30.07.23.
//

import UIKit
import Combine

final class GuessOnlyVC: BaseVC {

    // MARK: - Properties

    var difficulty: GameConfigs.Difficulty?
    static var difficultyType: Int = 0
    var difficulityIndex = 0
    var diffButtonsEnabled = true
    var winMultiplier = 50
    var currentSliderValue: Int = 10
    var myFiniks: Int = 1000
    var currentColor: UIColor = .white
    let step: Float = 10

    // MARK: - Subviews
   
    // Difficulty
    let difficultyLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 30, weight: .heavy)
        v.textAlignment = .center
        v.text = "Easy"

        return v
    }()

    lazy var DifficultyStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.alignment = .fill
        v.distribution = .fillEqually
        v.spacing = 10
        v.backgroundColor = .clear
        
        return v
    }()
    
    var easyButton: VariantButton = {
        let v = VariantButton()
        v.buttonState = .active
        v.backgroundColor = .systemGreen
        v.setTitle("Easy", for: .normal)
        v.tag = 0
        v.addTarget(self, action: #selector(didTapDifficultyButton),
            for: .touchUpInside)
        
        return v
    }()
    
    var normalButton: VariantButton = {
        let v = VariantButton()
        v.buttonState = .active
        v.backgroundColor = .systemGray
        v.setTitle("Normal", for: .normal)
        v.tag = 1
        v.addTarget(self, action: #selector(didTapDifficultyButton),
            for: .touchUpInside)
        
        return v
    }()
    
    var hardButton: VariantButton = {
        let v = VariantButton()
        v.buttonState = .active
        v.backgroundColor = .systemGray
        v.setTitle("Hard", for: .normal)
        v.tag = 2
        v.addTarget(self, action: #selector(didTapDifficultyButton),
            for: .touchUpInside)
        
        return v
    }()

    // Finiks part
    let helpLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.backgroundColor = .white
        v.text = "How much FINIKS\nyou want to put\nin your SAFE?"
        v.textColor = .black
        v.textAlignment = .center
        v.font = .systemFont(ofSize: 22, weight: .heavy)
        
        return v
    }()
    
    let currentFiniksLabel: UILabel = {
        let v = UILabel()
        v.numberOfLines = 0
        v.backgroundColor = .white
        v.text = "10 Finiks"
        v.textColor = .black
        v.textAlignment = .center
        v.font = .systemFont(ofSize: 20, weight: .heavy)
        
        return v
    }()
    
    let finiksSlider: UISlider = {
        let v = UISlider()
        
        v.minimumValue = 10
        v.maximumValue = 0
        v.isContinuous = true
        v.tintColor = UIColor.green
        v.addTarget(self, action: #selector(sliderValueDidChange(_:)),
            for: .valueChanged
        )
        
        return v
    }()
    
    lazy var minMaxValuesStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.alignment = .fill
        v.distribution = .fillEqually
        v.spacing = 0
        
        return v
    }()
    
    let minValueLabel: UILabel = {
        let v = UILabel()
        v.text = "10"
        v.textAlignment = .left
        v.font = .systemFont(ofSize: 20, weight: .heavy)
        
        return v
    }()
    
    let maxValueLabel: UILabel = {
        let v = UILabel()
        v.text = "0"
        v.textAlignment = .right
        v.font = .systemFont(ofSize: 20, weight: .heavy)
        
        return v
    }()

    let winMessageLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.text = "You can win"
        v.font = .systemFont(ofSize: 25, weight: .heavy)

        return v
    }()
    
    lazy var winFinixStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .horizontal
        v.alignment = .fill
        v.distribution = .fill
        v.spacing = 0
        
        return v
    }()
    
    let winFiniksLabel: UILabel = {
        let v = UILabel()
        v.textAlignment = .center
        v.textColor = .systemGreen
        v.text = "15"
        v.font = .systemFont(ofSize: 28, weight: .heavy)

        return v
    }()
    
    let winFinixImage: UIImageView = {
        let v = UIImageView()
        v.image = UIImage.init(named: "finics")
        
        return v
    }()
    
    var startButton: SubmitButton = {
        let v = SubmitButton()
        v.buttonState = .active
        v.setTitle("Start", for: .normal)
        
        return v
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .green
        setupSlidersValues()
        setupSubviews()
        
        bind()
    }

    // MARK: - Bind

    public override func bind() {

    }

    // MARK: - Setup
    
    public override func setupSubviews() {
        view.addSubviews([
            difficultyLabel,
            DifficultyStackView,
            helpLabel,
            currentFiniksLabel,
            finiksSlider,
            minMaxValuesStackView,
            winMessageLabel,
            winFinixStackView,
            startButton
        ])
        
        DifficultyStackView.addArrangedSubviews([
            easyButton,
            normalButton,
            hardButton
        ])
        
        minMaxValuesStackView.addArrangedSubviews([
            minValueLabel,
            maxValueLabel
        ])
        
        winFinixStackView.addArrangedSubviews([
            winFiniksLabel,
            winFinixImage
        ])
    }

    public override func setupAutolayout() {
        
        difficultyLabel.pin(edges: [.top], to: view, inset: 0, toSafeArea: true)
        difficultyLabel.pin(edges: [.leading, .trailing], to: view, inset: 25)
        finiksSlider.pin(edges: [.leading, .trailing], to: view, inset: 35)
        minMaxValuesStackView.pin(edges: [.leading, .trailing], to: view, inset: 35)
        winMessageLabel.pin(edges: [.leading, .trailing], to: view, inset: 35)

        startButton.pin(edges: [.leading, .trailing], to: view, inset: 25)
        startButton.pin(edges: [.bottom], to: view, inset: 25, toSafeArea: true)

        DifficultyStackView.set(width: 200)
        winFinixStackView.set(width: 100, height: 30)
        startButton.set(height: 48)
        easyButton.set(height: 35)
        normalButton.set(height: 35)
        hardButton.set(height: 35)
        
        NSLayoutConstraint.activate([
            DifficultyStackView.topAnchor.constraint(
                equalTo: difficultyLabel.bottomAnchor, constant: 10),
            DifficultyStackView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            helpLabel.topAnchor.constraint(
                equalTo: DifficultyStackView.bottomAnchor, constant: 30),
            helpLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            currentFiniksLabel.topAnchor.constraint(
                equalTo: helpLabel.bottomAnchor, constant: 30),
            currentFiniksLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            finiksSlider.topAnchor.constraint(
                equalTo: currentFiniksLabel.bottomAnchor, constant: 20),
            minMaxValuesStackView.topAnchor.constraint(
                equalTo: finiksSlider.bottomAnchor, constant: 20),
            winMessageLabel.topAnchor.constraint(
                equalTo: minMaxValuesStackView.bottomAnchor, constant: 30),
            winFinixStackView.topAnchor.constraint(
                equalTo: winMessageLabel.bottomAnchor, constant: 10),
            winFinixStackView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
        ])
        
    }
    
    // MARK: - other funcs
    
    func setupSlidersValues() {
        finiksSlider.minimumValue = 10
        finiksSlider.maximumValue = Float(1400)
        minValueLabel.text = "\(10)"
        maxValueLabel.text = "\(1400)"
    }
    
    func unColoringButtons() {
        easyButton.backgroundColor = .systemGray
        normalButton.backgroundColor = .systemGray
        hardButton.backgroundColor = .systemGray
    }
    
    func updateFiniksValue() {
        winFiniksLabel.text = "\(currentSliderValue + (currentSliderValue * winMultiplier / 100))"
    }
    
    // MARK: - Callbacks
    
    @objc func sliderValueDidChange(_ sender: UISlider) {
        print("Slider value changed")
        
        let roundedStepValue = Int(round(sender.value / step) * step)
        currentSliderValue = roundedStepValue
        currentFiniksLabel.text = "\(currentSliderValue) Finics"
        
        updateFiniksValue()
    }
    
    @objc func didTapDifficultyButton(sender: UIButton) {
        difficulty = GameConfigs.Difficulty(rawValue: sender.tag)
        difficultyLabel.text = sender.titleLabel?.text
        unColoringButtons()
        difficulityIndex = sender.tag
        
        switch difficulityIndex {
        case 0:
            currentColor = .systemGreen
            winMultiplier = 50
        case 1:
            currentColor = .systemYellow
            winMultiplier = 85
        case 2:
            currentColor = .systemRed
            winMultiplier = 120

        default:
            unColoringButtons()
        }
        easyButton.backgroundColor = currentColor
        finiksSlider.tintColor = currentColor
        winFiniksLabel.textColor = currentColor
        
        updateFiniksValue()
        BetsPageVC.difficultyType = difficulityIndex
        
    }
    
    @objc func didTappedStartButton() { }
    
}




