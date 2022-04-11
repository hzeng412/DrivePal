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
    @IBOutlet weak var DetailLinkContentButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        DetailPriorityLabel.text = NSLocalizedString("str_DetailVCUrgency", comment: "")
        DetailLinkLabel.text = NSLocalizedString("str_DetailVCLink", comment: "")
        load()
        matchAnimation()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let priority = self.reminderInfo?.priority ?? 1
        self.DetailPriorityValueLabel.text = String(priority)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        UIView.transition(with: self.DetailTimeImage, duration: 3, options: .transitionCrossDissolve, animations: {
            self.DetailTimeImage.image = UIImage(named: "Time")
        }, completion: nil)
    }

    
    var reminderInfo : ReminderInfo?

//    func PriorityStar(priority: Int) -> String{
//        switch priority{
//        case 1:
//            return "⭑"
//        case 2:
//            return "⭑⭑"
//        case 3:
//            return "⭑⭑⭑"
//        case 4:
//            return "⭑⭑⭑⭑"
//        case 5:
//            return "⭑⭑⭑⭑⭑"
//        case 6:
//            return "⭑⭑⭑⭑⭑⭑"
//        case 7:
//            return "⭑⭑⭑⭑⭑⭑⭑"
//        case 8:
//            return "⭑⭑⭑⭑⭑⭑⭑⭑"
//        case 9:
//            return "⭑⭑⭑⭑⭑⭑⭑⭑⭑"
//        case 10:
//            return "⭑⭑⭑⭑⭑⭑⭑⭑⭑⭑"
//        default:
//            return "⭑"
//        }
//    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.destination is WebVC {
            let vc = segue.destination as? WebVC
            vc?.address = sender as? String ?? "http://google.com"
        }
        if segue.destination is CalendarVC {
            let vc = segue.destination as? CalendarVC
        }
    }

    func matchAnimation(){
        UIView.animate(withDuration: 2, animations: {
            
        }, completion: { _ in
            UIView.animate(withDuration: 1, animations: {
                self.DetailLeftImage?.center.x -= 50
                self.DetailRightImage?.center.x += 50
            },completion:{ _ in
                UIView.animate(withDuration: 1, animations:{
                    self.DetailLeftImage?.center.x += 50
                    self.DetailRightImage?.center.x -= 50
                
            })
            })
        })
    }
    
    
    @IBAction func OnGesture(_ sender: UISwipeGestureRecognizer) {
        switch sender.direction {
        case .up:
            performSegue(withIdentifier: "ToCalendarVC", sender: self)
        default:
            break
        }
    }
    
    func load(){
        let reminderinfo = reminderInfo
        let category = (reminderinfo?.category as Int?)!
        DetailTitleLabel?.text = reminderinfo?.title
        DetailDescriptionLabel?.text = reminderinfo?.describe
        //DetailPriorityValueLabel?.text = priorityStar
        DetailDescriptionLabel?.text = reminderinfo?.describe
        DetailLeftImage?.image =  CategoryType(rawValue: category)?.getImage()
        DetailRightImage?.image =  CategoryType(rawValue: category)?.getImage()
        //DetailTimeImage?.image = UIImage(named: "Time")
        
        let dateformatter = DateFormatter()
        if let date = reminderinfo?.date{
            dateformatter.dateStyle = .medium
            dateformatter.timeStyle = .none
            let dueDate = dateformatter.string(from: date)
            
            dateformatter.dateStyle = .none
            dateformatter.timeStyle = .short
            let dueTime = dateformatter.string(from: date)
            
            let weekday = Calendar.current.component(.weekday, from: date)
            let weekdayStr = dateformatter.weekdaySymbols[weekday-1]
            
    
            DetailTimeLabel?.text = dueDate + "\n" + weekdayStr + "\n" + dueTime
            
            DetailLinkContentButton?.setTitle(reminderinfo?.url, for: .normal)
        }

    }
    
    func deletionAlert(completion: @escaping (UIAlertAction) -> Void) {
        
        let alertMsg = NSLocalizedString("str_deleteMessage", comment: "")
        let alert = UIAlertController(title: NSLocalizedString("str_warning", comment: ""), message: alertMsg, preferredStyle: .actionSheet)
        
        let deleteAction = UIAlertAction(title: NSLocalizedString("str_delete", comment: ""), style: .destructive, handler: completion)
        let cancelAction = UIAlertAction(title: NSLocalizedString("str_cancel", comment: ""), style: .cancel, handler:nil)
        
        alert.addAction(cancelAction)
        alert.addAction(deleteAction)
        
        alert.popoverPresentationController?.permittedArrowDirections = []
        alert.popoverPresentationController?.sourceView = self.view
        alert.popoverPresentationController?.sourceRect = CGRect(x: self.view.frame.midX, y: self.view.frame.midY, width: 0, height: 0)
        
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func OnTrash(_ sender: Any) {
        deletionAlert(){ _ in
            self.delegate?.deleteApp(data: self.reminderInfo ?? ReminderInfo())
            let storyboard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)

            let vc = storyboard.instantiateViewController(withIdentifier: "TableVC") as! UITableViewController

            self.navigationController?.pushViewController(vc, animated: true)
        }
    }
    
    func CheckLink (url: String?) -> Bool {
        if let link = url {
            if let url = NSURL(string: link) {
                if UIApplication.shared.canOpenURL(url as URL) {
                    return true
                } else {
                    return false
                }
            }
        }
        return false
    }
    
    @IBAction func OnLink(_ sender: Any) {
        if let address = reminderInfo?.url{
            if !address.isEmpty {
                let index = address.firstIndex(of: ":") ?? address.endIndex
                let beg = address[..<index]
                let front = String(beg)
                if CheckLink(url: address) && front == "https" {
                    performSegue(withIdentifier: "ToWebVC", sender: address)
                }else {
                    let alert = UIAlertController(title: NSLocalizedString("str_DetailVCWarning", comment: ""), message: NSLocalizedString("str_DetailVCWrongLink", comment: ""), preferredStyle: .alert)
                    let ok = UIAlertAction(title: NSLocalizedString("str_DetailVCCancel", comment: ""), style: .cancel)
                    alert.addAction(ok)
                    present(alert, animated: true)
                }
                
            } else {
                let alert = UIAlertController(title: NSLocalizedString("str_DetailVCWarning", comment: ""), message: NSLocalizedString("str_DetailVCBlankURL", comment: ""), preferredStyle: .alert)
                let ok = UIAlertAction(title: "Cancel", style: .cancel)
                alert.addAction(ok)
                present(alert, animated: true)
            }
        }
    }
    

    
}
