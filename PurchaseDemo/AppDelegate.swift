//
//  AppDelegate.swift
//  PurchaseDemo
//
//  Created by 廖冠翰 on 2021/7/28.
//

import UIKit
import StoreKit
import FirebaseCore
import FirebaseMessaging

@main
class AppDelegate: UIResponder, UIApplicationDelegate, SKPaymentTransactionObserver, UNUserNotificationCenterDelegate, MessagingDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // 配置iap
        SKPaymentQueue.default().add(self)
        // 配置apn
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if !granted {
               print("用戶拒絕開啟提醒")
               return
            }
            print("用戶同意開啟提醒")
        }
        application.registerForRemoteNotifications()
        // 配置firebase
        FirebaseApp.configure()
        Messaging.messaging().delegate = self
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
    
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print(fcmToken ?? "")
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
    
    // 使用者點選推播時觸發
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        print(#function)
        let content = response.notification.request.content
        print(content.userInfo)
        completionHandler()
    }
    
    // 讓 App 在前景也能顯示推播
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        completionHandler([.banner])
    }
}

