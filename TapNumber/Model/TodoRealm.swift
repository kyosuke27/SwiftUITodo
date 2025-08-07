//
//  Todo.swift
//  TapNumber
//
//  Created by kyosuke on 2024/12/03.
//

import Foundation
import RealmSwift

class TodoRealm: Object,Identifiable{
    @Persisted var id: UUID
    @Persisted var todo: String
    @Persisted var isCompleted: Bool
    @Persisted var registerData: Date
    @Persisted var messages = List<MessageRealm>()
    @Persisted var priority: Int
    
    // TodoRealmの初期化処理
    // convenienceにしているのは、RealmのObjectが独自のinitを実装しているため補助的にconvenienceを使用している
    convenience init(id: UUID, todo: String, isCompleted: Bool = false, registerData: Date = Date(), priority: Int) {
        self.init()
        self.id = id
        self.todo = todo
        self.isCompleted = isCompleted
        self.registerData = registerData
        self.priority = priority
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
}

 
