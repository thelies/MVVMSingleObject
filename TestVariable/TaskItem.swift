//
//  TaskItem.swift
//  TestVariable
//
//  Created by Le Ngoc HOAN on 6/14/17.
//  Copyright © 2017 Le Ngoc HOAN. All rights reserved.
//

import Foundation
import RealmSwift

class TaskItem: Object {
    dynamic var id: Int = 0
    dynamic var title: String = ""
    dynamic var desc: String = ""
    dynamic var isChecked: Bool = false
    
    override static func primaryKey() -> String? {
        return "id"
    }
}
