//
//  ViewController.swift
//  Check-list
//
//  Created by Kam Lotfull on 15.04.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class ChecklistVC: UITableViewController, /* step 4 */ ItemDetailVCDelegate {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        /*itemsNumber = texts.count
        rowIsChecked = [Bool](repeating: false, count: itemsNumber)
        for i in 0..<itemsNumber {
            let tempItem = ChecklistItem()
            tempItem.text = texts[i]
            tempItem.checked = rowIsChecked[i]
            items.append(tempItem)
        }*/
        //checklist.items = [ChecklistItem]()
        super.init(coder: aDecoder)
        //loadChecklistItems()
        //print("DocumentsDirectory/DataFilePath: \(dataFilePath())")
    }
    
    // MARK: - ItemDetail
    func itemDetailVCDidCancel(_ controller: ItemDetailVC) {
        dismiss(animated: true, completion: nil)
    }
    func itemDetailVCDone(_ controller: ItemDetailVC, didFinishAdding item: ChecklistItem) {
        let indexPath = IndexPath(row: checklist.items.count, section: 0)
        checklist.items.append(item)
        tableView.insertRows(at: [indexPath], with: .automatic)
        dismiss(animated: true, completion: nil)
        //saveChecklistItems()
    }
    func itemDetailVCDone(_ controller: ItemDetailVC, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
            }
        }
        dismiss(animated: true, completion: nil)
        //saveChecklistItems()
    }
    
    // MARK: - TableView
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return checklist.items.count
    }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) {
            let item = checklist.items[indexPath.row]
            item.checked = !item.checked
            configureCheckmarks(for: cell, with: item)
        }
        tableView.deselectRow(at: indexPath, animated: true)
        //saveChecklistItems()
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistCell", for: indexPath)
        let textLabel = cell.viewWithTag(1000) as! UILabel
        let dateLabel = cell.viewWithTag(1002) as! UILabel
        let item = checklist.items[indexPath.row]
        textLabel.text = item.text
        dateLabel.text = item.dueDate
        configureCheckmarks(for: cell, with: item)
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
        //saveChecklistItems()
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddItem" || segue.identifier == "EditItem"),
        let navigationController = segue.destination as? UINavigationController,
        let controller = navigationController.topViewController as? ItemDetailVC {
            controller.delegate = self
            
            if segue.identifier == "EditItem",
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        } else {
            print("Error while segue.identifier == AddIten || EditItem and typecasting seque.identifier through navCon and ItemDetailVC")
        }
    }
    
    // MARK: - Configure
    func configureCheckmarks(for cell: UITableViewCell, with item: ChecklistItem) {
        let checkLabel = cell.viewWithTag(1001) as! UILabel
        checkLabel.text =  item.checked ? "🔵" : "⚪️"  //"✅" : "⭕️"
        checkLabel.textColor = view.tintColor
    }
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let label = cell.viewWithTag(1000) as! UILabel
        label.text = item.text
    }
    
    // MARK: - Variables
    var rowIsChecked = [Bool]()
    var itemsNumber = 0
    var texts = [
        "Learn Swift",
        "Do homework",
        "Call Regina",
        "Call relative",
        "Do clean up",
        "Make push-ups and chin-ups"
    ]
    let ItemsKeyName = "ChecklistItems"
    var checklist: Checklist!
}

