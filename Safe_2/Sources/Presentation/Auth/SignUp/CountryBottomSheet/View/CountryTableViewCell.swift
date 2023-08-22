//
//  CountryTableViewCell.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 21.08.23.
//

import UIKit

class CountryTableViewCell: UITableViewCell {

    // MARK: - Subviews
    
    let flagImageView: UIImageView = {
        let v = UIImageView()
        
        return v
    }()
    
    let countryLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 16)
        v.textColor = .black
        v.textAlignment = .left
        
        return v
    }()
    
    public func configure(flag: String, country: String) {
        flagImageView.image = UIImage(named: flag)
        countryLabel.text = country

        setupUI()
    }
    
    func setupUI() {
        selectionStyle = .none

        contentView.addSubviews([
            flagImageView,
            countryLabel
        ])
        
        flagImageView.pin(edges: [.leading], to: contentView, inset: 0)
        countryLabel.set(width: 300, height: 30)
        
        NSLayoutConstraint.activate([
            flagImageView.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            countryLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            countryLabel.leadingAnchor.constraint(
                equalTo: flagImageView.trailingAnchor, constant: 20)
        ])
    }

}
