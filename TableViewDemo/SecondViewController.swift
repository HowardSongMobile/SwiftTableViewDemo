//
//  SecondViewController.swift
//  TableViewDemo
//
//  Created by Song on 2019-04-11.
//  Copyright © 2019 Song. All rights reserved.
//

import UIKit
import RxCocoa
import RxSwift

//Table view by using RxSwift

class SecondViewController: UIViewController {

    let url = URL(string: "http://www.filltext.com/?rows=100&fname=%7BfirstName%7D&lname=%7BlastName%7D&city=%7Bcity%7D&pretty=true")
    let tableView = UITableView()
    let disposeBag = DisposeBag()
    let users: BehaviorRelay<[User]> = BehaviorRelay(value: [])
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        view.addSubview(tableView)
        tableView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            tableView.topAnchor.constraint(equalTo: self.view.topAnchor),
            tableView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor),
            tableView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor),
            tableView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor)
            ])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        
        users.bind(to: tableView.rx.items(cellIdentifier: "cell")) { row, element, cell in
            cell.textLabel?.text = "\(element.firstName) \(element.lastName)  \(element.city)"
            }.disposed(by: disposeBag)
        
        tableView.rx
            .itemSelected.subscribe(onNext:{ indexPath in
                print("The row \(indexPath.row) is clicked!")
            }).disposed(by: disposeBag)
        
        fetchJSONData()
    }
}

extension SecondViewController {
    
    func fetchJSONData() -> Void {
        
        if let url = self.url {
            URLSession.shared.dataTask(with: url) { data, response, error in
                if let data = data {
                    do {
                        let decoded = try JSONDecoder().decode([User].self, from: data)
                        self.users.accept(decoded)
                        
                    } catch let error {
                        print(error.localizedDescription)
                    }
                }else{
                    print("The data on response was wrong, try again later.")
                }
            }.resume()
        }else{
            print("The url is unavilable")
        }
    }
}
