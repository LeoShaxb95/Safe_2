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
    var hasProfilePicture = false
    
    enum rightBarItem {
        case edit
        case done
    }
    
    enum userInfoType {
        case name
        case url
    }
    
    // MARK: - Subviews
    
    private lazy var profileImageView: UIImageView = {
        let tap = UITapGestureRecognizer(target: self,
            action: #selector(didTapProfileImageView(gestureRecognizer:)))
        let v = UIImageView()
        v.addGestureRecognizer(tap)
        v.isUserInteractionEnabled = false
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
        v.font = .systemFont(ofSize: 16, weight: .regular)
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
    
    let signOutButton: UIButton = {
        let v = UIButton()
        v.setTitle("Sign out", for: .normal)
        v.setTitleColor(.systemBlue, for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 20)

        return v
    }()
    
    let deleteAccountButton: UIButton = {
        let v = UIButton()
        v.setTitle("Delete account", for: .normal)
        v.setTitleColor(.systemBlue, for: .normal)
        v.titleLabel?.font = .systemFont(ofSize: 20)

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
        setProfilePictureIfNeeded()
        
        bind()
    }
    
    public override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        profileImageView.layer.cornerRadius = profileImageView.frame.width / 2
        profileImageView.clipsToBounds = true
    }
    
    // MARK: - Bind
    
    public override func bind() {
        editPhotoButton
            .publisher(for: .touchUpInside)
            .sink{ [weak self] _ in
                guard let self else { return }
                self.editPhotoButtonTapped()
            }
            .store(in: &cancellables)
        
        signOutButton
            .publisher(for: .touchUpInside)
            .sink{ [weak self] _ in
                guard let self else { return }
                self.signOutButtonTapped()
            }
            .store(in: &cancellables)
        
        deleteAccountButton
            .publisher(for: .touchUpInside)
            .sink{ [weak self] _ in
                guard let self else { return }
                self.deleteAccountButtonTapped()
            }
            .store(in: &cancellables)
        
    }
    
    // MARK: - Setup
    
    public override func setupSubviews() {
        
        view.addSubviews([
            profileImageView,
            editPhotoButton,
            nameTextField,
            tableView,
            signOutButton,
            deleteAccountButton
        ])
        
        tableView.delegate = self
        tableView.dataSource = dataSource
        tableView.register(ProfileTableViewCell.self)
    }
    
    public override func setupAutolayout() {
        
        profileImageView.pin(edges: [.top], to: view, inset: 20, toSafeArea: true)
        profileImageView.pin(edges: [.leading], to: view, inset: 30)
        tableView.pin(edges: [.trailing],to: view, inset: 30)
        tableView.pin(edges: [.bottom],to: view, inset: 16, toSafeArea: true)
        deleteAccountButton.pin(edges: [.bottom], to: view, inset: 80, toSafeArea: true)

        profileImageView.set(width: 120, height: 120)
        editPhotoButton.set(width: 120, height: 20)
        signOutButton.set(height: 30)
        deleteAccountButton.set(height: 30)

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
            tableView.leadingAnchor.constraint(
                equalTo: profileImageView.centerXAnchor, constant: -30),
            signOutButton.bottomAnchor.constraint(
                equalTo: deleteAccountButton.topAnchor, constant: -20),
            signOutButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            deleteAccountButton.centerXAnchor.constraint(
                equalTo: view.centerXAnchor),
            tableView.topAnchor.constraint(
                equalTo: editPhotoButton.bottomAnchor, constant: 30)
        ])
        
    }
    
    private func setProfilePictureIfNeeded() {
        guard let data = data,
              let url = data.profilePictureURL
        else { return }
            profileImageView.image = UIImage(named: "profileImage")
    }
    
    // MARK: - other funcs
    
    private func setupNavRightBarWith(item: rightBarItem) {
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
    
    private func showPictureLibrary() {
        let imagePicker = UIImagePickerController()
          imagePicker.delegate = self
          imagePicker.sourceType = .photoLibrary
          present(imagePicker, animated: true, completion: nil)
    }
    
    private func getInfoFor(data: UserModel?) {
        if let data = data {
            self.nameTextField.text = data.name
            self.setupProfileImageWith(url: data.profilePictureURL)
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
    
    private func updateUser(info: String, infoType: userInfoType) {
        var field = ""
        
        switch infoType {
        case .name:
            field = "Name"
        case .url:
            field = "ProfilePictureURL"
        }
        
        let db = Firestore.firestore()
        let userId = SignInVC.userId
        let userDocRef = db.collection("users").document(userId)
        
        userDocRef.updateData([
            field: info
        ]) { error in
            if let error = error {
                print("Error updating \(infoType): \(error)")
            } else {
                print("\(infoType) updated successfully")
            }
        }
        
    }
    
    private func uploadProfilePicture(image: UIImage, userId: String) {
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
                    self.updateUser(info: imageURL, infoType: .url)
                    DispatchQueue.main.async {
                        self.setupProfileImageWith(url: imageURL)
                    }
                    self.hasProfilePicture = true
                }
            }
        }
    }
    
    // MARK: - Callbacks
    
    @objc func didTapProfileImageView(gestureRecognizer: UIGestureRecognizer) {
        showPictureLibrary()
    }
    
    @objc func editButtonTapped(_ sender: UIBarButtonItem) {
        isInEditMode = !isInEditMode
        setupNavRightBarWith(item: isInEditMode ? .done : .edit)
        nameTextField.font = .systemFont(ofSize: 16, weight: .thin)
        nameTextField.isUserInteractionEnabled = true
        nameTextField.becomeFirstResponder()
        profileImageView.isUserInteractionEnabled = true
        editPhotoButton.isHidden = false
    }
    
    @objc func doneButtonTapped(_ sender: UIBarButtonItem) {
        guard let name = nameTextField.text else { return }
        
        isInEditMode = !isInEditMode
        setupNavRightBarWith(item: isInEditMode ? .done : .edit)
        updateUser(info: name, infoType: .name)
        nameTextField.font = .systemFont(ofSize: 16, weight: .regular)
        nameTextField.resignFirstResponder()
        nameTextField.isUserInteractionEnabled = false
        profileImageView.isUserInteractionEnabled = false
        editPhotoButton.isHidden = true
    }
    
    @objc func editPhotoButtonTapped() {
        showPictureLibrary()
    }
    
    @objc func signOutButtonTapped() {
        do {
            try Auth.auth().signOut()
            self.presenter.moveToSignInScreen()
        } catch let error {
            print("Error signing out: \(error.localizedDescription)")
        }
    }
    
    @objc func deleteAccountButtonTapped() {
        guard let userId = Auth.auth().currentUser?.uid else {
            print("User not authenticated")
            return
        }
        
        Auth.auth().currentUser?.delete { error in
            if let error = error {
                print("Error deleting account: \(error.localizedDescription)")
            } else {
                // Account deleted successfully, you might want to perform additional cleanup
                // For example, deleting the user's data from Firestore
                self.deleteUserDataFromFirestore(userId: userId)
            }
        }
    }

    private func deleteUserDataFromFirestore(userId: String) {
        let db = Firestore.firestore()
        let userDocRef = db.collection("users").document(userId)
        
        userDocRef.delete { error in
            if let error = error {
                print("Error deleting user data from Firestore: \(error.localizedDescription)")
            } else {
                self.deleteProfilePictureFromStorage(userId: userId)
                self.presenter.moveToSignInScreen()
            }
        }
    }
    
    private func deleteProfilePictureFromStorage(userId: String) {
        let storage = Storage.storage()
        let storageRef = storage.reference()
        let profilePictureRef = storageRef.child("ProfilePictures").child("\(userId).jpg")
        
        profilePictureRef.delete { error in
            if let error = error {
                print("Error deleting profile picture from Storage: \(error.localizedDescription)")
            } else {
                print("Profile picture deleted from Storage")
            }
        }
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
