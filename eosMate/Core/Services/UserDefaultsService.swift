//
//  UserDefaultsService.swift
//  eosMate
//
//  Created by Cyril on 04/07/2017.
//  Copyright © 2017 Cyril. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class UserDefaultsService {
    static let shared = UserDefaultsService()
    private let didReadTermsAndCond = "didReadTermsAndCond"
    private let analyticsShown = "analyticsShown"
    private let analyticsEnabled = "analyticsEnabled"
    private let numberOfAppLaunches = "numberOfAppLaunches"
    private let didFinishOnboarding = "didFinishOnboarding"
    private let didPresentRating = "didPresentRating"
    private let defaults = UserDefaults()

    init() {}
    
    func userDidReadTermsAndCond() {
        defaults.set(true, forKey: didReadTermsAndCond)
    }
    
    func hasUserReadTermsAndCond() -> Bool {
        if let readTerms = defaults.value(forKey: didReadTermsAndCond) as? Bool {
            return readTerms
        }
        return false
    }
    
    func finishedOnboarding() -> Bool {
        // For user who already have the app installed
        // remove after some time
        if wasAnalyticsConsentPresentedAfterLogin(), hasUserReadTermsAndCond() {
            setFinishedOnboarding(to: true)
            return true
        }
        
        return defaults.bool(forKey: didFinishOnboarding)
    }
    
    func setFinishedOnboarding(to state: Bool) {
        defaults.set(state, forKey: didFinishOnboarding)
    }
    
    func wasAnalyticsConsentPresentedAfterLogin() -> Bool {
        return defaults.bool(forKey: analyticsShown)
    }
    
    func setPresentAnalyticsAfterLogin(to state: Bool) {
        defaults.set(state, forKey: analyticsShown)
    }
    
    func setAnalyticsEnabled(to state: Bool) {
        defaults.set(state, forKey: analyticsEnabled)
    }
    
    func isAnalyticsTrackingEnabled() -> Bool {
        return defaults.bool(forKey: analyticsEnabled)
    }
    
    func didLaunchApp() {
        let currentNumberOfLaunches = defaults.integer(forKey: numberOfAppLaunches)
        print("Setting; \(currentNumberOfLaunches + 1)")
        
        defaults.set(currentNumberOfLaunches + 1, forKey: numberOfAppLaunches)
    }
    
    func getNumberOfAppLaunches() -> Int {
        return defaults.integer(forKey: numberOfAppLaunches)
    }
    
    func didPresentRatingVC() {
        defaults.setValue(true, forKey: didPresentRating)
    }
    
    func canRateTheApp() -> Bool {
        return !defaults.bool(forKey: didPresentRating)
    }
}
