//
//  AppDelegate.swift
//  PurchaseDemo
//
//  Created by 廖冠翰 on 2021/7/28.
//

import UIKit
import StoreKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate, SKPaymentTransactionObserver {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        SKPaymentQueue.default().add(self)
        return true
    }

    // MARK: UISceneSession Lifecycle
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
        SKPaymentQueue.default().remove(self)
    }
    
    func paymentQueue(_ queue: SKPaymentQueue, updatedTransactions transactions: [SKPaymentTransaction]) {
        for transaction in transactions {
             switch transaction.transactionState {
             case .purchasing:
                print("purchasing...")
             case .deferred:
                print("deferred")
             case .failed:
                print("failed")
             case .purchased:
                print("purchased")
                SKPaymentQueue.default().finishTransaction(transaction)
                 
                 if let appStoreReceiptURL = Bundle.main.appStoreReceiptURL,
                     FileManager.default.fileExists(atPath: appStoreReceiptURL.path) {

                     do {
                         let receiptData = try Data(contentsOf: appStoreReceiptURL, options: .alwaysMapped)
                         print(receiptData)

                         let receiptString = receiptData.base64EncodedString(options: [])

                         print(receiptString)
                     }
                     catch { print("Couldn't read receipt data with error: " + error.localizedDescription) }
                 }
             case .restored:
                print("restored")
             @unknown default: print("Unexpected transaction state \(transaction.transactionState)")
            }
        }
    }
}

