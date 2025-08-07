//
//  TapNumberApp.swift
//  TapNumber
//
//  Created by kyosuke on 2024/12/03.
//

import AppTrackingTransparency
import GoogleMobileAds
import SwiftUI

@main
struct TapNumberApp: App {
    @StateObject
    private var appTheme = AppTheme.shared
    private var purchaseManager = PurchaseManager()

    var body: some Scene {
        WindowGroup {
            MainTodoView()
                .onReceive(
                    NotificationCenter.default.publisher(
                        for: UIApplication.didBecomeActiveNotification)
                ) { _ in
                    Task {
                        let result =
                            await ATTrackingManager.requestTrackingAuthorization()
                        switch result {
                        case .authorized:
                            print("Authorized")
                        case .denied:
                            print("Denied")
                        default:
                            print("disable tracking")
                        }
                    }
                }
                // 環境変数に設定することで、アプリのテーマをコード全体で使用できるようにする
                // appThemeとpurchasManagerを環境変数として設定
                .environmentObject(appTheme)
                .environmentObject(purchaseManager)
                .task {
                    // 有料課金をしているか更新する
                    await purchaseManager.updatePurchaseProducts()
                    try! await purchaseManager.loadProducts()
                    print(
                        "Purchase products updated: \(purchaseManager.products)"
                    )
                }
        }
    }
}
