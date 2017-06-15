//
//  TaskItemViewModel.swift
//  TestVariable
//
//  Created by Le Ngoc HOAN on 6/14/17.
//  Copyright © 2017 Le Ngoc HOAN. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxCocoa

class TaskItemViewModel {
    let id = Variable<Int>(0)
    let title = Variable<String>("")
    let desc = Variable<String>("")
    let isChecked = Variable<Bool>(false)
    
    private let disposeBag = DisposeBag()
    let taskItem: TaskItem

    init(item: TaskItem) {
        taskItem = item
        taskItem.rx.observe(Int.self, "id")
            .map { _ in self.taskItem.id }.bind(to: self.id)
            .addDisposableTo(disposeBag)
        taskItem.rx.observe(String.self, "title")
            .map { _ in self.taskItem.title }.bind(to: self.title)
            .addDisposableTo(disposeBag)
        taskItem.rx.observe(String.self, "desc")
            .map { _ in self.taskItem.desc }.bind(to: self.desc)
            .addDisposableTo(disposeBag)
        taskItem.rx.observe(Bool.self, "isChecked")
            .map { _ in self.taskItem.isChecked }.bind(to: self.isChecked)
            .addDisposableTo(disposeBag)
    }
    
    static func createItem() {
        let realm = try! Realm()
        let item = TaskItem()
        item.id = (realm.objects(TaskItem.self).max(ofProperty: "id") ?? 0) + 1
        item.title = "This is title"
        item.desc = "Tap check button to change desc"
        item.isChecked = false
        for _ in 1 ... 10 {
            let innerItem = InnerItemViewModel.createItem()
            item.innerItems.append(innerItem)
        }
        try! realm.write {
            realm.add(item)
        }
    }
    
    func check() {
        let realm = try! Realm()
        let item = realm.object(ofType: TaskItem.self, forPrimaryKey: self.id.value)
        if let item = item {
            try! realm.write {
                item.isChecked = !item.isChecked
                if item.isChecked {
                    item.desc = "Checked"
                } else {
                    item.desc = "Uncheck"
                }
            }
        }
    }
    
    static func fetchItemById(id: Int) -> TaskItem? {
        let realm = try! Realm()
        let item = realm.object(ofType: TaskItem.self, forPrimaryKey: id)
        return item
    }
}
