//
//  OrderConfirmationViewController.swift
//  Restaurant
//
//  Created by Daryl Zandvliet on 04/12/2018.
//  Copyright © 2018 Daryl Zandvliet. All rights reserved.
//

import UIKit

class OrderConfirmationViewController: UIViewController {
    
    @IBOutlet weak var timeRemainingLabel: UILabel!
    var minutes : Int!
    
    
    
    

    override func viewDidLoad() {
        super.viewDidLoad()
        
        timeRemainingLabel.text = "Thanks for your order! Your wait time is +/- \(minutes!) minutes"
        
        // Do any additional setup after loading the view.
    }


}
