//
//  PurchaseManager.swift
//  TapNumber
//
//  Created by kyosuke on 2025/08/02.
//

import StoreKit
import SwiftUI

@MainActor
class PurchaseManager: ObservableObject {
    // StoreKitの処理を記載する
    let productIds = ["ReleaseAd", "DevelopperDonation"]

    @Published
    private(set) var products: [Product] = []
    private var productsLoaded = false
    var isAdRemoved = false

    // 外部からの購入処理や変更を受け付けるタスク
    private var updates: Task<Void, Never>? = nil

    // 購入済みの製品IDを保持するためのセット
    @Published private(set) var purchaseProductIds = Set<String>()

    // ReleaseAdの購入があるかどうか
    var hasReleaseAd: Bool {
        return purchaseProductIds.contains("ReleaseAd")
    }

    init() {
        updates = observeTransactionUpdastes()
    }

    deinit {
        updates?.cancel()
    }

    func isReleaase(product: Product) -> Bool {
        if product.id == "ReleaseAd" {
            // 購入済みであるかどうか？
            return purchaseProductIds.contains(product.id)
        }
        return false
    }

    private func observeTransactionUpdastes() -> Task<Void, Never> {
        Task(priority: .background) { [unowned self] in
            // 購入情報の更新を監視する
            for await result in Transaction.updates {
                await self.updatePurchaseProducts()
            }
        }
    }

    func updatePurchaseProducts() async {
        // 商品の購入情報をロードする
        for await result in Transaction.currentEntitlements {
            guard case .verified(let transaction) = result else {
                continue
            }

            if transaction.revocationDate == nil {
                // 製品が購入されている場合、セットに追加
                self.purchaseProductIds.insert(transaction.productID)
                if transaction.productID == "ReleaseAd" {
                    isAdRemoved = true
                }
            } else {
                // 製品が取り消された場合、セットから削除
                self.purchaseProductIds.remove(transaction.productID)
            }

        }
    }

    func loadProducts() async throws {
        // 製品情報をロードする
        self.products = try await Product.products(for: productIds)
    }

    func purchase(_ product: Product) async throws {
        print("🛒 Starting purchase for product ID: \(product.id)")

        // 商品情報のログ（念のため）
        print(
            "🧾 Product Info: \(product.displayName), \(product.description), price: \(product.displayPrice)"
        )

        // 既に購入済みか確認
        if purchaseProductIds.contains(product.id) {
            print("⚠️ Product \(product.id) already purchased.")
            // DevelopperDonation以外であればreturn
            if product.id != "DevelopperDonation" {
                print("✅ Purchase already completed for product: \(product.id)")
                return
            }
        }

        do {
            let result = try await product.purchase()
            print("📦 Purchase result: \(result)")

            switch result {
            case let .success(.verified(transaction)):
                print(
                    "✅ Transaction verified for product: \(transaction.productID)"
                )
                await transaction.finish()
                await self.updatePurchaseProducts()
            case let .success(.unverified(_, error)):
                print(
                    "⚠️ Unverified transaction. Error: \(error.localizedDescription)"
                )
            case .pending:
                print(
                    "⏳ Purchase is pending. Possibly due to SCA (Strong Customer Authentication) or family sharing."
                )
            case .userCancelled:
                print("❌ User cancelled the purchase.")
                print("📌 Possible reasons:")
                print("- Authentication popup was dismissed or failed.")
                print("- Face ID / Touch ID not confirmed.")
                print("- Password not entered.")
                print("- StoreKit dialog not shown properly.")
                print("- Already owned and non-consumable.")
            @unknown default:
                print("❓ Unknown purchase result.")
            }
        } catch {
            print("🚫 Purchase failed with error: \(error.localizedDescription)")
        }
    }

}
