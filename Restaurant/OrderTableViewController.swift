//
//  OrderTableViewController.swift
//  Restaurant
//
//  Created by Daryl Zandvliet on 03/12/2018.
//  Copyright © 2018 Daryl Zandvliet. All rights reserved.
//

import UIKit

class OrderTableViewController: UITableViewController {
    
    var orderMinutes = 0
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.leftBarButtonItem = editButtonItem
        
        NotificationCenter.default.addObserver(tableView, selector: #selector(UITableView.reloadData), name: MenuController.orderUpdatedNotification, object: nil)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return MenuController.shared.order.menuItems.count
    }


    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "OrderCellIdentifier", for: indexPath)

        // Configure the cell...
        configure(cell, forItemAt: indexPath)
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            MenuController.shared.order.menuItems.remove(at:indexPath.row)
        }
    }

    
    
    func configure(_ cell: UITableViewCell, forItemAt indexPath: IndexPath) {
        
        let menuItem = MenuController.shared.order.menuItems[indexPath.row]
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
    
    @IBAction func submitTapped(_ sender: Any) {
        
        let orderTotal = MenuController.shared.order.menuItems.reduce(0.0)
        { (result, menuItem) -> Double in
            return result + menuItem.price
        }
        let formattedOrder = String(format: "$%.2f", orderTotal)

        let alert = UIAlertController(title: "Confirm Order", message: "You are about to submit your order with a total of \(formattedOrder)", preferredStyle: .alert)
        
            alert.addAction(UIAlertAction(title: "Submit",style: .default) { action in
                self.uploadOrder()
                
            })
            alert.addAction(UIAlertAction(title: "Cancel",style: .cancel, handler: nil))
            present(alert, animated: true, completion: nil)
    }

    
    func uploadOrder() {
        let menuIds = MenuController.shared.order.menuItems.map { $0.id }
        MenuController.shared.submitOrder(forMenuIDs: menuIds){ (minutes) in
            DispatchQueue.main.async {
                if let minutes = minutes {
                    self.orderMinutes = minutes
                    self.performSegue(withIdentifier:
                    "ConfirmationSegue", sender: nil)
                }
            }
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ConfirmationSegue" {
            
            let orderConfirmationViewController = segue.destination as! OrderConfirmationViewController
            
            orderConfirmationViewController.minutes = orderMinutes
        }
    }
    

    @IBAction func unwindToOrderList(segue: UIStoryboardSegue){
        if segue.identifier == "DismissConfirmation" {
            MenuController.shared.order.menuItems.removeAll()
        }
        
    }
    
    
    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
