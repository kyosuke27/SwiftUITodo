//
//  Todo.swift
//  TapNumber
//
//  Created by kyosuke on 2024/12/03.
//

import Foundation

class Todo: Identifiable{
    let id: UUID
    var todo: String
    var isCompleted: Bool
    let registerData: Date
    var messages:[Message] = []
    
    init(id: UUID, todo: String) {
        self.id = id
        self.todo = todo
        self.isCompleted = false
        self.registerData = Date()
    }
}
