//
//  FirstViewController.swift
//  TableViewDemo
//
//  Created by Song on 2019-04-11.
//  Copyright © 2019 Song. All rights reserved.
//

import UIKit

//Regular table view by using UITableViewController

class FirstViewController: UIViewController {

    let url = URL(string: "http://www.filltext.com/?rows=100&fname=%7BfirstName%7D&lname=%7BlastName%7D&city=%7Bcity%7D&pretty=true")
    let tableView = UITableView()
    var users: [User]? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(tableView)
        NSLayoutConstraint.activate([tableView.topAnchor.constraint(equalTo: view.topAnchor), tableView.leftAnchor.constraint(equalTo: view.leftAnchor), tableView.rightAnchor.constraint(equalTo: view.rightAnchor), tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor)])
        
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        tableView.dataSource = self
        tableView.delegate = self
        fetchJSONData()
    }
    
    func fetchJSONData() -> Void {
        if let url = self.url {
            URLSession.shared.dataTask(with: url){data, repsonse, error in
                if let data = data {
                    do {
                        let decoded = try JSONDecoder().decode([User].self, from: data)
                        DispatchQueue.main.async {
                            self.users = decoded
                            self.tableView.reloadData()
                        }
                    }catch let error{
                        print("\(error.localizedDescription)")
                    }
                }
                else{
                    print("The url is unavailable")
                }
            }.resume()
        }else{
            print("The url is unavailable")
        }
    }
}

//MARK: - tableview delegate
extension FirstViewController: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = users?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        if let users = self.users {
            let user = users[indexPath.row]
            cell.textLabel?.text = "\(user.firstName) \(user.lastName)  \(user.city)"
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("The row \(indexPath.row) is clicked")
    }
}
