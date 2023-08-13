//
//  StartPageVC.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 29.07.23.
//

import UIKit
import Combine
import Firebase

final class StartPageVC: BaseVC {
    
    // MARK: - Properties
    
    let db = Firestore.firestore()
    var game = GameConfigs()
    var gameStyle: GameConfigs.GameStyle?
    var variantButtons: [VariantButton] = []
    var StartButtonEnabled = false
    static var gameStyleIndex = 0
    static var pointsCount = 0
    
    // MARK: - Subviews
    
    // Game style
    private lazy var profilImageView: UIImageView = {
        let tap = UITapGestureRecognizer(target: self,
            action: #selector(didTapProfileImageView(gestureRecognizer:)))
        let v = UIImageView()
        v.sizeToFit()
        v.addGestureRecognizer(tap)
        v.backgroundColor = .yellow
        v.isUserInteractionEnabled = true
        v.image = UIImage(named: "profileImage")
        
        return v
    }()
    
    let finiksCountLabel: UILabel = {
        let v = UILabel()
        v.text = " Finics"
        v.textAlignment = .center
        v.layer.cornerRadius = 12
        
        return v
    }()
    
    let gameStyleLabel: UILabel = {
        let v = UILabel()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.font = .systemFont(ofSize: 30, weight: .heavy)
        v.textAlignment = .center
        v.text = "Game style"
        
        return v
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
    
    private var userModel: UserModel? {
        didSet {
            DispatchQueue.main.async {
                self.updateUIWithUserData()
            }
        }
    }
    
    private let presenter: StartPagePresenter
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(presenter: StartPagePresenter) {
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
        navigationItem.hidesBackButton = true

        fetchUserData()
        setupVariantButtons()
        bind()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        getStartConfigs()
    }
    
    private func updateUIWithUserData() {
        if let user = userModel,
             let points = user.points {
            finiksCountLabel.text = "\(points) Finiks"
        }
    }
    
    private func fetchUserData() {
        presenter.getUser { [weak self] user in
            self?.userModel = user
            
            DispatchQueue.main.async {
                self?.updateUIWithUserData()
            }
        }
    }
    
    // MARK: - Bind
    
    public override func bind() {
        StartButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self,
                        let model = userModel,
                          let points = model.points
                            else { return }
                
                self.presenter.moveToBetsPageScreen(points)
            }
            .store(in: &cancellables)
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
        
        profilImageView.pin(edges: [.top], to: view, inset: 20, toSafeArea: true)
        profilImageView.pin(edges: [.leading], to: view, inset: 25)
        gameStyleLabel.pin(edges: [.leading, .trailing], to: view, inset: 55)
        GameStyleStackView.pin(edges: [.leading, .trailing], to: view, inset: 55)
        StartButton.pin(edges: [.leading, .trailing], to: view, inset: 25)
        StartButton.pin(edges: [.bottom], to: view, inset: 25, toSafeArea: true)
        
        profilImageView.set(width: 80, height: 80)
        finiksCountLabel.set(height: 20)
        StartButton.set(height: 52)
        
        NSLayoutConstraint.activate([
            finiksCountLabel.topAnchor.constraint(
                equalTo: profilImageView.bottomAnchor, constant: 10),
            finiksCountLabel.centerXAnchor.constraint(
                equalTo: profilImageView.centerXAnchor),
            gameStyleLabel.bottomAnchor.constraint(
                equalTo: GameStyleStackView.topAnchor, constant: -30),
            GameStyleStackView.centerYAnchor.constraint(
                equalTo: view.centerYAnchor)
        ])
        
    }
    
    private func setupVariantButtons() {
        variantButtons = [GuessOnlyButton, WithComputerButton, PlayOnlineButton]
    }
    
    // MARK: - other funcs
    
    private func getStartConfigs() {
        gameStyleLabel.text = "Game style"
        makeInactive(buttons: variantButtons)
        StartButton.buttonState = .inactive
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
        
        makeInactive(buttons: variantButtons)
        
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
    
    @objc func didTapProfileImageView(gestureRecognizer: UIGestureRecognizer) {
        if let user = userModel {
            self.presenter.moveToProfileScreen(user)
        }
    }
}


