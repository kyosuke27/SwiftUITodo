//
//  TodoRepository.swift
//  TapNumber
//
//  Created by kyosuke on 2024/12/09.
//

import Foundation
import RealmSwift

class TodoRepository {

    private let realm: Realm

    init() {
        // シングルトンのRealmデータを取得する
        realm = RealmManager.shared.getRealm()
    }

    // Todoの新規作成
    func createTodoTask(todoText: String, priority: Int) {
        let realmTodo = TodoRealm(
            id: UUID(), todo: todoText, priority: priority)
        try! realm.write {
            realm.add(realmTodo)
        }
    }

    // Todoデータの更新(todoの更新)
    func updateTodoTask(todo: TodoRealm, todoText: String, priority: Int) {
        let newTodo = realm.object(
            ofType: TodoRealm.self, forPrimaryKey: todo.id)
        try! realm.write {
            newTodo!.todo = todoText
            newTodo!.priority = priority
        }
    }
    // Todoデータの更新(isComplatedの更新)
    func updateTodoTask(todo: TodoRealm, isCompleted: Bool) {
        try! realm.write {
            todo.thaw()?.isCompleted = isCompleted
        }
    }

    // Todoの削除
    func deleteTodotask(todo: TodoRealm) {
        let removeTodo = realm.object(
            ofType: TodoRealm.self, forPrimaryKey: todo.id)
        try! realm.write {
            realm.delete(removeTodo!)
        }

    }

    // Todoの全取得
    func readAllTodo() -> [TodoRealm] {
        // freezeをつけないと削除するときにエラーになる
        let todos = realm.objects(TodoRealm.self)
        return todos.map { $0 }
    }

    // Todoのidを元にしてデータを取得
    func readTodoById(todo: TodoRealm) -> TodoRealm {
        let todo = realm.object(ofType: TodoRealm.self, forPrimaryKey: todo.id)
        return todo!
    }
    // Messageの新規作成
    // TodoRealmオブジェクトのList<MessageRealm>に値を入れて更新する
    func createMessage(todo: TodoRealm, messageText: String) {
        let realmMessage = MessageRealm(id: UUID(), message: messageText)
        let todo = realm.object(ofType: TodoRealm.self, forPrimaryKey: todo.id)
        try! realm.write {
            // realmMessageの登録
            realm.add(realmMessage)
            todo?.messages.append(realmMessage)
            // TodoにMessageを追加する
            realm.add(todo!)
        }
    }

    // Messageの削除
    // Todoに紐づくメッセージデータを削除する
    func deleteMessages(todo: TodoRealm) {
        // todoの中のmessagesからデータを取り出してMessageデータから取得して削除
        for message in todo.messages {
            let removeMessage = realm.object(
                ofType: MessageRealm.self, forPrimaryKey: message.id)
            try! realm.write {
                realm.delete(removeMessage!)
            }
        }
    }

}
