//
//  Order.swift
//  Restaurant
//
//  Created by Daryl Zandvliet on 04/12/2018.
//  Copyright © 2018 Daryl Zandvliet. All rights reserved.
//

import Foundation

struct Order: Codable {
    var menuItems: [MenuItem]
    
    init(menuItems: [MenuItem] = []) {
        self.menuItems = menuItems
    }
}
