//
//  ReminderCell.swift
//  Reminder
//
//  Created by bari on 2021/12/2.
//

import UIKit

class ReminderCell: UITableViewCell {
    
    @IBOutlet weak var CellTitle: UILabel!
    @IBOutlet weak var CellDate: UILabel!
    @IBOutlet weak var CellImage: UIImageView!
    @IBOutlet weak var CellPriority: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func update(with reminder: Reminder) {
        
        if let title = reminder.value(forKey: "title") as? String,
            let Date = reminder.value(forKey: "date") as? Date,
            let priority = reminder.value(forKey: "priority") as? Int,
            let categoryType = reminder.value(forKey: "category") as? Int{
            
            CellTitle?.text = title
            CellPriority?.text = PriorityStar(priority: priority)
            
            let dateFormatter = DateFormatter()
            dateFormatter.dateStyle = .short
            dateFormatter.timeStyle = .none
            CellDate?.text = dateFormatter.string(from: Date)
            
            if let Type = CategoryType(rawValue: categoryType){
                CellImage?.image = Type.getImage()
            }
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

}
