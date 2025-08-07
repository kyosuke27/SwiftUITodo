//
//  TodoView.swift
//  TapNumber
//
//  Created by kyosuke on 2024/12/03.
//

import GoogleMobileAds
import HorizonCalendar
import RealmSwift
import SwiftUI
import SwiftUICore

struct TodoView: View {
    enum AlertType {
        case addTodo
        case editTodo
    }
    // Todoクラスのインスタンス化
    @EnvironmentObject var todoModel: TodosModel
    @EnvironmentObject private var appTheme: AppTheme
    @EnvironmentObject var purchaseManager: PurchaseManager
    // Realmオブジェクトのインスタンス
    let todoRealmRepository = TodoRepository()
    let priority = [0, 1, 2, 3]
    let screenWidth = UIScreen.main.bounds.width
    @ObservedResults(TodoRealm.self) var todoRealm
    @ObservedObject var interstitial = Interstitial()
    @State var todoText = ""
    @State var showDialog = false
    @State var showEditDialog = false
    @State var selectedPriority = 0
    // Alertのタイプを格納する
    @State var alertType: AlertType = .addTodo
    @State var updateTodo: TodoRealm?
    @State var showSettingModal: Bool = false
    @State private var refreshId = UUID()
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // タスク一覧を表示
                todoList
                    .id(refreshId)
                let adSize =
                    GADCurrentOrientationAnchoredAdaptiveBannerAdSizeWithWidth(
                        screenWidth)
                if !purchaseManager.isAdRemoved {
                    // 広告非表示デバッグ文
                    BannerView(adSize)
                        .frame(
                            width: screenWidth,
                            height: adSize.size.height
                        )
                }
            }
            .onChange(of: purchaseManager.isAdRemoved) { _ in
                refreshId = UUID()
            }
            .onAppear {
                interstitial.loadInterstitial()
            }
            .sheet(isPresented: $showSettingModal) {
                SettingView()
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
                    }),

                trailing:
                    Button(
                        action: {
                            alertType = .addTodo
                            // Dialog表示
                            showDialog.toggle()
                        },
                        label: {
                            Image(systemName: "plus")
                                .resizable()
                                .foregroundColor(Color("PlusIconColor"))
                                .frame(width: 18, height: 18)
                        })
            )
            .toolbarBackground(appTheme.current.color, for: .navigationBar)
            .toolbarBackground(.visible, for: .navigationBar)
            .toolbarBackground(
                appTheme.current.color, for: .tabBar
            )
            .toolbarBackground(.visible, for: .tabBar)
        }
        .navigationViewStyle(.stack)
    }
}

extension TodoView {
    private var inputTodoText: some View {
        VStack {
            HStack {
                Spacer()
                    // Todo入力Modal表示
                    .sheet(isPresented: $showDialog) {
                        ZStack {
                            Color("AddTaskModalViewColor")
                                .ignoresSafeArea()
                            VStack {
                                Text("タスクの追加")
                                    .foregroundColor(
                                        Color("AddTaskModalFontColor")
                                    )
                                    .frame(
                                        maxWidth: .infinity, alignment: .leading
                                    )
                                    .font(.title)
                                    .padding(.top, 54)
                                TextField(
                                    "", text: $todoText,
                                    prompt: Text("タスクを入力してください")
                                        .foregroundColor(
                                            Color("AddTaskModalFontColor"))
                                )
                                .foregroundColor(Color("AddTaskModalFontColor"))
                                .padding(.vertical, 14)
                                .padding(.horizontal, 8)
                                // 枠線の色を変更
                                .overlay(
                                    RoundedRectangle(cornerRadius: 4)
                                        .stroke(
                                            Color("AddTaskModalFontColor"),
                                            lineWidth: 1)
                                )
                                // カーソルの点滅色を変更
                                .tint(Color("AddTaskModalFontColor"))
                                Spacer()
                                // Priority Area
                                VStack {
                                    Text("優先度")
                                        .foregroundColor(
                                            Color("AddTaskModalFontColor")
                                        )
                                        .frame(
                                            maxWidth: .infinity,
                                            alignment: .leading
                                        )

                                    HStack(spacing: 8) {
                                        ForEach(priority, id: \.self) {
                                            priority in
                                            VStack(spacing: 0) {
                                                Image(systemName: "flag")
                                                    .resizable()
                                                    .foregroundColor(
                                                        Color(
                                                            "PriorityFontColor")
                                                    )
                                                    .frame(
                                                        width: 12, height: 12
                                                    )
                                                    // 中央に配置
                                                    .frame(maxWidth: .infinity)
                                                    .padding(4)
                                                Button {
                                                    print(
                                                        "Priority: \(priority)")
                                                    selectedPriority =
                                                        priority
                                                } label: {
                                                    Text(
                                                        (priority + 1)
                                                            .description
                                                    )
                                                    .foregroundColor(
                                                        Color(
                                                            "PriorityFontColor")
                                                    )
                                                }

                                            }
                                            .padding(.horizontal, 24)
                                            .padding(.vertical, 4)
                                            .background(
                                                RoundedRectangle(
                                                    cornerRadius: 5
                                                )
                                                .fill(
                                                    selectedPriority
                                                        == Int(priority)
                                                        ? Color(
                                                            "PrioritySelectViewColor"
                                                        )
                                                        : Color(
                                                            "PriorityViewColor")
                                                ))
                                        }
                                    }
                                }
                                Spacer()
                                // Save Button

                                Button {
                                    if !todoText.isEmpty {
                                        if alertType == .addTodo {
                                            // todoの登録処理
                                            todoModel.addTodo(
                                                todoText: todoText,
                                                priority: selectedPriority)
                                        } else {
                                            // todoの更新処理
                                            todoModel.updateTodoText(
                                                todo: updateTodo!,
                                                newTodoText: todoText,
                                                priority: selectedPriority)
                                        }
                                        //                                // todoTextを空にする
                                        todoText = ""
                                        showDialog.toggle()
                                    } else {
                                        // タスク未入力の場合には登録処理はしない
                                    }
                                } label: {
                                    Text("Save")
                                        .frame(maxWidth: .infinity)
                                        .padding(16)
                                        // font color
                                        .foregroundColor(
                                            Color("AddTaskModalFontColor")
                                        )
                                        // background color
                                        .background(
                                            Color("AddTaskModalButtonViewColor")
                                        )
                                        .cornerRadius(8)
                                }
                                .padding(.horizontal, 16)
                                // Cancel Button
                                Button {
                                    showDialog.toggle()
                                } label: {
                                    Text("Cancel")
                                        .frame(maxWidth: .infinity)
                                        .padding(.horizontal, 24)
                                        .padding(.vertical, 14)
                                        .foregroundColor(
                                            Color(
                                                "AddTaskModalCancelButtonFontColor"
                                            )
                                        )
                                        .background(.white)
                                        .cornerRadius(8)
                                }
                                .padding(.horizontal, 16)
                                .padding(.bottom, 54)
                            }
                            .padding(.horizontal, 24)
                        }
                    }
            }
        }
    }

    private var allTodoCompleted: some View {
        ForEach(todoModel.todos) { todo in
            if todo.isCompleted {
            }
        }
    }

    private var todoList: some View {
        VStack {
            List {
                if !todoModel.isAllCompleted() {
                    ForEach(
                        todoRealm,
                        content: { todo in
                            if !todo.isCompleted {
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
                                        todoData(todo: todo)
                                    }
                                }
                                .padding(.all, 12)
                                .background(Color("TaskCellColor"))
                                .cornerRadius(5)
                                .listRowSeparator(.hidden)
                            }
                        }
                    )
                } else {
                    Text("完了したタスクがありません")
                        .foregroundColor(.black)

                }
            }
            .refreshable {
            }
            .listStyle(.plain)
            .scrollContentBackground(.hidden)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            inputTodoText
        }
    }

    // MARK : - Task Cell
    // タスク表示のセル
    private func todoData(todo: TodoRealm) -> some View {
        let priorityNumber = todo.priority
        let priorityColor =
            PriorityType(rawValue: priorityNumber) ?? .priorityOne
        return HStack(spacing: 8) {
            // アイコン
            VStack {
                Image(systemName: "circle")
                    .resizable()
                    .foregroundColor(Color("TaskCellFontColor"))
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
        .frame(maxWidth: .infinity)

        // タスク削除処理
        .swipeActions(
            edge: .trailing,
            allowsFullSwipe: true
        ) {
            Button(role: .destructive) {
                if !purchaseManager.hasReleaseAd {
                    let randomNum = Int.random(in: 1...100)
                    // タスク完了処理
                    // インタースティシャル広告の表示
                    if randomNum <= 50 {
                        interstitial.presentInterstitial()
                    }
                }
                todoModel.updateTodoIsCompleted(
                    todo: todo, isCompleted: !todo.isCompleted)

            } label: {
                Image("TodoComplete")
            }
            .tint(.cyan)

        }
        // Swipeアクションした時のアイコンとか処理を記載する
        .swipeActions(edge: .leading) {
            // Todoの削除処理
            Button {
                todoModel.deleteMessages(todo: todo)
                todoModel.deleteTodo(todo: todo)
            } label: {
                // ゴミ箱のラベル
                Image(systemName: "trash")
                    .tint(.red)

            }
            // Todoの編集機能
            Button {
                print("Edit Todo")
                alertType = .editTodo
                todoText = todo.todo
                updateTodo = todo
                showDialog.toggle()
            } label: {
                // 編集用のアイコン
                Image(systemName: "pencil")
            }
            .tint(.green)
        }
    }

    // Priorityの数値に応じて色を返却する

    // YYYY/MM/DD HH:mmの形式で日付を返す
    private func returnDate(date: Date) -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "YYYY/MM/dd HH:mm"
        return formatter.string(from: date)
    }

}
//#Preview {
//    TodoView()
//}
