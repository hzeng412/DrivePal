//
//  DetailVC.swift
//  Reminder
//
//  Created by bari on 2021/12/3.
//

import UIKit
import CoreData

protocol DetailVCDelegate : NSObjectProtocol {
    func deleteApp(data: ReminderInfo)
}

class DetailVC: UIViewController {
    
    weak var delegate : DetailVCDelegate?
    
    @IBOutlet weak var DetailTitleLabel: UILabel!
    @IBOutlet weak var DetailDescriptionLabel: UILabel!
    @IBOutlet weak var DetailLeftImage: UIImageView!
    @IBOutlet weak var DetailRightImage: UIImageView!
    @IBOutlet weak var DetailPriorityLabel: UILabel!
    @IBOutlet weak var DetailPriorityValueLabel: UILabel!
    @IBOutlet weak var DetailTimeImage: UIImageView!
    @IBOutlet weak var DetailTimeLabel: UILabel!
    @IBOutlet weak var DetailLinkLabel: UILabel!
    @IBOutlet weak var DetailLinkContentLabel: UILabel!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //self.DetailLeftImage =
    }
    
    var ReminderList: [NSManagedObject] = []
    var reminderInfo : ReminderInfo?
    
    func readData() {
        let context = AppDelegate.cdContext
        let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reminder")
        do {
            ReminderList = try context.fetch(fetchRequest)
        } catch let error as NSError {
            print("Could not fetch requested item. \(error), \(error.userInfo)")
        }
    }
    
    func PriorityStar(priority: Int) -> String{
        switch priority{
        case 1:
            return "⭑"
        case 2:
            return "⭑⭑"
        case 3:
            return "⭑⭑⭑"
        case 4:
            return "⭑⭑⭑⭑"
        case 5:
            return "⭑⭑⭑⭑⭑"
        case 6:
            return "⭑⭑⭑⭑⭑⭑"
        case 7:
            return "⭑⭑⭑⭑⭑⭑⭑"
        case 8:
            return "⭑⭑⭑⭑⭑⭑⭑⭑"
        case 9:
            return "⭑⭑⭑⭑⭑⭑⭑⭑⭑"
        case 10:
            return "⭑⭑⭑⭑⭑⭑⭑⭑⭑⭑"
        default:
            return "⭑"
        }
    }
    
    func load(){
        let reminderinfo = reminderInfo
        DetailTitleLabel?.text = reminderinfo?.title
        DetailDescriptionLabel?.text = reminderinfo?.describe
        DetailPriorityValueLabel?.text = PriorityStar(priority: (reminderinfo?.priority)!)
    }
}
