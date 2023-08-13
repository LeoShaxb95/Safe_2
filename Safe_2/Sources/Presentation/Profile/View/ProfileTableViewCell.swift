//
//  ProfileTableViewCell.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 10.08.23.
//

import UIKit

public final class ProfileTableViewCell: UITableViewCell {
    
    // MARK: - Subviews
    
    let titleLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 16)
        v.textColor = .black

        return v
    }()
    
    let rightDetailLabel: UILabel = {
        let v = UILabel()
        v.font = .systemFont(ofSize: 16)
        v.textColor = .black
        v.textAlignment = .left
        
        return v
    }()
    
    public func configure(title: String, detailLabel: String) {
        titleLabel.text = title
        rightDetailLabel.text = detailLabel

        setupUI()
    }
    
    func setupUI() {
        selectionStyle = .none

        contentView.addSubviews([
            titleLabel,
            rightDetailLabel
        ])
        
        titleLabel.pin(edges: [.leading], to: contentView, inset: 0)
        titleLabel.set(width: 100)
        
        NSLayoutConstraint.activate([
            titleLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            rightDetailLabel.centerYAnchor.constraint(
                equalTo: contentView.centerYAnchor),
            rightDetailLabel.leadingAnchor.constraint(
                equalTo: titleLabel.trailingAnchor, constant: 30)
        ])
    }
}
