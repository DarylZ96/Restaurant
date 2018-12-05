//
//  IntermediaryModels.swift
//  Restaurant
//
//  Created by Daryl Zandvliet on 04/12/2018.
//  Copyright © 2018 Daryl Zandvliet. All rights reserved.
//

import Foundation

struct Categories : Codable {
    let categories : [String]
}


struct PreparationTime: Codable {
    let prepTime: Int
    
    enum CodingKeys: String, CodingKey {
        case prepTime = "preparation_time"
    }
}

