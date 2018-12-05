//
//  MenuTableViewController.swift
//  Restaurant
//
//  Created by Daryl Zandvliet on 03/12/2018.
//  Copyright © 2018 Daryl Zandvliet. All rights reserved.
//

import UIKit

class MenuTableViewController: UITableViewController {
    
    var menuItems = [MenuItem]()
    
    var category : String!
    
    

    override func viewDidLoad() {
        super.viewDidLoad()

        title = category.capitalized
        MenuController.shared.fetchMenuItems(forCategory: category) { (menuItems) in
            if let menuItems = menuItems {
                self.updateUI(with: menuItems)
            }
        }
    }

    func updateUI(with menuItems: [MenuItem]) {
        DispatchQueue.main.async {
            self.menuItems = menuItems
            self.tableView.reloadData()
        }
    }
    

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    
    // number of rows displayed
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return menuItems.count
    }
    
    // set the height of the cells
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    // Dequeue the right cells for the menu
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "MenuCellIdentifier", for: indexPath)

        // Configure the cell...
        configure(cell, forItemAt: indexPath)

        return cell
    }

    // configure the cells and set the labels, images
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        let menuItem = menuItems[indexPath.row]
        cell.textLabel?.text = menuItem.name
        cell.detailTextLabel?.text = String(format: "$%.2f", menuItem.price)
        MenuController.shared.fetchImage(url: menuItem.imageURL)
        { (image) in
            guard let image = image else { return }
            DispatchQueue.main.async {
                if let currentIndexPath =
                    self.tableView.indexPath(for:cell),
                    currentIndexPath != indexPath {
                        return
                }
                cell.imageView?.image = image
              //cell.setNeedsLayout()
                
                // set the image size, partially copied from: https://stackoverflow.com/questions/2788028/how-do-i-make-uitableviewcells-imageview-a-fixed-size-even-when-the-image-is-sm
                //
                let itemSize = CGSize.init(width: 100, height: 100)
                UIGraphicsBeginImageContextWithOptions(itemSize, false, UIScreen.main.scale);
                let imageRect = CGRect.init(origin: CGPoint.zero, size: itemSize)
                cell.imageView?.image!.draw(in: imageRect)
                cell.imageView?.image! = UIGraphicsGetImageFromCurrentImageContext()!;
                UIGraphicsEndImageContext();
                
            }
        }
        
    }
    
    // pass the data to the next view controller
    
    override func prepare(for segue: UIStoryboardSegue, sender:Any?) {
        if segue.identifier == "MenuDetailSegue" {
            let menuItemDetailViewController = segue.destination as! MenuItemDetailViewController
            let index = tableView.indexPathForSelectedRow!.row
            menuItemDetailViewController.menuItem = menuItems[index]
        }
    }
    

}
