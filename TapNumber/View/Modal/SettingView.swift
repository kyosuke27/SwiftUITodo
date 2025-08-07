//
//  SettingView.swift
//  TapNumber
//
//  Created by kyosuke on 2025/05/22.
//

import StoreKit
import SwiftUI

struct SettingView: View {
    @EnvironmentObject var purchaseManager: PurchaseManager

    var body: some View {
        NavigationView {
            List {
                VStack {
                    NavigationLink(
                        destination: ColorViewSetting()
                    ) {
                        Text("テーマカラーの設定")
                    }

                }
                ForEach(purchaseManager.products) { (product) in
                    VStack {
                        if purchaseManager.isReleaase(product: product) {
                            Text("\(product.displayName)は購入済みです")
                        } else {
                            Button {
                                Task {
                                    do {
                                        try await purchaseManager.purchase(
                                            product)
                                    } catch {
                                        print(error)
                                    }
                                }
                            } label: {
                                Text(product.displayName)
                                    .foregroundColor(.black)
                            }
                        }
                    }
                }

            }
            .task {
                do {
                    try await purchaseManager.loadProducts()
                    // purchaseManager.loadProductsのproductsを表示する
                    print("Products loaded:")
                    print(purchaseManager.products)
                } catch {
                    print(error)
                }
            }
        }
    }
}

#Preview {
    SettingView()
}
