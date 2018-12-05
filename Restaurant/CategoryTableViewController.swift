//
//  CategoryTableViewController.swift
//  Restaurant
//
//  Created by Daryl Zandvliet on 03/12/2018.
//  Copyright © 2018 Daryl Zandvliet. All rights reserved.
//

import UIKit

class CategoryTableViewController: UITableViewController {
    
    var menuItems = [MenuItem]()
    var categories = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        MenuController.shared.fetchCategories { (categories) in
            if let categories = categories {
                self.updateUI(with: categories)
            }
        }
    }

    func updateUI(with categories: [String]) {
        DispatchQueue.main.async {
            self.categories = categories
            self.tableView.reloadData()
        }
    }



    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
      // #warning Incomplete implementation, return the number of sections
       return 1
    }
    
    // number of rows
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      // #warning Incomplete implementation, return the number of rows
        return categories.count
    }


    // Dequeue the right cells
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "CategoryCellIdentifier", for: indexPath)

        // Configure the cell...
        configure(cell, forItemAt:indexPath)

        return cell
    }
    
    // configure the cells and set the labels & images
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        let categoryString = categories[indexPath.row]
        cell.textLabel?.text = categoryString.capitalized
        
        switch categoryString {
            case "appetizers":
                cell.imageView?.image = UIImage(named:"entrees")
            case "entrees":
                cell.imageView?.image = UIImage(named:"appetizer")
            
        default:
            print("Didn't went well")
        }
        
//        set the image size, partially copied from: https://stackoverflow.com/questions/2788028/how-do-i-make-uitableviewcells-imageview-a-fixed-size-even-when-the-image-is-sm
//
        let itemSize = CGSize.init(width: 120, height: 100)
        UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
        let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
        cell.imageView?.image!.draw(in: imageRect)
        cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
        UIGraphicsEndImageContext();
        
    }
    
    // Pass the data to the MenuTableViewControlller
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.identifier == "MenuSegue" {
            let menuTableViewController = segue.destination as!
            MenuTableViewController
            let index = tableView.indexPathForSelectedRow!.row
            menuTableViewController.category = categories[index]
    }
    
    }
    
    
    // set the height of the cell
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }

    


}
