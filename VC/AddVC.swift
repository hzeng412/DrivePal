//
//  AddVC.swift
//  Reminder
//
//  Created by bari on 2021/12/2.
//

import UIKit
import CoreData

class AddVC: UIViewController {
    
    @IBOutlet weak var ReminderTitleLabel: UILabel!
    @IBOutlet weak var ReminderTextField: UITextField!
    @IBOutlet weak var ReminderDescriptionLabel: UILabel!
    @IBOutlet weak var ReminderDescriptionTextField: UITextField!
    @IBOutlet weak var DateLabel: UILabel!
    @IBOutlet weak var DatePicker: UIDatePicker!
    @IBOutlet weak var CategoryLabel: UILabel!
    @IBOutlet weak var CategoryPicker: UIPickerView!
    @IBOutlet weak var URLLabel: UILabel!
    @IBOutlet weak var URLTextField: UITextField!
    @IBOutlet weak var CancelButton: UIButton!
    @IBOutlet weak var PriorityLabel: UILabel!
    @IBOutlet weak var SaveButton: UIButton!
    @IBOutlet weak var PriorityValue: UITextField!
    
    var priority = 0 {
        willSet{
            PriorityValue?.text = newValue.description
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        ReminderTitleLabel.text = NSLocalizedString("str_AddVCTitle", comment: "")
        ReminderDescriptionLabel.text = NSLocalizedString("str_AddVCDescription", comment: "")
        DateLabel.text = NSLocalizedString("str_AddVCDate", comment: "")
        CategoryLabel.text = NSLocalizedString("str_AddVCCategory", comment: "")
        URLLabel.text = NSLocalizedString("str_AddVCURL", comment: "")
        CancelButton.setTitle(NSLocalizedString("str_AddVCCancel", comment: ""), for: .normal)
        SaveButton.setTitle(NSLocalizedString("str_AddVCSave", comment: ""), for: .normal)
        PriorityLabel.text = NSLocalizedString("str_AddVCUrgency", comment: "")
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        view.endEditing(true)
    }
    
    func saveItem(title: String, description: String, URL : String, Score : String) {
        let context = AppDelegate.cdContext
        if let entity = NSEntityDescription.entity(forEntityName: "Reminder", in: context) {
            print("Yeah1")
            let item = NSManagedObject(entity: entity, insertInto: context)
            item.setValue(title, forKeyPath: "title")
            item.setValue(description, forKeyPath: "describe")
            item.setValue(URL, forKeyPath: "link")
            item.setValue(DatePicker.date, forKey: "date")
            item.setValue(CategoryPicker.selectedRow(inComponent: 0), forKeyPath: "category")
            item.setValue(Int(Score), forKeyPath: "priority")
            do {
                try context.save()
            } catch let error as NSError {
                print("Could not save the item. \(error), \(error.userInfo)")
            }
        }
    }
    
    @IBAction func OnSave(_ sender: Any) {
        print("yeah2")
        if let title = ReminderTextField?.text,
           let description = ReminderDescriptionTextField?.text,
           let score = PriorityValue?.text,
           let URL = URLTextField?.text{
            saveItem(title: title, description: description, URL: URL, Score: score)
        }
        presentingViewController?.dismiss(animated: true)
    }
    
    
    @IBAction func OnCancel(_ sender: Any) {
        presentingViewController?.dismiss(animated: true)
    }
    
}

    extension AddVC: UIPickerViewDataSource, UIPickerViewDelegate{
    
        func numberOfComponents(in pickerView: UIPickerView) -> Int {
            return 1
        }
    
        func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
            return CategoryType.allCases.count
        }
    
        func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent  component: Int) -> String? {
            return CategoryType(rawValue: row)?.getValue()
        }
    }

