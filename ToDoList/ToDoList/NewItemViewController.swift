//
//  NewItemViewController.swift
//  ToDoList
//
//  Created by Prabhat Singh Pathania on 31/07/18.
//  Copyright © 2018 Prabhat Singh Pathania. All rights reserved.
//

import UIKit

class NewItemViewController: UIViewController {
    
    @IBOutlet weak var itemText: UITextField!
    @IBOutlet weak var urgentSwitch: UISwitch!
    @IBOutlet weak var importantSwitch: UISwitch!
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
    }
    
    @IBAction func saveNewItem(_ sender: Any) {
        
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
    // MARK: - Navigation
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        
        if segue.identifier == "ShowItems" {
            if let viewController = segue.destination as? ToDoTableViewController {
                var weight = 0
                if importantSwitch.isOn {
                    weight += 2
                }
                if urgentSwitch.isOn {
                    weight += 1
                }
                let newTodo = ToDoItem(Title: itemText.text!, Completed: false, CreatedAt: Date(), Weight: weight, itemIdentifier: UUID())
                newTodo.saveItem()
                viewController.loadData()           // to load data in todoItems
                viewController.todoItems.append(newTodo)
                viewController.loadData()           // to load data in todoItems & sort new item
                viewController.tableView.reloadData()
            }
        }
    }
    
}
