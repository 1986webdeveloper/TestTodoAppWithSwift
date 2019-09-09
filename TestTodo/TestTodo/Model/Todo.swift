//
//  Todo.swift
//  TestTodo
//
//  Created by AGC on 08/09/19.
//  Copyright © 2019 AGC. All rights reserved.
//

import UIKit

/// Todo object
class Todo {
    /// Todo title
    let title:String
    /// Todo description value
    let descriptionValue:String
    /// Todo unique id
    var id:String = ""
    
    /// Initialize todo with title and description value
    init(_ title:String, _ description:String) {
        self.title = title
        self.descriptionValue = description
    }
    
    /// Get the description value of the todo object.
    func dictionaryData() -> [String:AnyObject] {
        return ["title":title as AnyObject, "desctiption":descriptionValue as AnyObject]
    }
    
    /// Initialize todo with dictionary and id value
    init(_ dictionary:[String:Any], _ key:String) {
        if let titel = dictionary["title"] as? String {
            self.title = titel
        } else {
            self.title = ""
        }
        if let desctiption = dictionary["desctiption"] as? String {
            self.descriptionValue = desctiption
        } else {
            self.descriptionValue = ""
        }
        self.id = key
    }
}
