//
//  TaskItemListViewController.swift
//  TestVariable
//
//  Created by Le Ngoc HOAN on 6/15/17.
//  Copyright © 2017 Le Ngoc HOAN. All rights reserved.
//

import UIKit
import RxSwift
import RxDataSources

class TaskItemListViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var viewModel: TaskItemListViewModel!
    let dataSource = RxTableViewSectionedAnimatedDataSource<TaskItemSection>()
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel = TaskItemListViewModel()
        configDataSource()
        bind()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func bind() {
        viewModel.taskItems
            .bind(to: tableView.rx.items(dataSource: dataSource))
            .addDisposableTo(disposeBag)
        tableView.rx.itemSelected
            .map { [unowned self] indexPath in
                try! self.dataSource.model(at: indexPath) as! TaskItem
            }
            .subscribe(onNext: { [unowned self]item in
                let VC = self.storyboard?.instantiateViewController(withIdentifier: "ViewController") as! ViewController
                VC.viewModel = TaskItemViewModel(item: item)
                self.navigationController?.pushViewController(VC, animated: true)
            })
            .addDisposableTo(disposeBag)
    }
    
    func configDataSource() {
        dataSource.configureCell = { (ds, tv, ip, item) in
            let cell = tv.dequeueReusableCell(withIdentifier: TaskItemCell.identifier) as! TaskItemCell
            cell.viewModel = TaskItemViewModel(item: item)
            cell.bind()
            
            return cell
        }
        
        dataSource.titleForHeaderInSection = { dataSource, index in
            dataSource.sectionModels[index].model
        }
    }
}
