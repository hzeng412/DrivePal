//
//  CalendarVC.swift
//  Reminder
//
//  Created by bari on 2021/12/5.
//

import UIKit
import CoreData

class CalendarVC: UIViewController {

    @IBOutlet weak var CalendarStack: UIStackView!
    @IBOutlet var CalendarDateButton: [UIButton]!
    @IBOutlet weak var YearLabel: UILabel!
    @IBOutlet weak var MonthLabel: UILabel!
    @IBOutlet weak var CalendarRemindersLabel: UILabel!
    @IBOutlet weak var SavingsLabel: UITextField!
    @IBOutlet weak var MonthlySavingLabel: UILabel!
    @IBOutlet weak var MonthlySavingValueLabel: UILabel!
    
    let calendarHelper = CalendarHelper()
    var currentMonth = 0
    var currentYear = 0
    var buttonDate : [DateButton] = []
    var ReminderList: [NSManagedObject] = []
    let calendar = Calendar.current
    var monthlyTotal = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
        readData()
        DateColor()
        MonthlySavingValueLabel.text = String(monthlyTotal)
        // Do any additional setup after loading the view.
    }
    
    func clearButtonBorder() {
        for button in CalendarDateButton {
            button.layer.borderWidth = 0
        }
    }
    
    func resetButtonColor() {
        for button in CalendarDateButton {
            button.backgroundColor = .none
        }
    }
    
    func initialize() {
        let currentPage = calendarHelper.makeMonth(date: Date())
        currentMonth = calendarHelper.currentMonth
        currentYear = calendarHelper.currentYear
        var index = 0
        for button in CalendarDateButton{
            button.setTitle(String(currentPage[index]), for: .normal)
            if index < (calendarHelper.firstDayWeekday - 1) || index > ((calendarHelper.firstDayWeekday - 1) + calendarHelper.monthDays(month: calendarHelper.currentMonth) - 1) {
                button.tintColor = UIColor.darkGray
            } else {
                button.tintColor = UIColor.white
            }
            button.layer.cornerRadius = button.frame.width / 2
            button.clipsToBounds = true
            let buttonDay = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: currentYear, month: currentMonth, day: currentPage[index])
            let buttondate = calendar.date(from: buttonDay)
            let datebutton = DateButton()
            datebutton.date = buttondate
            datebutton.button = button
            buttonDate.append(datebutton)
            if calendar.isDateInToday(buttondate!){
                button.backgroundColor = UIColor.white
            }
            index += 1
        }
        MonthLabel.text = calendarHelper.currentMonthName
        YearLabel.text = String(calendarHelper.currentYear)
    }

    func CalendarLayOut(date: Date) {
        let currentPage = calendarHelper.makeMonth(date: date)
        CalendarRemindersLabel.text = ""
        var index = 0
        for button in CalendarDateButton{
            if index < (calendarHelper.firstDayWeekday - 1) || index > ((calendarHelper.firstDayWeekday - 1) + calendarHelper.monthDays(month: calendarHelper.currentMonth) - 1) {
                button.tintColor = UIColor.darkGray
            } else {
                button.tintColor = UIColor.white
            }
            button.setTitle(String(currentPage[index]), for: .normal)
            button.layer.cornerRadius = button.frame.width / 2
            button.clipsToBounds = true
            let buttonDay = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: currentYear, month: currentMonth, day: currentPage[index])
            let buttondate = calendar.date(from: buttonDay)
            for butt in buttonDate {
                if button == butt.button {
                    butt.date = buttondate
                    butt.reminderList.removeAll()
                    break
                }
            }
            if calendar.isDateInToday(buttondate!){
                button.backgroundColor = UIColor.white
            }
            index += 1
        }
        MonthLabel.text = calendarHelper.currentMonthName
        YearLabel.text = String(calendarHelper.currentYear)
    }

    @IBAction func OnDateButton(_ sender: Any) {
        if let senderButton = sender as? UIButton {
            for buttondate in buttonDate {
                
                if buttondate.button == senderButton {
                    clearButtonBorder()
                    var outputText = ""
                    var saving = 0
                    let dateformatter = DateFormatter()
                    
                    for rem in buttondate.reminderList {
                        dateformatter.dateStyle = .none
                        dateformatter.timeStyle = .short
                        if let date = rem.date, let title = rem.title, let savings = rem.priority, let describe = rem.describe {
                            let time = dateformatter.string(from: date)
                            let lineoutput = time + "      " + title + ":  " + describe + "\n"
                            outputText += lineoutput
                            saving = (savings%10)/2
                        }
                        CalendarRemindersLabel.numberOfLines += 1
                    }
                    if outputText.isEmpty || calendar.isDateInToday(buttondate.date!){
                        senderButton.layer.borderWidth = 2
                    } else {
                        senderButton.layer.borderColor = UIColor.white.cgColor
                        senderButton.layer.borderWidth = 2
                    }
                    //CalendarRemindersLabel.text = outputText
                    SavingsLabel.text = "save " + String(saving) + " $"
                    break
                }
                
            }
        }
    }
    
    @IBAction func OnUp(_ sender: Any) {
        clearButtonBorder()
        resetButtonColor()
        if currentMonth == 1 {
            currentYear -= 1
        }
        currentMonth = currentMonth - 1
        let lastMonDay = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: currentYear, month: currentMonth, day: 1)
        if let lastMonDate = calendar.date(from: lastMonDay) {
            CalendarLayOut(date: lastMonDate)
            readData()
            DateColor()
        }
    }
    
    @IBAction func OnDown(_ sender: Any) {
        clearButtonBorder()
        resetButtonColor()
        currentMonth = currentMonth + 1
        let nextMonDay = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: currentYear, month: currentMonth, day: 1)
        if let nextMonDate = calendar.date(from: nextMonDay) {
            CalendarLayOut(date: nextMonDate)
            readData()
            DateColor()
        }
    }
    
    func DateColor() {
        for button in buttonDate {
            if !calendar.isDateInToday(button.date!){
                if button.appCounts() > 0 {
                        button.button?.backgroundColor = UIColor.red
                    }
                else {
                        button.button?.backgroundColor = UIColor.white
                    }
                }
            }
        }
    
    func readData() {
        let context = AppDelegate.cdContext
            let fetchRequest = NSFetchRequest<NSManagedObject>(entityName: "Reminder")
            do {
                ReminderList = try context.fetch(fetchRequest)
            } catch let error as NSError {
                print("Could not fetch requested item. \(error), \(error.userInfo)")
            }
        
        for reminder in ReminderList {
            let reminderinfo = ReminderInfo()
            if let title = reminder.value(forKey: "title") as? String,
                let describe = reminder.value(forKey: "describe") as? String,
                let priority = reminder.value(forKey: "priority") as? Int,
                let date = reminder.value(forKey: "date") as? Date,
                let link = reminder.value(forKey: "link") as? String,
                let category = reminder.value(forKey: "category") as? Int{
                
                reminderinfo.title = title
                reminderinfo.describe = describe
                reminderinfo.priority = priority
                reminderinfo.date = date
                reminderinfo.category = category
                reminderinfo.url = link
                
                monthlyTotal += (priority%10)/2
            }
            
            for datebutton in buttonDate {
                let diff = calendar.dateComponents([.day], from: datebutton.date!, to: reminderinfo.date!)
                if  diff.day == 0{
                    datebutton.addApplication(application: reminderinfo)
                    break
                }
            }
        }
        
    }

}
