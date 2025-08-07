//
//  TodoRepository.swift
//  TapNumber
//
//  Created by kyosuke on 2024/12/09.
//

import Foundation
import RealmSwift

class MessageRepository {
    private let realm: Realm = RealmManager.shared.getRealm()
    func deleteMessage(message: MessageRealm) {
        let removeMessage = realm.object(
            ofType: MessageRealm.self, forPrimaryKey: message.id)
        try! realm.write {
            realm.delete(removeMessage!)
        }
    }

    // isDoneカラムの更新（反転）
    func messageIsDone(message: MessageRealm) {
        let updateMessage = realm.object(
            ofType: MessageRealm.self, forPrimaryKey: message.id)
        try! realm.write {
            updateMessage?.isDone.toggle()
            realm.add(updateMessage!, update: .modified)
        }
    }
}
