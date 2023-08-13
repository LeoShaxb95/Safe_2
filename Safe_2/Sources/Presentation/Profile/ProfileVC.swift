//
//  ProfileVC.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 10.08.23.
//

import UIKit
import Combine

final class ProfileVC: BaseVC {
    
    // MARK: - Properties
    
    var isInEditMode = false
    
    enum rightBarItem {
        case edit
        case done
    }
    
    // MARK: - Subviews
    
    private lazy var profileImageView: UIImageView = {
        let tap = UITapGestureRecognizer(target: self,
            action: #selector(didTapProfileImageView(gestureRecognizer:)))
        let v = UIImageView()
        v.addGestureRecognizer(tap)
        v.backgroundColor = .yellow
        v.isUserInteractionEnabled = true
        v.image = UIImage(named: "profileImage")
        v.contentMode = .scaleAspectFit
        
        return v
    }()
    
    let nameTextField: UITextField = {
        let v = UITextField()
        v.text = "Levon Shaxbazyan"
        v.textAlignment = .left
        v.backgroundColor = .clear
        v.isUserInteractionEnabled = false
        
        return v
    }()
    
    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.separatorStyle = .none
        v.backgroundColor = .white
        v.isScrollEnabled = false
        v.showsVerticalScrollIndicator = false

        return v
    }()
    
    private var data: UserModel?
    private var dataSource: ProfileDataSource!
    private let presenter: ProfilePresenterProtocol
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(presenter: ProfilePresenterProtocol, model: UserModel) {
        self.presenter = presenter
        self.data = model
        super.init(nibName: nil, bundle: nil)
       
        self.dataSource = .init(tableView: tableView)
        self.dataSource.reload(model)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.backgroundColor = .white
        setupNavRightBarWith(item: .edit)
            updateInfoWith(data: data)

        bind()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
    }
    
    // MARK: - Bind
    
    public override func bind() {
        
    }
    
    // MARK: - Setup
    
    public override func setupSubviews() {
        
        view.addSubviews([
            profileImageView,
            nameTextField,
            tableView
        ])
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(ProfileTableViewCell.self)
        
    }
    
    public override func setupAutolayout() {
        
        profileImageView.pin(edges: [.top], to: view, inset: 20, toSafeArea: true)
        profileImageView.pin(edges: [.leading], to: view, inset: 30)
        tableView.pin(edges: [.leading, .trailing],to: view, inset: 30)
        tableView.pin(edges: [.bottom],to: view, inset: 16, toSafeArea: true)
        
        profileImageView.set(width: 120, height: 120)
        
        NSLayoutConstraint.activate([
            nameTextField.leadingAnchor.constraint(
                equalTo: profileImageView.trailingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: 30),
            nameTextField.centerYAnchor.constraint(
                equalTo: profileImageView.centerYAnchor),
            tableView.topAnchor.constraint(
                equalTo: profileImageView.bottomAnchor, constant: 30)
        ])
        
    }
    
    // MARK: - other funcs
    
    func setupNavRightBarWith(item: rightBarItem) {
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit,
            target: self, action: #selector(editButtonTapped(_:)))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
            target: self, action: #selector(editButtonTapped(_:)))
        
        switch item {
        case .edit:
            navigationItem.rightBarButtonItem = editButton
        case .done:
            navigationItem.rightBarButtonItem = doneButton
        }
    }
    
    func updateInfoWith(data: UserModel?) {
        if let data = data {
            self.nameTextField.text = data.name
        }
        
        // Soon: change image with url
    }
    
    // MARK: - Callbacks
    
    @objc func didTapProfileImageView(gestureRecognizer: UIGestureRecognizer) {
        
    }
    
    @objc func editButtonTapped(_ sender: UIBarButtonItem) {
        isInEditMode = !isInEditMode
        setupNavRightBarWith(item: isInEditMode ? .done : .edit)
        nameTextField.isUserInteractionEnabled = true
    }
}

extension ProfileVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

