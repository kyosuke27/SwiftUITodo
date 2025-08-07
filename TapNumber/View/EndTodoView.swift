//
//  EndTodo.swift
//  TapNumber
//
//  Created by kyosuke on 2024/12/03.
//

import GoogleMobileAds
import RealmSwift
import StoreKit
import SwiftUI

struct EndTodoView: View {
    enum AlertType {
        case editTodo
    }
    let screenWidth = UIScreen.main.bounds.width
    @EnvironmentObject var todosModel: TodosModel
    @EnvironmentObject var appTheme: AppTheme
    @EnvironmentObject var purchaseManager: PurchaseManager
    @Environment(\.requestReview) var requestReview
    @ObservedResults(TodoRealm.self) var todos
    @State var showDialog = false
    @State var showSettingModal = false
    @State var todoText = ""
    @State var alertType: AlertType = .editTodo
    @AppStorage("isReview") var isReview = false
    var body: some View {

        NavigationView {
            VStack {
                List {
                    ForEach(
                        todos,
                        content: { todo in
                            if todo.isCompleted {
                                VStack {
                                    ZStack {
                                        NavigationLink(
                                            destination: TodoNoteView(
                                                todo: todo)
                                        ) {
                                            EmptyView()

                                        }
                                        .frame(width: 0)
                                        .opacity(0)
                                        endTodoData(todo: todo)
                                    }
                                }
                                .padding(.all, 12)
                                .background(Color("TaskCellColor"))
                                .cornerRadius(5)
                                .listRowSeparator(.hidden)
                            }
                        })
                }
                .onAppear {
                }
                // これがないとリストの背景色が変わらないし、角丸にならない
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
                .sheet(isPresented: $showSettingModal) {
                    SettingView()
                }
                let adSize =
                    GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(
                        screenWidth)
                if purchaseManager.hasReleaseAd{
                    BannerView(adSize)
                        .frame(
                            width: screenWidth,
                            height: adSize.size.height
                        )
                }
            }
            .onAppear {
                // 完了タスク数が5以上かつ今までレビューしていない場合に表示する
                if todos.filter("isCompleted == true").count >= 5 && !isReview {
                    isReview = true
                    requestReview()
                }
                if todos.filter("isCompleted == true").count % 30 == 0 {
                    isReview = false
                }
            }
            .navigationBarItems(
                leading: Button(
                    action: {
                        // SettingModal
                        showSettingModal.toggle()
                    },
                    label: {
                        Image(systemName: "gear")
                            .resizable()
                            .foregroundColor(Color("PlusIconColor"))
                            .frame(width: 24, height: 24)
                    })
            )
            .toolbarBackground(appTheme.current.color, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(
                appTheme.current.color, for: .tabBar
            )
            .toolbarBackground(.visible, for: .tabBar)

        }
    }

    private func endTodoData(todo: TodoRealm) -> some View {
        let priorityNumber = todo.priority
        let priorityColor =
            PriorityType(rawValue: priorityNumber) ?? .priorityOne
        return HStack(spacing: 16) {
            // アイコン
            VStack {
                Image(systemName: "checkmark.circle")
                    .resizable()
                    .foregroundColor(.blue)
                    .frame(width: 24, height: 24)
            }
            // タスクの内容
            VStack {
                VStack {
                    // タスクの表示
                    Text(todo.todo)
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .font(.title2)
                        .foregroundColor(Color("TaskCellFontColor"))
                    // タスクの登録日時を表示
                    Text(returnDate(date: todo.registerData))
                        .frame(
                            maxWidth: .infinity,
                            alignment: .leading
                        )
                        .font(.caption)
                        .foregroundColor(Color("TaskCellFontColor"))
                }
            }
            // 優先度の表示
            VStack {
                Spacer()
                HStack {
                    Image(systemName: "flag")
                        .resizable()
                        .foregroundColor(Color("TaskCellFontColor"))
                        .frame(width: 12, height: 12)
                    Text((todo.priority + 1).description)
                        .foregroundColor(Color("TaskCellFontColor"))
                        .font(.caption)
                }
                .padding(8)
                .background(
                    RoundedRectangle(cornerRadius: 5).fill(
                        Color("TaskCellColor"))
                )
                // 角丸の枠線をオーバーレイで描画
                .overlay(
                    RoundedRectangle(cornerRadius: 5)
                        .stroke(priorityColor.priorityColor, lineWidth: 1)
                )
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        // データの完全削除
        .swipeActions(edge: .leading) {
            Button {
                todosModel.deleteMessages(todo: todo)
                todosModel.deleteTodo(todo: todo)
            } label: {
                Image(systemName: "trash")
                    .tint(.red)
            }
        }

    }
    // YYYY/MM/DD HH:mmの形式で日付を返す
    private func returnDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd HH:mm"
        return formatter.string(from: date)
    }
}

//#Preview {
//    EndTodoView(TodosModel())
//}
