//
//  ViewController.swift
//  Check-list
//
//  Created by Kam Lotfull on 15.04.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class ChecklistVC: UITableViewController, AddItemVCDelegate {
   
    override func viewDidLoad() {
        super.viewDidLoad()
        title = checklist.name
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - AddItem
    func addItemVCDidCancel(_ controller: AddItemVC) {
        dismiss(animated: true, completion: nil)
    }
    func addItemVCDone(_ controller: AddItemVC, didFinishAdding item: ChecklistItem) {
        let indexPath = IndexPath(row: checklist.items.count, section: 0)
        checklist.items.append(item)
        tableView.insertRows(at: [indexPath], with: .automatic)
        configureDateLabel(for: tableView.cellForRow(at: indexPath)!, with: item)
        changeSortType()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    func sortItems(by sortType: String) {
        if sortType == ByDate {
            checklist.items.sort(by: {
                item1, item2 in
                return item1.dueDate.compare(item2.dueDate) == .orderedAscending
            })
        } else {
            checklist.items.sort(by: {
                item1, item2 in
                return item1.text.localizedStandardCompare(item2.text) == .orderedAscending
            })
        }
    }
    func addItemVCDone(_ controller: AddItemVC, didFinishEditing item: ChecklistItem) {
        if let index = checklist.items.index(of: item) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                configureText(for: cell, with: item)
                configureDateLabel(for: cell, with: item)
                changeSortType()
                tableView.reloadData()
            }
        }
        dismiss(animated: true, completion: nil)
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
    }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ChecklistCell", for: indexPath)
        let item = checklist.items[indexPath.row]
        configureText(for: cell, with: item)
        configureCheckmarks(for: cell, with: item)
        configureDateLabel(for: cell, with: item)
        return cell
    }
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        checklist.items.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if (segue.identifier == "AddItem" || segue.identifier == "EditItem"),
        let navigationController = segue.destination as? UINavigationController,
        let controller = navigationController.topViewController as? AddItemVC {
            controller.delegate = self
            
            if segue.identifier == "EditItem",
            let indexPath = tableView.indexPath(for: sender as! UITableViewCell) {
                controller.itemToEdit = checklist.items[indexPath.row]
            }
        } else {
            print("Error while segue.identifier == AddIten || EditItem and typecasting seque.identifier through navCon and AddItemVC")
        }
    }
    
    // MARK: - Configure
    func configureDateLabel(for cell: UITableViewCell, with item: ChecklistItem) {
        let dateLabel = cell.viewWithTag(1002) as! UILabel
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        dateLabel.text = formatter.string(from: item.dueDate)
        dateLabel.isHidden = !item.shouldRemind
    }
    func configureCheckmarks(for cell: UITableViewCell, with item: ChecklistItem) {
        let checkLabel = cell.viewWithTag(1001) as! UILabel
        checkLabel.text =  item.checked ? "◉" : "◎"  //"✅" : "⭕️"
        checkLabel.textColor = view.tintColor
    }
    func configureText(for cell: UITableViewCell, with item: ChecklistItem) {
        let textlabel = cell.viewWithTag(1000) as! UILabel
        textlabel.text = item.text
    }
    
    @IBAction func sortButtonPressed(_ sender: UIBarButtonItem) {
        changeSortType()
        tableView.reloadData()
    }
    func changeSortType() {
        checklist.sortType = (checklist.sortType == ByDate) ? ByText : ByDate
        sortItems(by: checklist.sortType)
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
    let ByDate = "byDate"
    let ByText = "byText"
}

