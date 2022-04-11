//
//  TableVC.swift
//  Reminder
//
//  Created by bari on 2021/12/2.
//

import UIKit
import CoreData

class TableVC: UITableViewController, DetailVCDelegate, SettingVCDelegate {
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
    var TableVCGroupByCategory = false
    var TableVCSortByPriority = false

    override func viewDidLoad() {
        super.viewDidLoad()
        readData()
        NotificationCenter.default.addObserver(self, selector: #selector(self.timezoneNotification), name: Notification.Name.NSSystemTimeZoneDidChange, object: nil)
        self.navigationController?.isNavigationBarHidden = false
    }
    
    func deletionAlert(title: String, completion: @escaping (UIAlertAction) -> Void) {
        
        let alertMsg = NSLocalizedString("str_deleteMessage", comment: "")
        let alert = UIAlertController(title:  NSLocalizedString("str_warning", comment: ""), message: alertMsg, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("str_delete", comment: ""), style: .destructive, handler: completion)
        let cancelAction = UIAlertAction(title: NSLocalizedString("str_cancel", comment: ""), style: .cancel, handler:nil)
        
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
        reminderinfo.title = "Trip Summary" as? String
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
        if segue.destination is SettingVC {
            let vc = segue.destination as? SettingVC
            vc?.GroupByCategory = self.TableVCGroupByCategory
            vc?.SortByPriority = self.TableVCSortByPriority
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
    
    @objc func timezoneNotification() {
        let message = NSLocalizedString("str_timeZoneNotifyMessage", comment: "")
        let alert = UIAlertController(title: NSLocalizedString("str_timeZoneNotifyTitle", comment: ""), message: message, preferredStyle: .alert)
        let ok = UIAlertAction(title: NSLocalizedString("str_OK", comment: ""), style: .cancel)
        alert.addAction(ok)
        present(alert, animated: true)
    }
    
    @IBAction func HozGesture(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .right:
            performSegue(withIdentifier: "ToSetting", sender: self)
        default:
            break
        }
    }
    
    func SortByPriority() {
        let context = AppDelegate.cdContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reminder")
        let sort = NSSortDescriptor(key: "priority", ascending: false)
        fetchRequest.sortDescriptors = [sort]
        do {
            ReminderList = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch requested item. \(error), \(error.userInfo)")
        }
        TableVCSortByPriority = true
        TableVCGroupByCategory = false
        tableView.reloadData()
    }
    
    func GroupByCategory() {
        let context = AppDelegate.cdContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reminder")
        let sort = NSSortDescriptor(key: "category", ascending: true)
        fetchRequest.sortDescriptors = [sort]
        do {
            ReminderList = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch requested item. \(error), \(error.userInfo)")
        }
        TableVCGroupByCategory = true
        TableVCSortByPriority = false
        tableView.reloadData()
    }
    
    func GroupByCategoryToTableview(){
        GroupByCategory()
    }
    
    func SortByPriorityToTableview(){
        SortByPriority()
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
