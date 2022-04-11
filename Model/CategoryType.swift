//
//  CategoryType.swift
//  Reminder
//
//  Created by bari on 2021/12/2.
//

import Foundation
import UIKit

enum CategoryType: Int, CaseIterable{
    case Excellent, Good, Average, Fair, Poor
    
    func getValue() -> String {
        switch self{
        case .Excellent:
            return "Excellent"
        case .Good:
            return "Good"
        case .Average:
            return "Average"
        case .Fair:
            return "Fair"
        case .Poor:
            return "Poor"
        }
    }
    
    func getImage() -> UIImage? {
        switch self{
        case .Excellent:
            return UIImage(named: "report1")
        case .Good:
            return UIImage(named: "report1")
        case .Average:
            return UIImage(named: "report1")
        case .Fair:
            return UIImage(named: "report1")
        case .Poor:
            return UIImage(named: "report1")
        }
    }
}
