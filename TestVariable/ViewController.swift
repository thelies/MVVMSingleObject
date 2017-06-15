//
//  ViewController.swift
//  TestVariable
//
//  Created by Le Ngoc HOAN on 6/14/17.
//  Copyright © 2017 Le Ngoc HOAN. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ViewController: UIViewController {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var descLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: TaskItemViewModel!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
//        tableView.delegate = self
        tableView.dataSource = self
        TaskItemViewModel.createItem()
        let item = TaskItemViewModel.fetchItemById(id: 1)
        viewModel = TaskItemViewModel(item: item!)
        bind()
        
        // Do any additional setup after loading the view, typically from a nib.
        descLabel.rx.observe(String.self, "text").subscribe(onNext: { _ in
            print("Value desc changed")
        })
        .addDisposableTo(disposeBag)
        titleLabel.rx.observe(String.self, "text").subscribe(onNext: { _ in
            print("Value title changed")
        })
        .addDisposableTo(disposeBag)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

    func bind() {
        viewModel.title.asObservable()
            .subscribe(onNext: { [unowned self] in self.titleLabel.text = $0 })
            .addDisposableTo(disposeBag)
        viewModel.desc.asObservable()
            .subscribe(onNext: { [unowned self] in self.descLabel.text = $0 })
            .addDisposableTo(disposeBag)
        viewModel.isChecked.asObservable()
            .subscribe(onNext: { [unowned self] isChecked in
                if isChecked {
                    self.checkButton.setTitle("Checked", for: .normal)
                } else {
                    self.checkButton.setTitle("Uncheck", for: .normal)
                }
            })
            .addDisposableTo(disposeBag)
        
        checkButton.rx.tap.asObservable().subscribe(onNext: { [unowned self] in
            self.viewModel.check()
        })
        .addDisposableTo(disposeBag)
    }
}

extension ViewController: UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.taskItem.innerItems.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: InnerItemCell.identifier) as! InnerItemCell
        cell.viewModel = InnerItemViewModel(item: viewModel.taskItem.innerItems[indexPath.row])
        cell.bind()
        
        return cell
    }
}

