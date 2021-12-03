//
//  CategoryType.swift
//  Reminder
//
//  Created by bari on 2021/12/2.
//

import Foundation
import UIKit

enum CategoryType: Int, CaseIterable{
    case Job, DailyLife, Study, Travel, Habit
    
    func getValue() -> String {
        switch self{
        case .Job:
            return "Job"
        case .DailyLife:
            return "DailyLife"
        case .Study:
            return "Study"
        case .Travel:
            return "Travel"
        case .Habit:
            return "Habit"
        }
    }
    
    func getImage() -> UIImage? {
        switch self{
        case .Job:
            return UIImage(named: "Job")
        case .DailyLife:
            return UIImage(named: "DailyLife")
        case .Study:
            return UIImage(named: "Study")
        case .Travel:
            return UIImage(named: "Travel")
        case .Habit:
            return UIImage(named: "Habit")
        }
    }
}
