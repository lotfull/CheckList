//
//  AllListsVC.swift
//  Check-list
//
//  Created by Kam Lotfull on 19.04.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class AllListsVC: UITableViewController, ListDetailVCDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        /*
        var list = Checklist(name: "Bitch")
        var item = ChecklistItem()
        item.text = "Fuck"
        list.items.append(item)
        lists.append(list)
        saveChecklists()*/
        loadCheckLists()
    }

    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = makeCell(for: tableView)
        let checklist = lists[indexPath.row]
        cell.textLabel!.text = checklist.name
        cell.accessoryType = .detailDisclosureButton
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let checklist = lists[indexPath.row]
        performSegue(withIdentifier: showChecklistSequeID, sender: checklist)
    }
    
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .default, reuseIdentifier: cellIdentifier)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == showChecklistSequeID,
        let controller = segue.destination as? ChecklistVC {
            controller.checklist = sender as! Checklist
        } else if segue.identifier == addChecklistSequeID,
        let navigationController = segue.destination as? UINavigationController,
        let controller = navigationController.topViewController as? ListDetailVC {
            controller.delegate = self
            controller.checklistToEdit = nil
        } else { print("prepare for show checklist seque error") }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        lists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    var lists: [Checklist] = []
    var listNames = [
        "Swift",
        "Groceries",
        "Homework",
        "To do",
        "Others"
    ]
    let showChecklistSequeID = "ShowChecklist"
    let addChecklistSequeID = "AddChecklist"
    
    func listDetailVCDidCancel(_ controller: ListDetailVC) {
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailVCDone(_ controller: ListDetailVC, didFinishAdding list: Checklist) {
        let indexPath = IndexPath(row: lists.count, section: 0)
        lists.append(list)
        tableView.insertRows(at: [indexPath], with: .automatic)
        dismiss(animated: true, completion: nil)
    }
    
    func listDetailVCDone(_ controller: ListDetailVC, didFinishEditing list: Checklist) {
        if let index = lists.index(of: list) {
            let indexPath = IndexPath(row: index, section: 0)
            if let cell = tableView.cellForRow(at: indexPath) {
                cell.textLabel!.text = list.name
            }
        }
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let navigationController = storyboard!.instantiateViewController(withIdentifier: "ListDetailNavigationC") as? UINavigationController,
        let listDetailController = navigationController.topViewController as? ListDetailVC {
            listDetailController.delegate = self
            let checklist = lists[indexPath.row]
            listDetailController.checklistToEdit = checklist
            present(navigationController, animated: true, completion: nil)
        } else { print("Some error with tableView(accessoryButtonTappedForRowWith)") }
    }
    
    // MARK: - Saving Data

    func documentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
    func dataFilePath() -> URL {
        return documentsDirectory().appendingPathComponent("Checklists.plist")
    }
    func saveChecklists() {
        let data = NSMutableData()
        let archiver = NSKeyedArchiver(forWritingWith: data)
        archiver.encode(lists, forKey: ChecklistsKey)
        archiver.finishEncoding()
        data.write(to: dataFilePath(), atomically: true)
    }
    func loadCheckLists() {
        let path = dataFilePath()
        if let data = try? Data(contentsOf: path) {
            let  unarchiver = NSKeyedUnarchiver(forReadingWith: data)
            lists = unarchiver.decodeObject(forKey: ChecklistsKey) as! [Checklist]
            unarchiver.finishDecoding()
        }
    }
    
    let ChecklistsKey = "Checklists"
    
}
