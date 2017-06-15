//
//  TaskItemCell.swift
//  TestVariable
//
//  Created by Le Ngoc HOAN on 6/15/17.
//  Copyright © 2017 Le Ngoc HOAN. All rights reserved.
//

import UIKit
import RxSwift
import RealmSwift
import RxCocoa

class TaskItemCell: UITableViewCell {
    static let identifier = "TaskItemCell"
    
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    var viewModel: TaskItemViewModel!
    private var disposeBag: DisposeBag?
    
    func bind() {
        disposeBag = DisposeBag()
        descLabel.rx.observe(String.self, "text").subscribe(onNext: { _ in
            print("Value desc changed")
        })
        .addDisposableTo(disposeBag!)
        titleLabel.rx.observe(String.self, "text").subscribe(onNext: { _ in
            print("Value title changed")
        })
        .addDisposableTo(disposeBag!)
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
