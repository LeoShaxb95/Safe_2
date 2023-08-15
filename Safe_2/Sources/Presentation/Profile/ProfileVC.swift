//
//  ProfileVC.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 10.08.23.
//

import UIKit
import Combine
import Firebase
import FirebaseStorage

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
        v.isUserInteractionEnabled = true
        v.contentMode = .scaleToFill
        
        return v
    }()
    
    let editPhotoButton: UIButton = {
        let v = UIButton()
        v.setTitle("Edit", for: .normal)
        v.setTitleColor(.systemBlue, for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 14)
        v.isHidden = true

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
        getInfoFor(data: data)
        
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
            editPhotoButton,
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
        editPhotoButton.set(width: 120, height: 20)

        NSLayoutConstraint.activate([
            editPhotoButton.topAnchor.constraint(
                equalTo: profileImageView.bottomAnchor, constant: 10),
            editPhotoButton.centerXAnchor.constraint(
                equalTo: profileImageView.centerXAnchor),
            nameTextField.leadingAnchor.constraint(
                equalTo: profileImageView.trailingAnchor, constant: 20),
            nameTextField.trailingAnchor.constraint(
                equalTo: view.trailingAnchor, constant: 30),
            nameTextField.centerYAnchor.constraint(
                equalTo: profileImageView.centerYAnchor),
            tableView.topAnchor.constraint(
                equalTo: editPhotoButton.bottomAnchor, constant: 30)
        ])
        
    }
    
    // MARK: - other funcs
    
    func setupNavRightBarWith(item: rightBarItem) {
        let editButton = UIBarButtonItem(barButtonSystemItem: .edit,
            target: self, action: #selector(editButtonTapped(_:)))
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done,
            target: self, action: #selector(doneButtonTapped(_:)))
        
        switch item {
        case .edit:
            navigationItem.rightBarButtonItem = editButton
        case .done:
            navigationItem.rightBarButtonItem = doneButton
        }
    }
    
    func getInfoFor(data: UserModel?) {
        if let data = data {
            self.nameTextField.text = data.name
            self.setupProfileImageWith(url: data.profilePictureURL)
        }
    }
    
    func setupProfileImageWith(url: String?) {
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
    
    func updateUserInfoFor(name: String) {
        let db = Firestore.firestore()
        let userId = SignInVC.userId
        let userDocRef = db.collection("users").document(userId)
        
        userDocRef.updateData([
            "Name": name
        ]) { error in
            if let error = error {
                print("Error updating points: \(error)")
            } else {
                print("Points updated successfully")
            }
        }
    }
    
    func updateUserInfoFor(url: String) {
        let db = Firestore.firestore()
        let userId = SignInVC.userId
        let userDocRef = db.collection("users").document(userId)
        
        userDocRef.updateData([
            "ProfilePictureURL": url
        ]) { error in
            if let error = error {
                print("Error updating points: \(error)")
            } else {
                print("Points updated successfully")
            }
        }
    }
    
    func uploadProfilePicture(image: UIImage, userId: String) {
        guard let imageData = image.jpegData(compressionQuality: 0.5) else {
            return
        }
        
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let profilePictureRef = storageRef.child("ProfilePictures").child("\(userId).jpg")
        
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        
        profilePictureRef.putData(imageData, metadata: metadata) { metadata, error in
            if let error = error {
                print("Error uploading profile picture: \(error.localizedDescription)")
                return
            }
            
            profilePictureRef.downloadURL { url, error in
                if let imageURL = url?.absoluteString {
                    self.updateUserProfilePicture(userId: userId, imageURL: imageURL)
                    DispatchQueue.main.async {
                        self.setupProfileImageWith(url: imageURL)
                    }
                }
            }
        }
    }
    
    func updateUserProfilePicture(userId: String, imageURL: String) {
        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(userId)
        
        userDocRef.updateData([
            "ProfilePictureURL": imageURL
        ]) { error in
            if let error = error {
                print("Error updating profile picture URL: \(error)")
            } else {
                print("Profile picture URL updated successfully")
            }
        }
    }
    
    // MARK: - Callbacks
    
    @objc func didTapProfileImageView(gestureRecognizer: UIGestureRecognizer) {
        let imagePicker = UIImagePickerController()
          imagePicker.delegate = self
          imagePicker.sourceType = .photoLibrary
          present(imagePicker, animated: true, completion: nil)
    }
    
    @objc func editButtonTapped(_ sender: UIBarButtonItem) {
        isInEditMode = !isInEditMode
        setupNavRightBarWith(item: isInEditMode ? .done : .edit)
        nameTextField.isUserInteractionEnabled = true
        editPhotoButton.isHidden = false
    }
    
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        isInEditMode = !isInEditMode
        setupNavRightBarWith(item: isInEditMode ? .done : .edit)
        nameTextField.isUserInteractionEnabled = false
        editPhotoButton.isHidden = true
        guard let name = nameTextField.text else { return }
        updateUserInfoFor(name: name)
    }
    
    @objc func editPhotoButtonTapped(_ sender: UIBarButtonItem) {
        isInEditMode = !isInEditMode
        setupNavRightBarWith(item: isInEditMode ? .done : .edit)
        nameTextField.isUserInteractionEnabled = false
        editPhotoButton.isHidden = true
        guard let name = nameTextField.text else { return }
        updateUserInfoFor(name: name)
    }
}

extension ProfileVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
}

extension ProfileVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if let selectedImage = info[.originalImage] as? UIImage {
            dismiss(animated: true, completion: nil)
            
            uploadProfilePicture(image: selectedImage, userId: SignInVC.userId)
        }
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }
}
