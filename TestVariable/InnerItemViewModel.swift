//
//  InnerItemViewModel.swift
//  TestVariable
//
//  Created by Le Ngoc HOAN on 6/15/17.
//  Copyright © 2017 Le Ngoc HOAN. All rights reserved.
//

import Foundation
import RxSwift
import RealmSwift
import RxCocoa
import UIKit

class InnerItemViewModel {
    let id = Variable<Int>(0)
    let title = Variable<String>("")
    let desc = Variable<String>("")
    let isChecked = Variable<Bool>(false)
    
    private let disposeBag = DisposeBag()
    let innerItem: InnerItem
    
    init(item: InnerItem) {
        innerItem = item
        innerItem.rx.observe(Int.self, "id")
            .map { _ in self.innerItem.id }.bind(to: self.id)
            .addDisposableTo(disposeBag)
        innerItem.rx.observe(String.self, "title")
            .map { _ in self.innerItem.title }.bind(to: self.title)
            .addDisposableTo(disposeBag)
        innerItem.rx.observe(String.self, "desc")
            .map { _ in self.innerItem.desc }.bind(to: self.desc)
            .addDisposableTo(disposeBag)
        innerItem.rx.observe(Bool.self, "isChecked")
            .map { _ in self.innerItem.isChecked }.bind(to: self.isChecked)
            .addDisposableTo(disposeBag)
    }
    
    static func createItem() -> InnerItem {
        let realm = try! Realm()
        let item = InnerItem()
        item.id = (realm.objects(InnerItem.self).max(ofProperty: "id") ?? 0) + 1
        item.title = "This is inner title"
        item.desc = "Tap check button to change desc"
        item.isChecked = false
        try! realm.write {
            realm.add(item)
        }
        
        return item
    }
    
    func check() {
        let realm = try! Realm()
        let item = realm.object(ofType: InnerItem.self, forPrimaryKey: self.id.value)
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
}

class InnerItemCell: UITableViewCell {
    static let identifier: String = "InnerItemCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    var viewModel: InnerItemViewModel!
    private var disposeBag: DisposeBag?
    
    func bind() {
        disposeBag = DisposeBag()
        viewModel.title.asObservable()
            .subscribe(onNext: { [unowned self] in self.titleLabel.text = $0 })
            .addDisposableTo(disposeBag!)
        viewModel.desc.asObservable()
            .subscribe(onNext: { [unowned self] in self.descLabel.text = $0 })
            .addDisposableTo(disposeBag!)
        viewModel.isChecked.asObservable()
            .subscribe(onNext: { [unowned self] isChecked in
                if isChecked {
                    self.checkButton.setTitle("Checked", for: .normal)
                } else {
                    self.checkButton.setTitle("Uncheck", for: .normal)
                }
            })
            .addDisposableTo(disposeBag!)
        
        checkButton.rx.tap.asObservable().subscribe(onNext: { [unowned self] in
            self.viewModel.check()
        })
        .addDisposableTo(disposeBag!)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        disposeBag = nil
    }
}
