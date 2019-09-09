//
//  ToDoViewModel.swift
//  TestTodo
//
//  Created by AGC on 08/09/19.
//  Copyright © 2019 AGC. All rights reserved.
//

import UIKit
import Firebase
import FirebaseDatabase

/// Todo View Model
class ToDoViewModel: NSObject {
    /// Create a singleton object of class
    static let shared = ToDoViewModel()
    /// Get the firebase database reference.
    let ref = Database.database().reference()
    /// Firebase todo table name
    let tableName = "TODO"
    
    /// Add todo in the firebase database.
    func addTodo(_ todo:Todo,completion:@escaping (Bool, Error?) -> Void) {
        let todoRef = ref.child(tableName).childByAutoId()
        todoRef.setValue(todo.dictionaryData(), withCompletionBlock: { (error, dbRef) in
            if error == nil {
                completion(true,nil)
            } else {
                completion(false,error)
            }
        })
        todoRef.observe(.childAdded) { (snapshot) in
            completion(true,nil)
        }
    }
    
    /// Edit todo in firebase database
    func editTodo(_ todo:Todo,completion:@escaping (Bool, Error?) -> Void) {
        let todoRef = ref.child(String(format: "%@/%@", tableName,todo.id))
        todoRef.setValue(todo.dictionaryData(), withCompletionBlock: { (error, dbRef) in
            if error == nil {
                completion(true,nil)
            } else {
                completion(false,error)
            }
        })
    }
    
    /// Get all todo list from firebase.
    func getAllTodo(completion:@escaping ([Todo], Error?) -> Void) {
        let todoRef = ref.child(tableName)
        todoRef.observe(.value) { (snapshot) in
            var allData = [Todo]()
            for child in snapshot.children {
                if let snapshot = child as? DataSnapshot {
                    if snapshot.key != "",
                        let dictionary = snapshot.value as? [String:Any] {
                        let item = Todo.init(dictionary,snapshot.key)
                        allData.append(item)
                    }
                }
            }
            completion(allData,nil)
        }
    }
    
    /// Remove todo in the firebase  database.
    func removeTodo(_ todo:Todo,completion:@escaping (Bool, Error?) -> Void) {
        if todo.id != "" {
            let todoRef = ref.child(String(format: "%@/%@", tableName,todo.id))
            todoRef.removeValue { (error, snapshot) in
                if error == nil {
                    completion(true,nil)
                } else {
                    completion(false,error)
                }
            }
        } 
    }
}
