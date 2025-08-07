//
//  TodosModel.swift
//  TapNumber
//
//  Created by kyosuke on 2024/12/03.
//

import Foundation

// クラスの役割としては、Todoクラスを管理するクラス
class TodosModel: ObservableObject {
    @Published var todos: [Todo] = []
    private let todoRepository: TodoRepository = TodoRepository()

    init() {
        //とりあえず仮でインスタンスを起動する
        self.todos = [Todo(id: UUID(), todo: "Todo1")]
    }
    // Todoの登録
    func addTodo(todoText: String, priority: Int) {
        todoRepository.createTodoTask(todoText: todoText, priority: priority)
    }

    // Todoデータを全て取得する（配列で変える）
    func readAllTodo() -> [TodoRealm] {
        return todoRepository.readAllTodo()
    }

    // Todoデータを削除する
    func deleteTodo(todo: TodoRealm) {
        todoRepository.deleteTodotask(todo: todo)
    }

    // 対象のTodoデータを更新する(プロパティ毎にメソッド作ると大変なので更新しそうなやつを更新する)
    func updateTodoText(todo: TodoRealm, newTodoText: String, priority: Int) {
        todoRepository.updateTodoTask(
            todo: todo, todoText: newTodoText, priority: priority)
    }

    func updateTodoIsCompleted(todo: TodoRealm, isCompleted: Bool) {
        todoRepository.updateTodoTask(todo: todo, isCompleted: isCompleted)
    }

    // Messageの登録
    func addMessage(todo: TodoRealm, message: String) -> Void{
        todoRepository.createMessage(todo: todo, messageText: message)
    }

    // Messageデータの取得（Todoを元にしてデータを取得する）
    func readAllMessage(todo: TodoRealm) -> [MessageRealm] {
        // isDoneの昇順にソートして取得
        let newTodo = self.readTodoById(todo: todo)
        let sortedMessages = newTodo.messages.sorted(by: {
            $0.isDone || $1.isDone
        })
        // List型のデータを配列にして返す
        return sortedMessages.map { $0 }
    }

    // Todoデータをidを元にして取得する
    func readTodoById(todo: TodoRealm) -> TodoRealm {
        return todoRepository.readTodoById(todo: todo)
    }

    // UUIDを元にして、Todoクラスの配列から一致したtodoデータのindex番号を返す
    func getTodoByIndexId(id: UUID) -> Int? {
        return self.todos.enumerated().first(where: { $0.element.id == id })?
            .offset ?? -1
    }

    // todosの中でisCompletedが全てTrueになっているか判定する
    func isAllCompleted() -> Bool {
        return self.todos.allSatisfy { $0.isCompleted }
    }

    // Todoデータの完全削除
    func deleteMessages(todo: TodoRealm) {
        todoRepository.deleteMessages(todo: todo)
    }

    // Messageデータの削除
    func deleteMessage(todo: TodoRealm, message: MessageRealm) {
    }

}
