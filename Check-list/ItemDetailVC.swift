//
//  ItemDetailVC.swift
//  Check-list
//
//  Created by Kam Lotfull on 16.04.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
import UserNotifications
// step 1
protocol ItemDetailVCDelegate: class {
    func itemDetailVCDidCancel(_ controller: ItemDetailVC)
    func itemDetailVCDone(_ controller: ItemDetailVC, didFinishAdding item: ChecklistItem)
    func itemDetailVCDone(_ controller: ItemDetailVC, didFinishEditing item: ChecklistItem)
}

class ItemDetailVC: UITableViewController, UITextViewDelegate {
    
    @IBOutlet weak var textField: UITextField!
    @IBOutlet weak var doneButton: UIBarButtonItem!
    @IBOutlet weak var dueDateLabel: UILabel!
    @IBOutlet weak var shouldRemindSwitch: UISwitch!
    @IBOutlet var datePickerCell: UITableViewCell!
    @IBOutlet weak var datePicker: UIDatePicker!

    weak var delegate: ItemDetailVCDelegate?

    var itemToEdit: ChecklistItem?
    var visible = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneButton.isEnabled = true
            shouldRemindSwitch.isOn = item.shouldRemind
            dueDate = item.dueDate
        }
        updateDueDateLabel()
    }
    
    @IBAction func cancel(_ sender: Any) {
        delegate?.itemDetailVCDidCancel(self)
    }

    @IBAction func done(_ sender: Any) {
        if let item = itemToEdit {
            item.text = textField.text!
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.itemDetailVCDone(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            item.shouldRemind = shouldRemindSwitch.isOn
            item.dueDate = dueDate
            item.scheduleNotification()
            delegate?.itemDetailVCDone(self, didFinishAdding: item)
        }
    }
    
    @IBAction func dateChanged(_ datePicker: UIDatePicker) {
        dueDate = datePicker.date
        updateDueDateLabel()
    }
    @IBAction func remindSwitchChanged(_ switcher: UISwitch) {
        textField.resignFirstResponder()
        
        if switcher.isOn {
            ShowDatePicker()
            let center = UNUserNotificationCenter.current()
            center.requestAuthorization(options: [.alert, .sound]) {
                granted, error in /* do nothing*/
            }
        } else {
            HideDatePicker()
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        if indexPath.section == 1, indexPath.row == 1 {
            return indexPath
        } else {
            return nil
        }
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textField.becomeFirstResponder()
    }
    
    func textField(_ textField: UITextField, shouldChangeCharactersInRange range: NSRange,
                   replacementString string: String) -> Bool {
        let oldText = textField.text! as NSString
        let newText = oldText.replacingCharacters(in: range, with: string) as NSString
        doneButton.isEnabled = (newText.length > 0)
        return true
    }
    
    func updateDueDateLabel() {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dueDateLabel.text = formatter.string(from: dueDate)
    }
    
    func ShowDatePicker() {
        if !datePickerVisible {
            datePickerVisible = true
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            tableView.insertRows(at: [indexPathDatePicker], with: .fade)
            datePicker.setDate(dueDate, animated: false)
        }
    }
    
    func HideDatePicker() {
        if datePickerVisible {
            datePickerVisible = false
            let indexPathDatePicker = IndexPath(row: 2, section: 1)
            let indexPathDateRow = IndexPath(row: 1, section: 1)
            if let cell = tableView.cellForRow(at: indexPathDateRow) {
                cell.detailTextLabel!.textColor = UIColor(white: 0, alpha: 0.5)
            }
            tableView.beginUpdates()
            tableView.reloadRows(at: [indexPathDateRow], with: .none)
            tableView.deleteRows(at: [indexPathDatePicker], with: .fade)
            tableView.endUpdates()
        }
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 1,
            indexPath.row == 2 {
            return datePickerCell
        } else {
            return super.tableView(tableView, cellForRowAt: indexPath)
        }
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 1,
        datePickerVisible {
            return 3
        } else {
            return super.tableView(tableView, numberOfRowsInSection: section)
        }
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if indexPath.section == 1,
            indexPath.row == 2 {
            return 217
        } else {
            return super.tableView(tableView, heightForRowAt: indexPath)
        }
    }

    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        textField.resignFirstResponder()
        if indexPath.row == 1, indexPath.section == 1 {
            if datePickerVisible {
                HideDatePicker()
            } else {
                ShowDatePicker()
            }
        }
    }
    
    override func tableView(_ tableView: UITableView, indentationLevelForRowAt indexPath: IndexPath) -> Int {
        if indexPath.row == 2, indexPath.section == 1 {
            let newIndexPath = IndexPath(row: 0, section: indexPath.section)
            return super.tableView(tableView, indentationLevelForRowAt: newIndexPath)
        }
        return super.tableView(tableView, indentationLevelForRowAt: indexPath)
    }
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        HideDatePicker()
    }
    
    
    
    var dueDate = Date()
    var datePickerVisible = false
    
    
    
    
    
    
    
    
    
    
    
    
}
