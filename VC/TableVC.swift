//
//  TableVC.swift
//  Reminder
//
//  Created by bari on 2021/12/2.
//

import UIKit
import CoreData

class TableVC: UITableViewController, DetailVCDelegate {
    func deleteApp(data: ReminderInfo) {
    
        if let item = ReminderList[data.indexRow!.row] as? Reminder {
            let context = AppDelegate.cdContext
                if let _ = ReminderList.firstIndex(of: item)  {
                    context.delete(item)
                    do {
                        try context.save()
                    } catch let error as NSError {
                        print("Could not delete the item. \(error), \(error.userInfo)")
                    }
                }
            readData()
        }
    }

    
    
    var ReminderList: [NSManagedObject] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        readData()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }
    
    func deletionAlert(title: String, completion: @escaping (UIAlertAction) -> Void) {
        
        let alertMsg = "Are you sure you want to delete \(title)?"
        let alert = UIAlertController(title: "Warning", message: alertMsg, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: "Delete", style: .destructive, handler: completion)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler:nil)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        alert.popoverPresentationController?.permittedArrowDirections = []
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.midX, y: self.view.frame.midY, width: 0, height: 0)
        
        present(alert, animated: true, completion: nil)
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return ReminderList.count
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "ReminderCell") as? ReminderCell else{
            fatalError("Expected ReminderCell")
        }
        
        if let item = ReminderList[indexPath.row] as? Reminder{
            cell.update(with: item)
        }
        return cell
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
            if editingStyle == .delete {
                if let item = ReminderList[indexPath.row] as? Reminder, let name = item.title {
                    deletionAlert(title: name, completion: { _ in
                        self.deleteItem(item: item)
                    })
                }
            }
        }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let selectedCell = ReminderList[indexPath.row]
        let reminderinfo = ReminderInfo()
        reminderinfo.title = selectedCell.value(forKey: "title") as? String
        reminderinfo.describe = selectedCell.value(forKey: "describe") as? String
        reminderinfo.date = selectedCell.value(forKey: "date") as? Date
        reminderinfo.priority = selectedCell.value(forKey: "priority") as? Int
        reminderinfo.url = selectedCell.value(forKey: "link") as? String
        reminderinfo.category = selectedCell.value(forKey: "category") as? Int
        reminderinfo.indexRow = indexPath
        tableView.deselectRow(at: indexPath, animated: true)
        performSegue(withIdentifier: "ToDetail", sender: reminderinfo)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        if segue.destination is DetailVC {
            let vc = segue.destination as? DetailVC
            vc?.reminderInfo = sender as? ReminderInfo
            vc?.delegate = self
        }
    }
    
    func deleteItem(item: Reminder) {
            let context = AppDelegate.cdContext
            if let _ = ReminderList.firstIndex(of: item)  {
                context.delete(item)
                do {
                    try context.save()
                } catch let error as NSError {
                    print("Could not delete the item. \(error), \(error.userInfo)")
                }
            }
            readData()
        }

    func readData() {
        let context = AppDelegate.cdContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reminder")
        do {
            ReminderList = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch requested item. \(error), \(error.userInfo)")
        }
        tableView.reloadData()
    }
    
    @IBAction func myUnwindAction(_ unwindSegue: UIStoryboardSegue) {
        readData()
        tableView.reloadData()
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
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
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
