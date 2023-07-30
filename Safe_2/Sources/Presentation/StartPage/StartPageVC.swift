//
//  StartPageVC.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 29.07.23.
//

import UIKit
import Combine

final class StartPageVC: BaseVC {

    // MARK: - Properties

    var game = GameConfigs()
    var gameStyle: GameConfigs.GameStyle?
    
    static var gameStyleIndex = 0
    var StartButtonEnabled = false

    // MARK: - Subviews
   
    // Game style
    let profilImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "profileImage")
        imageView.sizeToFit()
        
        return imageView
    }()
    
    let finiksCountLabel: UILabel = {
        let label = UILabel()
        label.text = "1400 Finics"
        label.textAlignment = .center
        label.layer.cornerRadius = 12
        
        return label
    }()
    
    let gameStyleLabel: UILabel = {
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        label.font = .systemFont(ofSize: 30, weight: .heavy)
        label.textAlignment = .center
        label.text = "Game style"
        
        return label
    }()
    
    lazy var GameStyleStackView: UIStackView = {
        let v = UIStackView()
        v.axis = .vertical
        v.distribution = .fill
        v.alignment = .fill
        v.spacing = 10
        
        return v
    }()
    
    var GuessOnlyButton: VariantButton = {
        let v = VariantButton()
        v.buttonState = .inactive
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Guess Only", for: .normal)
        v.tag = 1
        v.addTarget(self, action: #selector(didTapGameConfigsButton),
            for: .touchUpInside)
        
        return v
    }()
    
    var WithComputerButton: VariantButton = {
        let v = VariantButton()
        v.buttonState = .inactive
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("With computer", for: .normal)
        v.tag = 2
        v.addTarget(self, action: #selector(didTapGameConfigsButton),
                         for: .touchUpInside)
        
        return v
    }()
    
    var PlayOnlineButton: VariantButton = {
        let v = VariantButton()
        v.buttonState = .inactive
        v.translatesAutoresizingMaskIntoConstraints = false
        v.setTitle("Play online", for: .normal)
        v.tag = 3
        v.addTarget(self, action: #selector(didTapGameConfigsButton),
                         for: .touchUpInside)
        
        return v
    }()
    
    var StartButton: SubmitButton = {
        let v = SubmitButton()
        v.setTitle("Start", for: .normal)
        
        return v
    }()
    
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        getStartConfigs()
    }

    // MARK: - Bind

    public override func bind() {

    }

    // MARK: - Setup
    
    public override func setupSubviews() {

        view.addSubviews([
            profilImageView,
            finiksCountLabel,
            gameStyleLabel,
            GameStyleStackView,
            StartButton
        ])
        
        GameStyleStackView.addArrangedSubviews([
            GuessOnlyButton,
            WithComputerButton,
            PlayOnlineButton
        ])

    }

    public override func setupAutolayout() {
        
        gameStyleLabel.pin(edges: [.leading, .trailing], to: view, inset: 55)
        GameStyleStackView.pin(edges: [.leading, .trailing], to: view, inset: 55)
        StartButton.pin(edges: [.leading, .trailing], to: view, inset: 25)
        StartButton.pin(edges: [.bottom], to: view, inset: 25, toSafeArea: true)
        
        profilImageView.set(width: 80, height: 80)
        finiksCountLabel.set(height: 20)
        StartButton.set(height: 52)

        NSLayoutConstraint.activate([
            profilImageView.bottomAnchor.constraint(
                equalTo: finiksCountLabel.topAnchor, constant: -10),
            profilImageView.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            finiksCountLabel.bottomAnchor.constraint(
                equalTo: gameStyleLabel.topAnchor, constant: -30),
            finiksCountLabel.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            gameStyleLabel.bottomAnchor.constraint(
                equalTo: GameStyleStackView.topAnchor, constant: -30),
            GameStyleStackView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor)
        ])
        
    }
    
    // MARK: - other funcs
    
    private func getStartConfigs() {
        gameStyleLabel.text = "Game style"
        StartButton.isEnabled = false
    }
    
    private func isStartButtonEnable() {
        StartButton.isEnabled = gameStyle != nil
    }
    
    private func stateToggle(button: VariantButton) {
        button.buttonState = button.buttonState == .active ? .inactive : .active
    }
    
    private func makeInactive(buttons: [VariantButton]) {
        for button in buttons {
            button.buttonState = .inactive
        }
    }
    
    // MARK: - Callbacks
    
    @objc func didTapGameConfigsButton(_ sender: UIButton) {
               
        makeInactive(buttons: [
            GuessOnlyButton,
            WithComputerButton,
            PlayOnlineButton
        ])
        
        switch sender.tag {
        case 1:
            stateToggle(button: GuessOnlyButton)
        case 2:
            stateToggle(button: WithComputerButton)
        case 3:
            stateToggle(button: PlayOnlineButton)
        default:
            break
        }
        
        gameStyleLabel.text = sender.titleLabel?.text
        gameStyle = GameConfigs.GameStyle(rawValue: sender.tag)
        StartPageVC.gameStyleIndex = sender.tag
        StartButton.buttonState = .active
        }
    }
    


