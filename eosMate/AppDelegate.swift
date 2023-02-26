//
//  AppDelegate.swift
//  eosMate
//
//  Created by Cyril on 1/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import UIKit
import Moya
import Firebase
import FirebaseMessaging
import FirebaseCore
import UserNotifications
import UserNotificationsUI

struct Configuration {
    static let marketAPI = "https://api.coingecko.com/api/v3/coins/"

    static let blockchainAPI = "https://eos.greymass.com/v1"
    static let blockchainBaseAPI = "https://eos.greymass.com"
    static let accountHistoryAPI = "https://eos.greymass.com/v1/"
 
    static let eosMateAPI = "https://eosmate.io/api/v1/"
    static let eosMateWeb = "https://eosmate.io/"
    static let eosMateTelegram = "https://t.me/eosMateApp"
    
// Testing
//    static let eosMateAPI = "http://localhost:8080/api/v1"
//    static let blockchainAPI = "https://jungle.greymass.com/v1"
}

@UIApplicationMain class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var flow: AppFlow!

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first ?? "")
        FirebaseApp.configure()
        
        initWindow()
        applyBaseStyling()
        configureFBNotificationsFor(application)

        return true
    }

    private func initWindow() {
        flow = AppFlow()
        window = UIWindow()
        window?.rootViewController = flow.navController
        window?.makeKeyAndVisible()
    }

    private func applyBaseStyling() {
        UIBarButtonItem.appearance().setTitleTextAttributes([NSAttributedStringKey.font: UIFont.exFontLatoRegular(size: 14)], for: .normal)
    }

    private func configureFBNotificationsFor(_ application: UIApplication) {
        UNUserNotificationCenter.current().delegate = self
        Messaging.messaging().delegate = self
        application.registerForRemoteNotifications()
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(tokenRefreshNotification),
                                               name: .InstanceIDTokenRefresh,
                                               object: nil)
    }

    @objc func tokenRefreshNotification(_ notification: Notification) {
        InstanceID.instanceID().instanceID { result, error in
            print("InstanceID token: \(result?.token ?? "")")
        }
        
        connectToFcm()
    }

    func connectToFcm() {
        // Disconnect previous FCM connection if it exists.
        Messaging.messaging().shouldEstablishDirectChannel = false
        Messaging.messaging().shouldEstablishDirectChannel = true
    }

    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("Unable to register for remote notifications: \(error.localizedDescription)")
    }

    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().setAPNSToken(deviceToken, type: .prod)
        print("APNs token retrieved: \(deviceToken)")
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
        UserDefaultsService.shared.didLaunchApp()
        
        flow.presentAppStoreRatingDialog()
    }
}

extension AppDelegate: MessagingDelegate {
    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String) {
        let dataDict: [String: String] = ["token": fcmToken]
        NotificationCenter.default.post(name: Notification.Name("FCMToken"), object: nil, userInfo: dataDict)
    }
}

extension AppDelegate: UNUserNotificationCenterDelegate {
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any],
                     fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        // If you are receiving a notification message while your app is in the background,
        // this callback will not be fired till the user taps on the notification launching the application.
        if let transactionJson = userInfo["transactionRequest"] as? [String: Any] {
            let transactionRequest = jsonTo(json: transactionJson, type: MateTransactionRequest.self)
            print(transactionRequest.debugDescription)
        }

        completionHandler(UIBackgroundFetchResult.newData)
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        let userInfo = notification.request.content.userInfo
        print(userInfo)
        completionHandler([.alert])
    }

    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let userInfo = response.notification.request.content.userInfo
        let identifier = response.notification.request.identifier
        if let tr = userInfo["transactionRequest"] as? String {
            if let data = tr.data(using: .utf8) {
                let request = try! JSONDecoder().decode(MateTransactionRequest.self, from: data)
                flow.presentSign(transaction: request)
            }
        }
        print(identifier)
        completionHandler()
    }
}
