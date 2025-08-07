//
//  Message.swift
//  TapNumber
//
//  Created by kyosuke on 2024/12/03.
//

import Foundation
import RealmSwift

class MessageRealm: Object,Identifiable{
    @Persisted var id: UUID
    @Persisted var message: String
    @Persisted var registerData: Date
    // messageと繋がっているUUIDを外部キーとしてTodoと繋げる
    @Persisted var todoId: UUID?
    @Persisted var isDone: Bool = false
    
    // MessageRealmの初期化処理
    // convenienceにしているのは、RealmのObjectが独自のinitを実装しているため補助的にconvenienceを使用している
    convenience init(id: UUID, message: String, registerData: Date = Date()) {
        self.init()
        self.id = id
        self.message = message
        self.registerData = registerData
        self.isDone = false
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
}

