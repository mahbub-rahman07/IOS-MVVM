//
//  Response.swift
//  MVVM
//
//  Created by Mahbub on 17/6/22.
//

import Foundation

struct User: Codable {
    let userID, id: Int
    let title, body: String

    enum CodingKeys: String, CodingKey {
        case userID = "userId"
        case id, title, body
    }
}

typealias Users = [User]


