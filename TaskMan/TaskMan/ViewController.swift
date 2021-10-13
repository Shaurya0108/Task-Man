//
//  ViewController.swift
//  TaskMan
//
//  Created by shaurya on 10/13/21.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    
    private let table: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        return table
    }()
    
    override func viewDidLoad(){
        super.viewDidLoad()
        self.items = UserDefaults.standard.stringArray(forKey: "items") ?? []//saves the new entry so that once the app is closed, it saves the entry
        // Do any additional setup after loading the view.
        title = "Task-Man"
        view.addSubview(table)
        table.dataSource = self
        
        //adding a add button
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(didTap))
    }
    
    //create a private function for tapping to add a new item
    @objc private func didTap(){
        let alert = UIAlertController(title: "New", message: "What do you want to do now?", preferredStyle: .alert)//prompts the user for an option when they click the plus button
        alert.addTextField{field in field.placeholder = "Enter new item..."}//prompts message for new item
        alert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "ta da!", style: .default, handler: { [weak self](_) in
            if let field = alert.textFields?.first{
                if let text = field.text, !text.isEmpty{
                    
                    //Enter new to do item
                    //makes sure the process is running in the background and on the main thread
                    DispatchQueue.main.async {
                        var currentItems = UserDefaults.standard.stringArray(forKey: "items") ?? []
                        currentItems.append(text)
                        UserDefaults.standard.setValue(currentItems, forKey: "items")
                        self?.items.append(text)//self? is linked with line 35, [weak] -- doesnt cause a memory leak
                        self?.table.reloadData()
                    }
                }
            }
        }))
        present(alert, animated: true)
    }
    
    //creates a global item
    var items = [String]()//creates an array of items
    
    override func viewDidLayoutSubviews() {
        //creating a table layout
        super.viewDidLayoutSubviews()
        table.frame = view.bounds
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //num of rows in the table
        return items.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        
        
        cell.textLabel?.text = items[indexPath.row]//places item in its respective row
        //num of cells in the table
        return cell;
    }

}

