//
//  ChatMessage.swift
//  TapNumber
//
//  Created by kyosuke on 2024/12/04.
//

import SwiftUI

struct TodoNoteMessage: View {
    let messageReposiroty = MessageRepository()
    var message: MessageRealm
    let onDelete: () -> Void
    let onDone: () -> Void
    @State var isShowAlert: Bool = false

    var body: some View {
        VStack {
            // メッセージ領域
            messageText
            // 日付等の詳細情報
            messageDetail
        }
        .padding()
    }
}

extension TodoNoteMessage {
    // 記録文書
    private var messageText: some View {
        HStack {
            HStack {
                Text(message.message)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    // 三項演算子で色の切り替え
                    .foregroundColor(Color("ChatMessageFontColor"))
                Button {
                    // xmark action
                    onDone()
                } label: {
                    Image(systemName: "checkmark.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color("ChatMessageFontColor"))
                }
                Button {
                    // xmark action
                    isShowAlert.toggle()
                } label: {
                    Image(systemName: "xmark.circle")
                        .resizable()
                        .frame(width: 20, height: 20)
                        .foregroundColor(Color("ChatMessageFontColor"))
                }
                .alert("削除", isPresented: $isShowAlert) {
                    Button("キャンセル", role: .cancel) {

                    }
                    Button("削除", role: .destructive) {
                        onDelete()
                    }
                } message: {
                    Text("メッセージを削除しますか？")
                }

            }
            .padding()
            .background(
                message.isDone
                    ? Color("ChatMessageDoneColor")
                    : Color("ChatMessageViewColor")
            )
            .cornerRadius(30)
            Spacer()
        }
    }
    // 記録日、その他情報を付け加えることもあり得るので別個で管理する
    private var messageDetail: some View {
        HStack {
            Spacer()
            Text(formatteDate)
                .padding(.leading, 20)
                .foregroundColor(Color("ChatMessageCalernderFontColor"))
        }
        .foregroundColor(.secondary)
        .font(.footnote)
        .frame(alignment: .trailing)
    }

    // 日付のフォーマットを変更する（YYYY:HH:mm）形式に変更する
    private var formatteDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd HH:mm"
        return formatter.string(from: message.registerData)
    }
}

//#Preview {
//    // 一旦渡しておく
//    TodoNoteMessage()
//}
