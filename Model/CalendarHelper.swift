//
//  Calendar.swift
//  Reminder
//
//  Created by bari on 2021/12/5.
//

import Foundation

class CalendarHelper {
    
    let daysInMonth = [-1, 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    let daysInMonthLeap = [-1, 31, 29, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31]
    let monthName = [NSLocalizedString("str_Jan", comment: ""), NSLocalizedString("str_Feb", comment: ""), NSLocalizedString("str_Mar", comment: ""), NSLocalizedString("str_Apr", comment: ""), NSLocalizedString("str_May", comment: ""), NSLocalizedString("str_Jun", comment: ""), NSLocalizedString("str_Jul", comment: ""), NSLocalizedString("str_Aug", comment: ""), NSLocalizedString("str_Sep", comment: ""), NSLocalizedString("str_Oct", comment: ""), NSLocalizedString("str_Nov", comment: ""), NSLocalizedString("str_Dec", comment: "")]
    
    let weekdays = 7
    let dateButtons = 42
    var leapYear = false
    var currentMonth = 0
    var currentMonthName = ""
    var currentYear = 0
    
    var firstDayWeekday = 0
    
    
    func makeMonth(date: Date) -> [Int] {
        
        var thisPage = [Int]()
        
        let calendar = Calendar.current
        var componenets = calendar.dateComponents([.month], from: date)
        let month = componenets.month
        currentMonth = month ?? 0
        currentMonthName = monthName[currentMonth-1]
        let thisMonthDays = monthDays(month: month ?? 0)
        var lastMonth = -1
        if month == 1 {
            lastMonth = 12
        } else {
            lastMonth = month! - 1
        }
        let lastMonthDays = monthDays(month: lastMonth)
        
        componenets = calendar.dateComponents([.year], from: date)
        let year = componenets.year
        currentYear = year ?? 0
        
        let firstDay = DateComponents(calendar: Calendar.current, timeZone: TimeZone.current, year: year, month: month, day: 1)
        let firstDate = calendar.date(from: firstDay)
        componenets = calendar.dateComponents([.weekday], from: firstDate!)
        // 1 for sunday, 7 for saturday
        let firstDayWeek = componenets.weekday
        firstDayWeekday = firstDayWeek!
        var day = 1
        var tempFirstWeekday = firstDayWeek! - 2
        for i in 1...42 {
            if i < firstDayWeek! {
                thisPage.append(lastMonthDays - tempFirstWeekday)
                tempFirstWeekday -= 1
                day -= 1
            } else if day > thisMonthDays{
                thisPage.append(day - thisMonthDays)
            } else {
                thisPage.append(day)
            }
            day += 1
        }
        
        return thisPage
    }
    
    func monthDays(month: Int) -> Int {
        if month != 2 && !leapYear {
            return daysInMonth[month]
        }else {
            if leapYear {
                return 29
            } else {
                return daysInMonth[month]
            }
        }
    }
    
}
