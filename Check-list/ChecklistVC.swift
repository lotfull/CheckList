//
//  ViewController.swift
//  Check-list
//
//  Created by Kam Lotfull on 15.04.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class ChecklistVC: UITableViewController, /* step 4 */ AddItemVCDelegate {
    
    func addItemVCDidCancel(_ controller: AddItemVC) {
        dismiss(animated: true, completion: nil)
    }
    
    func addItemVCDone(_ controller: AddItemVC, didFinishAdding item: ChecklistItem) {
        let indexPath = IndexPath(row: items.count, section: 0)
        items.append(item)
        tableView.insertRows(at: [indexPath], with: .automatic)
        dismiss(animated: true, completion: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        itemsNumber = texts.count
        rowIsChecked = [Bool](repeating: false, count: itemsNumber)
        for i in 0..<itemsNumber {
            let tempItem = ChecklistItem()
            tempItem.text = texts[i]
            tempItem.checked = rowIsChecked[i]
            items.append(tempItem)
        }
        super.init(coder: aDecoder)
    }
    
    var rowIsChecked = [Bool]()
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    var itemsNumber = 0
    var items: [ChecklistItem] = []
    var texts = [
        "Learn Swift",
        "Do homework",
        "Call Regina",
        "Call relative",
        "Do clean up",
        "Make push-ups and chin-ups"
    ]
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    
    func configureCheckmarks(for cell: UITableViewCell, at indexPath: IndexPath) {
        cell.accessoryType = items[indexPath.row].checked ? .checkmark : .none
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = items[indexPath.row]
            item.checked = !item.checked
            configureCheckmarks(for: cell, at: indexPath)
        }
        tableView.deselectRow(at: indexPath, animated: true)
    }
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistCell", for: indexPath)
        let label = cell.viewWithTag(1000) as! UILabel
        let item = items[indexPath.row]
        label.text = item.text
        configureCheckmarks(for: cell, at: indexPath)
        return cell
    }
    
    override func tableView(_ tableView: UITableView,
                            commit editingStyle: UITableViewCellEditingStyle,
                            forRowAt indexPath: IndexPath) {
        
        items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "Additem",
        let navigationController = segue.destination as? UINavigationController,
        let controller = navigationController.topViewController as? AddItemVC {
            controller.delegate = self
        }
    }
}

