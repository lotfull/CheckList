//
//  ItemDetailVC.swift
//  Check-list
//
//  Created by Kam Lotfull on 16.04.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit
// step 1
protocol ItemDetailVCDelegate: class {
    func itemDetailVCDidCancel(_ controller: ItemDetailVC)
    func itemDetailVCDone(_ controller: ItemDetailVC, didFinishAdding item: ChecklistItem)
    func itemDetailVCDone(_ controller: ItemDetailVC, didFinishEditing item: ChecklistItem)
}

class ItemDetailVC: UITableViewController, UITextViewDelegate {
    // step 2
    weak var delegate: ItemDetailVCDelegate?
    
    var itemToEdit: ChecklistItem?
    
    @IBOutlet weak var doneButton: UIBarButtonItem!
    // step 3
    @IBAction func cancel(_ sender: Any) { // when the user taps the Cancel button - i send the itemDetailVCDidCancel() message back to the delegate
        delegate?.itemDetailVCDidCancel(self)
    }
    // step 3 ✅☑️
    @IBAction func done(_ sender: Any) {
        if let item = itemToEdit {
            item.text = textField.text!
            delegate?.itemDetailVCDone(self, didFinishEditing: item)
        } else {
            let item = ChecklistItem()
            item.text = textField.text!
            item.checked = false
            delegate?.itemDetailVCDone(self, didFinishAdding: item)
        }
    }
    
    override func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        return nil
    }
    
    @IBOutlet weak var textField: UITextField!
    
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
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let item = itemToEdit {
            title = "Edit Item"
            textField.text = item.text
            doneButton.isEnabled = true
        }
    }
    
    
    
    
    
    
    
    
    
    
    
}
