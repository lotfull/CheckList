//
//  AllListsVC.swift
//  Check-list
//
//  Created by Kam Lotfull on 19.04.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class AllListsVC: UITableViewController, AddChecklistVCDelegate, UINavigationControllerDelegate {
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        navigationController?.delegate = self
        let index = dataModel.indexOfSelectedChecklist
        if index >= 0 && index < dataModel.lists.count {
            let checklist = dataModel.lists[index]
            performSegue(withIdentifier: ShowChecklistSequeID, sender: checklist)
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        tableView.reloadData()
    }
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dataModel.lists.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = makeCell(for: tableView)
        let checklist = dataModel.lists[indexPath.row]
        let uncheckedItemsCount = checklist.countUncheckedItems()
        cell.textLabel!.text = checklist.name
        cell.detailTextLabel!.text = (checklist.items.count == 0) ? "Empty" : (uncheckedItemsCount != 0) ? "\(uncheckedItemsCount) Remaining" : "All Done!"
        cell.accessoryType = .detailDisclosureButton
        cell.imageView!.image = UIImage(named: checklist.iconName)
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        dataModel.indexOfSelectedChecklist = indexPath.row
        let checklist = dataModel.lists[indexPath.row]
        performSegue(withIdentifier: ShowChecklistSequeID, sender: checklist)
    }
    
    func makeCell(for tableView: UITableView) -> UITableViewCell {
        let cellIdentifier = "Cell"
        if let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier) {
            return cell
        } else {
            return UITableViewCell(style: .subtitle, reuseIdentifier: cellIdentifier)
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == ShowChecklistSequeID,
        let controller = segue.destination as? ChecklistVC {
            controller.checklist = sender as! Checklist
        } else if segue.identifier == AddChecklistSequeID,
        let navigationController = segue.destination as? UINavigationController,
        let controller = navigationController.topViewController as? AddChecklistVC {
            controller.delegate = self
            controller.checklistToEdit = nil
        } else { print("prepare for show checklist seque error") }
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        dataModel.lists.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    func addChecklistVCDidCancel(_ controller: AddChecklistVC) {
        dismiss(animated: true, completion: nil)
    }
    
    func addChecklistVCDone(_ controller: AddChecklistVC, didFinishAdding list: Checklist) {
        dataModel.lists.append(list)
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    func addChecklistVCDone(_ controller: AddChecklistVC, didFinishEditing list: Checklist) {
        dataModel.sortChecklists()
        tableView.reloadData()
        dismiss(animated: true, completion: nil)
    }
    
    override func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        if let navigationController = storyboard!.instantiateViewController(withIdentifier: "AddChecklistNavigationC") as? UINavigationController,
        let addChecklistController = navigationController.topViewController as? AddChecklistVC {
            addChecklistController.delegate = self
            let checklist = dataModel.lists[indexPath.row]
            addChecklistController.checklistToEdit = checklist
            present(navigationController, animated: true, completion: nil)
        } else { print("Some error with tableView(accessoryButtonTappedForRowWith)") }
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if viewController === self {
            dataModel.indexOfSelectedChecklist = -1
        }
    }
    
    var dataModel: DataModel!
    let ShowChecklistSequeID = "ShowChecklist"
    let AddChecklistSequeID = "AddChecklist"
    let ChecklistIndexKey = "ChecklistIndex"
    
}
