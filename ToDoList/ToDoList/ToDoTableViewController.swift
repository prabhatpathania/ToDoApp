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
        Shows pop up to add a new item
     */
//    @IBAction func addTodoItem(_ sender: Any) {
//        let addAlert = UIAlertController(title: "New Todo", message: "Enter a title", preferredStyle: .alert)
//        addAlert.addTextField { (textfield:UITextField) in
//            textfield.placeholder = "ToDo Item Title"
//        }
//        addAlert.addAction(UIAlertAction(title: "Create", style: .default, handler: { (action:UIAlertAction) in
//            guard let title = addAlert.textFields?.first?.text else {return}
//            let newTodo = ToDoItem(Title: title, Completed: false, CreatedAt: Date(), itemIdentifier: UUID())
//            newTodo.saveItem()
//            self.todoItems.append(newTodo)
//            
//            let indexPath = IndexPath(row: self.tableView.numberOfRows(inSection: 0), section: 0)
//            
//            self.tableView.insertRows(at: [indexPath], with: .automatic)
//        }))
//        addAlert.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
//        self.present(addAlert, animated: true, completion: nil)
//    }
  
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
        if todoItem.Weight == 3 {
            cell.todoColor.backgroundColor = .red
        }
        else if todoItem.Weight == 2 {
            cell.todoColor.backgroundColor = .blue
        }
        else if todoItem.Weight == 1 {
            cell.todoColor.backgroundColor = .green
        }
        else {
            cell.todoColor.backgroundColor = .black
        }
        
//        if indexPath.row % 2 == 0 {
//            cell.todoColor.backgroundColor = .red
//        }
//        else {
//            cell.todoColor.backgroundColor = .blue
//        }
        return cell
    }
    
    /*
        Defining Row actions
     */
    public override func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration?
    {
//        let important = importantAction(at: indexPath)
//        let delete = deleteAction(at: indexPath)
        let complete = completeItem(at: indexPath)
        let delete = deleteItem(at: indexPath)

        return UISwipeActionsConfiguration(actions: [delete, complete])
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
//            self.loadData()
        }
        action.image = #imageLiteral(resourceName: "Trash")
        action.backgroundColor = UIColor(named:"mainRedColor")
        return action
    }
 

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
