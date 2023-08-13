//
//  UserModel.swift
//  Safe_2
//
//  Created by Levon Shaxbazyan on 10.08.23.
//

import UIKit

struct UserModel {
    public var userId: String?
    public var level: Int?
    public var status: String?
    public var name: String?
    public var email: String?
    public var points: Int?
    public var winCount: Int?
    public var loseCount: Int?
}

public enum Status {
    case novice
    case beginner
    case profy
    case expert
}
