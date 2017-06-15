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
    var taskItem: TaskItem? = nil {
        didSet {
            if let item = taskItem {
                item.rx.observe(Int.self, "id")
                    .map { _ in item.id }.bind(to: self.id)
                    .addDisposableTo(disposeBag)
                item.rx.observe(String.self, "title")
                    .map { _ in item.title }.bind(to: self.title)
                    .addDisposableTo(disposeBag)
                item.rx.observe(String.self, "desc")
                    .map { _ in item.desc}.bind(to: self.desc)
                    .addDisposableTo(disposeBag)
                item.rx.observe(Bool.self, "isChecked")
                    .map { _ in item.isChecked }.bind(to: self.isChecked)
                    .addDisposableTo(disposeBag)
            }
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
    
    func fetchItemById(id: Int) {
        let realm = try! Realm()
        let item = realm.object(ofType: TaskItem.self, forPrimaryKey: id)
        self.taskItem = item
    }
    
    func createItem() {
        let realm = try! Realm()
        let item = TaskItem()
        item.id = (realm.objects(TaskItem.self).max(ofProperty: "id") ?? 0) + 1
        item.title = "This is title"
        item.desc = "Tap check button to change desc"
        item.isChecked = false
        try! realm.write {
            realm.add(item)
        }
    }
}
