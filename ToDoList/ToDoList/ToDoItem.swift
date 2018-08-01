//
//  ToDoItem.swift
//  ToDoList
//
//  Created by Prabhat Singh Pathania on 23/07/18.
//  Copyright © 2018 Prabhat Singh Pathania. All rights reserved.
//

import Foundation

struct ToDoItem: Codable {
    
    var Title: String
    var Completed: Bool
    var CreatedAt: Date
    var Weight: Int
    var itemIdentifier: UUID
    
    func saveItem() {
        DataManager.save(self, with: itemIdentifier.uuidString)
    }
    
    func deleteItem() {
        DataManager.delete(itemIdentifier.uuidString)
    }
    
    mutating func markAsCompleted() {
        self.Completed = true
        DataManager.save(self, with: itemIdentifier.uuidString)
    }
}
