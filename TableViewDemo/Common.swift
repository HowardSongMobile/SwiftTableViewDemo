//
//  Common.swift
//  TableViewDemo
//
//  Created by Song on 2019-04-11.
//  Copyright © 2019 Song. All rights reserved.
//

import Foundation

struct User: Decodable {
    
    let firstName: String
    let lastName: String
    let city: String
    
    enum CodingKeys : String, CodingKey {
        case firstName = "fname"
        case lastName = "lname"
        case city = "city"
    }
}
