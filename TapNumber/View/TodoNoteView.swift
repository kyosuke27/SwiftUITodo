//
//  TodoNoteView.swift
//  TapNumber
//
//  Created by kyosuke on 2024/12/04.
//

import RealmSwift
import SwiftUI

import class RealmSwift.List

struct TodoNoteView: View {
    // Realmオブジェクトのインスタンス
    let messageReposiroty = MessageRepository()
    @EnvironmentObject var todosModel: TodosModel
    @State private var messages: [MessageRealm] = []
    @State private var messageText = ""
    // NavigationLInkで遷移してきた下の画面へ戻るための変数
    @Environment(\.dismiss) var dismiss
    // 親画面から渡された値
    @ObservedRealmObject var todo: TodoRealm
    @FocusState var isInputActive: Bool
    var body: some View {
        // 画面の初期スクロール状態を管理できる
        VStack {
            // NavigationArea
            navigationArea
            // メッセージ表示部分
            messageShowArea
            // メッセージの入力部分
            messageInputArea
        }
        //.navigationTitle(todo.todo)
        .navigationBarBackButtonHidden(true)
        .onAppear {
        }
        .toolbar {
            ToolbarItemGroup(placement: .keyboard) {
                Spacer()
                Button("Done") {
                    isInputActive = false
                }
            }
        }
    }

    func convertListToArray(list: List<MessageRealm>) -> [MessageRealm] {
        return list.map { $0 }
    }
}

// TodoNoteViewの拡張
extension TodoNoteView {

    // メッセージ表示部分
    private var messageShowArea: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    ForEach(
                        self.todo.messages.sorted(
                            byKeyPath: "isDone", ascending: true)
                    ) { message in
                        TodoNoteMessage(
                            message: message,
                            onDelete: {
                                messageReposiroty.deleteMessage(
                                    message: message)
                            },
                            onDone: {
                                messageReposiroty.messageIsDone(
                                    message: message)
                            }
                        )

                    }
                }
            }
            .scrollDismissesKeyboard(.immediately)
        }
    }
    // メッセージ入力
    private var messageInputArea: some View {
        HStack {
            TextField("メモの入力", text: $messageText, axis: .vertical)
                .focused($isInputActive)
                .padding()
                .padding(.trailing, 30)
                .background(Color.white)
                .cornerRadius(30)
                .foregroundColor(.black)
                .overlay(
                    Button {
                        if !messageText.isEmpty {
                            // メッセージ送信処理を追加
                            sendInputMessage()
                        }
                        // 入力部分を初期化
                        messageText = ""
                    } label: {
                        Image(systemName: "paperplane.fill")
                            .resizable()
                            .frame(width: 24, height: 24)
                            .foregroundColor(.blue)
                            .padding()
                    }, alignment: .trailing
                )
                .compositingGroup()
                .shadow(radius: 5)

        }
        // 左右にpaddingを追加
        .padding(.horizontal)
        // 上に10pxのpaddingを追加
        .padding(.vertical, 10)
        .frame(maxWidth: .infinity)
    }

    // メッセージの追加処理(更新されたTodoRealmを返す)
    private func sendInputMessage() {
        todosModel.addMessage(todo: todo, message: messageText)
    }

    // NavigationArea
    private var navigationArea: some View {
        HStack {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.backward")
                    .font(.title2)
            }
            Spacer()
            Text(todo.todo)
                .font(.title2)
                .bold()
                .foregroundColor(.black)
            Spacer()
        }
        .padding()
    }

}

//#Preview {
//    TodoNoteView()
//}
