//
//  DataModel.swift
//  Check-list
//
//  Created by Kam Lotfull on 24.04.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import Foundation

class DataModel {
    var lists = [Checklist]()
    
    init() {
        loadCheckLists()
        registerDefaults() // HERE P. 197
        handleFirstTIme()
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
            sortChecklists()
        }
    }
    
    func registerDefaults() {
        let dictionary: [String: Any] = [ChecklistsIndexKey: -1,
                                         isFirstTimeKey: true,
                                         "ChecklistItemID": 0]
        UserDefaults.standard.register(defaults: dictionary)
        
    }
    var indexOfSelectedChecklist: Int {
        get {
            return UserDefaults.standard.integer(forKey: ChecklistsIndexKey)
        }
        set {
            UserDefaults.standard.set(newValue, forKey: ChecklistsIndexKey)
            UserDefaults.standard.synchronize()
        }
    }
    
    func handleFirstTIme() {
        let userDefaults = UserDefaults.standard
        let isFirstTime = userDefaults.bool(forKey: isFirstTimeKey)
        if isFirstTime {
            let checklist = Checklist(name: "First list")
            let item = ChecklistItem(text: "Write some To Do task")
            checklist.items.append(item)
            lists.append(checklist)
            indexOfSelectedChecklist = 0
            userDefaults.set(false, forKey: isFirstTimeKey)
            userDefaults.synchronize()
        }
    }
    
    func sortChecklists() {
        lists.sort(by: { list1, list2 in
        return list1.name.localizedStandardCompare(list2.name) == .orderedAscending })
    }
    
    class func nextChecklistItemID() -> Int {
        let userDefaults = UserDefaults.standard
        let itemID = userDefaults.integer(forKey: "ChecklistItemID")
        userDefaults.set(itemID + 1, forKey: "ChecklistItemID")
        userDefaults.synchronize()
        return itemID
    }
    
    let ChecklistsKey = "Checklists"
    let ChecklistsIndexKey = "ChecklistsIndex"
    let isFirstTimeKey = "FirstTime"
    
}
