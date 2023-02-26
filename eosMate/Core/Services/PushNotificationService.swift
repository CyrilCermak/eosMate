//
//  PushNotificationService.swift
//  eosMate
//
//  Created by Cyril on 8/4/18.
//  Copyright © 2018 Cyril. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import FirebaseMessaging

protocol PushNotifications {
    func publish(message: [String: Any])
}

struct PushKeys {
    private init() {}
    
    static let actionId = "actionId"
    static let chatId = "chatId"
    static let userId = "userId"
    enum Actions {
        static let OneOnOneMessage = "OneOnOneMessage"
        enum Challenge {
            static let Challenge = "Challenge"
            static let FailedChallenge = "FailedChallenge"
            static let AchievedChallenge = "AchievedChallenge"
            static let AchievedCheckpoint = "AchievedCheckpoint"
        }
    }
}

class PushNotificationService: PushNotifications {
    static let shared = PushNotificationService()
    
    func subscribeTo(topic: String) {
        print("subscribedFor: \(topic)")
        Messaging.messaging().subscribe(toTopic: topic)
    }
    
    func unsubscribeFrom(topic: String) {
        print("unsubscribedFrom: \(topic)")
        Messaging.messaging().unsubscribe(fromTopic: topic)
    }
    
    func publish(message: [String: Any]) {
        let firebaseAPNSUrl = "https://fcm.googleapis.com/fcm/send"
        // Add Secrets file with the firebaseAPIKey first
        let headers = ["Content-Type": "application/json", "Authorization": "key=\(Secrets.firebaseAPIKey)"]
        Alamofire.request(firebaseAPNSUrl, method: .post, parameters: message, encoding: JSONEncoding.default, headers: headers)
            .responseJSON { response in
                switch response.result {
                case let .success(json): print(json)
                case let .failure(error): print(error)
                }
            }
    }
}
