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

    private lazy var profileImageView: UIImageView = {
        let tap = UITapGestureRecognizer(target: self,
            action: #selector(didTapProfileImageView(gestureRecognizer:)))
        let v = UIImageView()
        v.addGestureRecognizer(tap)
        v.isUserInteractionEnabled = true
        v.contentMode = .scaleToFill
        v.image = UIImage(named: "profileImage")
        
        return v
    }()
    
    let levelLabel: UILabel = {
        let v = UILabel()
        v.text = "1"
        v.textAlignment = .center
        v.clipsToBounds = true
        v.layer.borderColor = UIColor.gray.cgColor
        v.layer.borderWidth = 1
        v.backgroundColor = .black
        v.textColor = .white

        return v
    }()
    
    let nameLabel: UILabel = {
        let v = UILabel()
        v.text = "User"
        v.font = .systemFont(ofSize: 15, weight: .bold)
        v.textAlignment = .center
        
        return v
    }()
    
    let finiksCountLabel: UILabel = {
        let v = UILabel()
        v.text = " "
        v.font = .systemFont(ofSize: 14, weight: .regular)
        v.textAlignment = .center
        
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        fetchUserData()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        getStartConfigs()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        levelLabel.layer.cornerRadius = levelLabel.frame.width / 2
        profileImageView.clipsToBounds = true
        profileImageView.layer.borderColor = UIColor.gray.cgColor
        profileImageView.layer.borderWidth = 2
    }
    
    // MARK: - Bind
    
    public override func bind() {
        StartButton
            .publisher(for: .touchUpInside)
            .sink { [weak self] _ in
                guard let self else { return }
                self.presenter.moveToBetsPageScreen()
            }
            .store(in: &cancellables)
    }
    
    // MARK: - Setup
    
    public override func setupSubviews() {
        
        view.addSubviews([
            profileImageView,
            levelLabel,
            nameLabel,
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
        
        profileImageView.pin(edges: [.top], to: view, inset: 0, toSafeArea: true)
        nameLabel.pin(edges: [.top], to: view, inset: 15, toSafeArea: true)
        profileImageView.pin(edges: [.leading], to: view, inset: 25)
        gameStyleLabel.pin(edges: [.leading, .trailing], to: view, inset: 55)
        GameStyleStackView.pin(edges: [.leading, .trailing], to: view, inset: 55)
        StartButton.pin(edges: [.leading, .trailing], to: view, inset: 25)
        StartButton.pin(edges: [.bottom], to: view, inset: 25, toSafeArea: true)
        
        profileImageView.set(width: 90, height: 90)
        levelLabel.set(width: 25, height: 25)
        nameLabel.set(height: 20)
        finiksCountLabel.set(height: 20)
        StartButton.set(height: 52)
        
        NSLayoutConstraint.activate([
            levelLabel.topAnchor.constraint(
                equalTo: profileImageView.topAnchor),
            levelLabel.trailingAnchor.constraint(
                equalTo: profileImageView.trailingAnchor),
            nameLabel.leadingAnchor.constraint(
                equalTo: profileImageView.trailingAnchor, constant: 20),
            finiksCountLabel.topAnchor.constraint(
                equalTo: nameLabel.bottomAnchor, constant: 10),
            finiksCountLabel.leadingAnchor.constraint(
                equalTo: profileImageView.trailingAnchor, constant: 20),
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
    
    private func updateUIWithUserData() {
        if let user = userModel,
             let url = user.profilePictureURL,
               let name = user.name,
                 let points = user.points {
            
            setupProfileImageWith(url: url)
              nameLabel.text = name
                finiksCountLabel.text = "\(points) Finiks"
        }
    }
    
    private func setupProfileImageWith(url: String?) {
        if let imageURL = url, let url = URL(string: imageURL) {
            let urlRequest = URLRequest(url: url)
            
            URLSession.shared.dataTask(with: urlRequest) { data, _, error in
                if let data = data, let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self.profileImageView.image = image
                    }
                }
            }.resume()
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


