//
//  CountryBottomSheetVC.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 21.08.23.
//

import UIKit
import Combine

protocol CountryBottomSheetDelegate: AnyObject {
    func didSelectCountry(country: CountryModel)
}

final class CountryBottomSheetVC: BaseVC {
    
    // MARK: - Properties
    
    private var filteredData: [CountryModel]?
    weak var delegate: CountryBottomSheetDelegate?
    
    // MARK: - Subviews
    
    let instructionLabel: UILabel = {
        let v = UILabel()
        v.text = "Select Country"
        v.font = .systemFont(ofSize: 20,weight: .regular)

        return v
    }()
    
    lazy var searchStackView: UIStackView = {
        let v = UIStackView(arrangedSubviews: [
            searchTextField,
            createLineView()
        ])
        v.axis = .vertical
        v.distribution = .fill
        v.alignment = .fill
        v.spacing = 10
        
        return v
    }()
    
    let searchTextField: UITextField = {
        let v = UITextField()
        v.font = .systemFont(ofSize: 20,weight: .regular)
        v.autocorrectionType = .no
        v.placeholder = "Search"
        
        return v
    }()
    
    private lazy var tableView: UITableView = {
        let v = UITableView()
        v.separatorStyle = .none
        v.backgroundColor = .white
        v.isScrollEnabled = true
        v.showsVerticalScrollIndicator = false

        return v
    }()
    
    private var data: [CountryModel]?
    private let presenter: CountryBottomSheetPresenterStoreProtocol
    var cancellables = Set<AnyCancellable>()
    
    // MARK: - Init
    
    init(presenter: CountryBottomSheetPresenterStoreProtocol) {
        self.presenter = presenter
        self.data = presenter.getCountries()
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
        searchTextField.delegate = self
        filterCountries(with: nil)
        
        setupSubviews()
        bind()
    }
    
    // MARK: - Bind
    
    public override func bind() {
        
    }
    
    // MARK: - Setup
    
    public override func setupSubviews() {
        view.addSubviews([
           instructionLabel,
           searchStackView,
           tableView
        ])
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(CountryTableViewCell.self)
    }
    
    public override func setupAutolayout() {
        
        instructionLabel.pin(edges: [.top, .leading, .trailing], to: view, inset: 30)
        searchStackView.pin(edges: [.leading, .trailing], to: view, inset: 30)
        tableView.pin(edges: [.leading, .trailing, .bottom], to: view, inset: 30)

        instructionLabel.set(height: 30)
        searchStackView.set(height: 33)

        NSLayoutConstraint.activate([
            searchStackView.topAnchor.constraint(
                equalTo: instructionLabel.bottomAnchor, constant: 10),
            tableView.topAnchor.constraint(
                equalTo: searchStackView.bottomAnchor, constant: 20)
        ])
    }
    
    // MARK: - Other funcs
    
    private func createLineView() -> UIView {
        let view = UIView()
        view.backgroundColor = .gray
        view.set(height: 2)

        return view
    }
    
    private func filterCountries(with searchText: String?) {
        if let searchText = searchText, !searchText.isEmpty {
            filteredData = data?.filter { country in
                guard let country = country.country else { return false }
                return country.lowercased().contains(searchText.lowercased())
            }
        } else {
            filteredData = data
        }
        
        tableView.reloadData()
    }

    
    // MARK: Callbacks
  
}

extension CountryBottomSheetVC: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 40
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
           tableView.deselectRow(at: indexPath, animated: true)
           
           guard let selectedCountry = filteredData?[indexPath.row] else { return }
        print("asdf \(selectedCountry)")
           
           delegate?.didSelectCountry(country: selectedCountry)
           dismiss(animated: true, completion: nil)
       }
}

// MARK: - UITableViewDataSource

extension CountryBottomSheetVC: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let data = data else { return 0 }
        
        return filteredData?.count ?? 0
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = filteredData,
              let flag = model[indexPath.row].flag,
              let country = model[indexPath.row].country
        else { return UITableViewCell() }
        
        let cell = tableView.dequeue(cell: CountryTableViewCell.self, for: indexPath)
        cell.configure(flag: flag, country: country)
        
        return cell
    }
}

extension CountryBottomSheetVC: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange,
                   replacementString string: String) -> Bool {
        guard textField == searchTextField else {
            return true
        }
        
        let updatedText = (textField.text as NSString?)?.replacingCharacters(
            in: range, with: string)
        filterCountries(with: updatedText)
        
        return true
    }
    
}
