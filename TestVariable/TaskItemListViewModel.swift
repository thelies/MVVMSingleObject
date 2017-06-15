//
//  TaskItemListViewModel.swift
//  TestVariable
//
//  Created by Le Ngoc HOAN on 6/15/17.
//  Copyright © 2017 Le Ngoc HOAN. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxCocoa
import RxDataSources
import RxRealm

typealias TaskItemSection = AnimatableSectionModel<String, TaskItem>

class TaskItemListViewModel {
    
    var taskItems: Observable<[TaskItemSection]> {
        return fetchTaskItems()
            .map { results in
                return [TaskItemSection(model: "test", items: results.toArray())]
            }
    }
    
    func fetchTaskItems() -> Observable<Results<TaskItem>> {
        let realm = try! Realm()
        let items = realm.objects(TaskItem.self)
        return Observable.collection(from: items)
    }
}
