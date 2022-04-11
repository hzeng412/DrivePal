//
//  DateButton.swift
//  Reminder
//
//  Created by bari on 2021/12/5.
//

import Foundation
import UIKit

class DateButton {
    
    var reminderList : [ReminderInfo] = []
    var date : Date?
    var button : UIButton?
    
    func addApplication(application: ReminderInfo) {
        reminderList.append(application)
    }
    
    func appCounts() -> Int {
        reminderList.count
    }
    
}
