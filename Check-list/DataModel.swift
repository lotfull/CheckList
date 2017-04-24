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
