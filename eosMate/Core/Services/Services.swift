//
//  Services.swift
//  eosMate
//
//  Created by Cyril on 1/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation

protocol Services {
    var pushNotifications: PushNotifications { get }
    var analytics: AnalyticsProtocol { get }
    var blockchain: BlockchainProtocol { get }
    var transactions: TransactionsProtocol { get }
    var market: MarketProtocol { get }
    var observer: ObserverProtocol { get }
}

struct EOSServices: Services {
    var pushNotifications: PushNotifications = PushNotificationService()
    var analytics: AnalyticsProtocol = AnalyticsProvider()
    var blockchain: BlockchainProtocol = BlockchainProvider()
    var transactions: TransactionsProtocol = TransactionsProvider()
    var market: MarketProtocol = MarketProvider()
    var observer: ObserverProtocol = ObserverProvider()
}
