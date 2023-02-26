//
//  AnalyticsProvider.swift
//  eosMate
//
//  Created by Cyril on 15/7/18.
//  Copyright © 2018 Cyril. All rights reserved.
//

import Foundation
import Firebase
import StoreKit

protocol AnalyticsProtocol: AnyObject {
    func log(event: AnalyticsEvent, info: [String: String]?)
    func log(viewName: String)
    
    func needsAnalyticsConfirmation() -> Bool
    func resetAnalyticsConfirmation()
    func presentedConfirmation()
    func setAnalyticsCollecting(to state: Bool)
    func shouldShowAppStoreReview() -> Bool
    func reviewInTheAppStore()
}

enum AnalyticsEvent: String {
    case subscribeAccount
    case requestedTransaction
    case signedTransactionFromMate
    case requestedRAM
    case requestedResources
    case search
    case sentTokens
    case transactionsSearch
    case addedPK
    case enabledNotifications
    case didTapSendToken
    case didTapSendResources
    case didTapRam
    case didTapPendingTransactions
    case didTapRequestTransaction
}

class AnalyticsProvider: AnalyticsProtocol {
    init() {
        setFirebaseAnalytics(to: UserDefaultsService.shared.isAnalyticsTrackingEnabled())
    }
    
    func needsAnalyticsConfirmation() -> Bool {
        return !UserDefaultsService.shared.wasAnalyticsConsentPresentedAfterLogin()
    }
    
    func resetAnalyticsConfirmation() {
        return UserDefaultsService.shared.setPresentAnalyticsAfterLogin(to: false)
    }
    
    func presentedConfirmation() {
        UserDefaultsService.shared.setPresentAnalyticsAfterLogin(to: true)
    }
    
    func setAnalyticsCollecting(to state: Bool) {
        UserDefaultsService.shared.setAnalyticsEnabled(to: state)
        
        setFirebaseAnalytics(to: state)
    }
    
    func log(viewName: String) {
        Analytics.setScreenName(viewName, screenClass: viewName)
    }
    
    func log(event: AnalyticsEvent, info: [String: String]?) {
        Analytics.logEvent(event.rawValue, parameters: info)
    }
    
    func shouldShowAppStoreReview() -> Bool {
        // User already rated the app
        guard UserDefaultsService.shared.canRateTheApp() else {
            return false
        }
        
        let numberOfLaunches = UserDefaultsService.shared.getNumberOfAppLaunches()
        
        // Displaying maximum 2 times
        guard numberOfLaunches <= 10 else {
            return false
        }
        
        // Displaying after fifth came to FG of the app
        if (numberOfLaunches % 5) == 0 {
            return true
        }
        
        return false
    }
    
    func reviewInTheAppStore() {
        SKStoreReviewController.requestReview()
    }
    
    private func setFirebaseAnalytics(to state: Bool) {
        #if DEBUG
            FirebaseApp.app()?.isDataCollectionDefaultEnabled = false
        #else
            FirebaseApp.app()?.isDataCollectionDefaultEnabled = state
        #endif
    }
}
