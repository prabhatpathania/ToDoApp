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
//        let newTodo = ToDoItem(Title: itemText.text!, Completed: false, CreatedAt: Date(), itemIdentifier: UUID())
//        let storyboard: UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
//        let firstViewController: firstviewcontroller = storyboard.instantiateViewController(withIdentifier: "firstviewcontroller") as! firstviewcontroller
        
//        let newTodo = ToDoItem(Title: itemText.text!, Completed: false, CreatedAt: Date(), itemIdentifier: UUID())
        var weight = 0
        if importantSwitch.isOn {
            weight += 2
        }
        if urgentSwitch.isOn {
            weight += 1
        }
//        let newTodo = ToDoItem(Title: itemText.text!, Completed: false, CreatedAt: Date(), Important: importantSwitch.isOn, Urgent: urgentSwitch.isOn, itemIdentifier: UUID())
        let newTodo = ToDoItem(Title: itemText.text!, Completed: false, CreatedAt: Date(), Weight: weight, itemIdentifier: UUID())
        print(newTodo)
        newTodo.saveItem()
        // **************
        let storyboard: UIStoryboard = UIStoryboard.init(name: "Main", bundle: nil)
        let tableViewController: ToDoTableViewController = storyboard.instantiateViewController(withIdentifier: "ToDoTableViewController") as! ToDoTableViewController
        
        
////        tableViewController.loadData()
////        newTodo.saveItem()
//        tableViewController.loadData()
//        tableViewController.todoItems.append(newTodo)
//        let indexPath = IndexPath(row: tableViewController.tableView.numberOfRows(inSection: 0), section: 0)
//        tableViewController.tableView.insertRows(at: [indexPath], with: .automatic)
//        print("To Do Items: ")
//        print(tableViewController.todoItems)
//        tableViewController.tableView.reloadData()
//    }
        // Navigate back
        [self.navigationController?.popToRootViewController(animated: true)]
        // **************
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        let newTodo = ToDoItem(Title: itemText.text!, Completed: false, CreatedAt: Date(), itemIdentifier: UUID())
//        newTodo.saveItem()
//        if segue.identifier == "ToDoTableViewController" {
//            if let viewController = segue.destination as? ToDoTableViewController {
//                viewController.todoItems.append(newTodo)
//            }
//        }
    }
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
