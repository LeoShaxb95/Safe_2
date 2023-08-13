//
//  ProfileDataSource.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 11.08.23.
//


import UIKit

public final class ProfileDataSource: NSObject {
    private unowned var tableView: UITableView
    private var data: UserModel?
    
    // MARK: - Init
    
    public init(
        tableView: UITableView
    ) {
        self.tableView = tableView
        super.init()
        
        self.tableView.dataSource = self
    }
    
    func reload(_ model: UserModel) {
        self.data = model
        self.tableView.reloadData()
    }
}

// MARK: - UITableViewDataSource

extension ProfileDataSource: UITableViewDataSource {
    public func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    public func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let model = data,
              let points = model.points, let level = model.level,
              let status = model.status, let wins = model.winCount,
              let losses = model.loseCount
        else { return UITableViewCell() }
        
        switch indexPath.row {
        case 0:
            let cell = tableView.dequeue(cell: ProfileTableViewCell.self, for: indexPath)
            cell.configure(title: "Points", detailLabel: "\(points)")

            return cell
        case 1:
            let cell = tableView.dequeue(cell: ProfileTableViewCell.self, for: indexPath)
            cell.configure(title: "Level", detailLabel: "\(level)")
            
            return cell
        case 2:
            let cell = tableView.dequeue(cell: ProfileTableViewCell.self, for: indexPath)
            cell.configure(title: "Status", detailLabel: status)
            
            return cell
        case 3:
            let cell = tableView.dequeue(cell: ProfileTableViewCell.self, for: indexPath)
            cell.configure(title: "Wins", detailLabel: "\(wins)")
            
            return cell
        case 4:
            let cell = tableView.dequeue(cell: ProfileTableViewCell.self, for: indexPath)
            cell.configure(title: "Losses", detailLabel: "\(losses)")
            
            return cell
        default:
            return UITableViewCell()
        }
    }
}

