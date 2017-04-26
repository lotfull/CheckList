//
//  Checklist.swift
//  Check-list
//
//  Created by Kam Lotfull on 19.04.17.
//  Copyright © 2017 Kam Lotfull. All rights reserved.
//

import UIKit

class Checklist: NSObject, NSCoding {
    var name = ""
    var items = [ChecklistItem]()
    var iconName: String
    var sortType = "ByDate"
    
    let NameKey = "Name"
    let ItemsKey = "Items"
    let IconNameKey = "IconName"
    let SortTypeKey = "SortType"

    
    convenience init(name: String) {
        self.init(name: name, iconName: "No Icon")
    }
    
    init(name: String, iconName: String) {
        self.name = name
        self.iconName = iconName
        super.init()
    }
    
    required init?(coder aDecoder: NSCoder) {
        name = aDecoder.decodeObject(forKey: NameKey) as! String
        items = aDecoder.decodeObject(forKey: ItemsKey) as! [ChecklistItem]
        iconName = aDecoder.decodeObject(forKey: IconNameKey) as! String
        sortType = aDecoder.decodeObject(forKey: SortTypeKey) as! String
        super.init()
    }
    
    func encode(with aCoder: NSCoder) {
        aCoder.encode(name, forKey: NameKey)
        aCoder.encode(items, forKey: ItemsKey)
        aCoder.encode(iconName, forKey: IconNameKey)
        aCoder.encode(sortType, forKey: SortTypeKey)
    }
    
    func countUncheckedItems() -> Int {
        return items.reduce(0) { cnt, item in item.checked ? cnt : cnt + 1 }
    }
}
