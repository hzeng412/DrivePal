//
//  SettingVC.swift
//  Reminder
//
//  Created by bari on 2021/12/4.
//

import UIKit

protocol SettingVCDelegate : NSObjectProtocol {
    //func passBackToTableView(data: Theme)
    func GroupByCategoryToTableview()
    func SortByPriorityToTableview()
}

class SettingVC: UIViewController {

    
    @IBOutlet weak var SettingGroupLabel: UILabel!
    @IBOutlet weak var SettingGroupSwitch: UISwitch!
    @IBOutlet weak var SettingPriorityLabel: UILabel!
    @IBOutlet weak var SettingPrioritySwitch: UISwitch!
    
    var GroupByCategory : Bool?
    var SortByPriority : Bool?
    weak var delegate : SettingVCDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        if SortByPriority! {
            SettingPrioritySwitch.setOn(true, animated: true)
        } else {
             SettingPrioritySwitch.setOn(false, animated: true)
        }
        
        if GroupByCategory! {
            SettingGroupSwitch.setOn(true, animated: true)
        } else {
            SettingGroupSwitch.setOn(false, animated: true)
        }
        SettingGroupLabel.text = NSLocalizedString("str_GroupByCategory", comment: "")
        SettingPriorityLabel.text = NSLocalizedString("str_SortByUrgency", comment: "")
    }
    
    func turnOnSortByPriority() {
        SettingPrioritySwitch.setOn(true, animated: true)
        SortByPriority = true
        delegate?.SortByPriorityToTableview()
    }
    
    func turnOffSortByPriority() {
        SettingPrioritySwitch.setOn(false, animated: true)
        SortByPriority = false
    }
    
    func turnOnGroupByCategory() {
        SettingGroupSwitch.setOn(true, animated: true)
        GroupByCategory = true
        delegate?.GroupByCategoryToTableview()
    }
    
    func turnOffGroupByCategory() {
        SettingGroupSwitch.setOn(false, animated: true)
        GroupByCategory = false
    }
    
    @IBAction func OnChangeGroup(_ sender: Any) {
        if GroupByCategory == false {
            if SettingPrioritySwitch.isOn {
                turnOffSortByPriority()
            }
            turnOnGroupByCategory()
        } else {
            turnOffGroupByCategory()
        }
    }
    
    @IBAction func OnChangePriority(_ sender: Any) {
        if SortByPriority == false {
            if SettingGroupSwitch.isOn {
                turnOffGroupByCategory()
            }
            turnOnSortByPriority()
        } else {
            turnOffSortByPriority()
        }
    }
    
    

}
