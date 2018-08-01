//
//  ToDoTableViewController.swift
//  ToDoList
//
//  Created by Prabhat Singh Pathania on 25/07/18.
//  Copyright © 2018 Prabhat Singh Pathania. All rights reserved.
//

import UIKit

class ToDoTableViewController: UITableViewController{
    
    var todoItems:[ToDoItem]! {
        didSet{
            if progressBar != nil {
                progressBar.setProgress(progress, animated: true)
            }
        }
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationItem.setHidesBackButton(true, animated:true);
        loadData()
    }
    @IBOutlet weak var progressBar: UIProgressView!
    
    var progress: Float {
        if todoItems.count > 0 {
            return Float(todoItems.filter({$0.Completed}).count)/Float(todoItems.count)
        }
        else{
            return 0
        }
    }
    
    func loadData(){
        todoItems = [ToDoItem]()
        todoItems = DataManager.loadAll(ToDoItem.self)
        todoItems.sort {
            ($0.Weight, $0.CreatedAt) >
                ($1.Weight, $1.CreatedAt)
        }
        tableView.reloadData()
        progressBar.setProgress(progress, animated: true)
    }
    
    /*
     Strikethrough text style
     */
    func strikeThroughText (_ text:String) -> NSAttributedString{
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: text)
        attributeString.addAttribute(NSAttributedStringKey.strikethroughStyle, value: 1, range: NSMakeRange(0, attributeString.length))
        return attributeString
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return todoItems.count
    }
    
    /*
     1. Strike the items marked as completed
     2. Set background colour of item category
     */
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! ToDoTableViewCell
        let todoItem = todoItems[indexPath.row]
        
        cell.todoLabel.text = todoItem.Title
        if todoItem.Completed{
            cell.todoLabel.attributedText = strikeThroughText(todoItem.Title)
        }
        // Configure the cell...
        switch todoItem.Weight {
        case 3:
            cell.todoColor.backgroundColor = .red
            break
        case 2:
            cell.todoColor.backgroundColor = .blue
            break
        case 1:
            cell.todoColor.backgroundColor = .green
            break
        default:
            cell.todoColor.backgroundColor = .black
        }
        return cell
    }
    
    /*
     Defining Row actions
     */
    public override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
        let delete = deleteItem(at: indexPath)
        if !self.todoItems[indexPath.row].Completed {
            let complete = completeItem(at: indexPath)
            return UISwipeActionsConfiguration(actions: [delete, complete])
        } else {
            return UISwipeActionsConfiguration(actions: [delete])
        }
    }
    
    func completeItem(at indexPath: IndexPath)-> UIContextualAction{
        let action = UIContextualAction(style: .normal, title: "Completed") { (action, view, completion) in
            completion(true)
            var todoItem = self.todoItems[indexPath.row]
            todoItem.markAsCompleted()
            self.todoItems[indexPath.row]  = todoItem
            if let cell = self.tableView.cellForRow(at: indexPath) as? ToDoTableViewCell {
                cell.todoLabel.attributedText = self.strikeThroughText(todoItem.Title)
                
                UIView.animate(withDuration: 0.1, animations: {
                    cell.transform = cell.transform.scaledBy(x: 1.5, y: 1.5)
                }, completion: { (success) in
                    UIView.animate(withDuration: 0.3, delay: 0, usingSpringWithDamping: 0.7, initialSpringVelocity: 0.5, options: .curveEaseOut, animations: {
                        cell.transform = CGAffineTransform.identity
                    }, completion: nil)
                })
            }
            //            self.loadData()
        }
        action.image = #imageLiteral(resourceName: "Check")
        action.backgroundColor = UIColor(named:"mainGreenColor")
        return action
    }
    
    func deleteItem(at indexPath: IndexPath)-> UIContextualAction{
        let action = UIContextualAction(style: .normal, title: "Delete") { (action,view, completion) in
            completion(true)
            let todoItem = self.todoItems[indexPath.row]
            todoItem.deleteItem()
            self.todoItems.remove(at: indexPath.row)
            self.tableView.deleteRows(at: [indexPath], with: .automatic)
        }
        action.image = #imageLiteral(resourceName: "Trash")
        action.backgroundColor = UIColor(named:"mainRedColor")
        return action
    }
}
