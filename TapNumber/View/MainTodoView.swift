//
//  ContentView.swift
//  TapNumber
//
//  Created by kyosuke on 2024/12/03.
//

import AppTrackingTransparency
import GoogleMobileAds
import SwiftUI

struct MainTodoView: View {
    // View間で共有するクラスをインスタンス化
    @ObservedObject var todosModel = TodosModel()
    @EnvironmentObject var appTheme: AppTheme
    // tab切り替えの変数
    @State var selectedTab = 1
    @AppStorage("TrackingFirst") var firstLaunch = true
    // TabViewの非選択時の色の変更
    init() {
        UITabBar.appearance().unselectedItemTintColor = UIColor(
            Color(
                "TabNavigationColor"
            ))
        if !self.firstLaunch {
            ATTrackingManager.requestTrackingAuthorization(completionHandler: {
                status in
                GADMobileAds.sharedInstance().start(completionHandler: nil)
            })
        }
    }
    var body: some View {
        VStack(spacing: 0) {
            //　画面の下にタブ切り替えを実装
            TabView(selection: $selectedTab) {
                TodoView()

                    .environmentObject(todosModel)
                    .tabItem {
                        Label("Task List", systemImage: "square.and.pencil")

                    }
                    .tag(1)
                EndTodoView()
                    .environmentObject(todosModel)
                    .tabItem {
                        Label(
                            "Complet", systemImage: "checkmark.circle.fill"
                        )
                        .foregroundColor(.blue)
                    }
                    .tag(2)

                    .tint(Color("TabNavigationSelectColor"))
                    .environment(\.horizontalSizeClass, .compact)
            }

        }
    }
}

#Preview {
    MainTodoView()
        .environmentObject(TodosModel())
        .environmentObject(AppTheme.shared)

}
