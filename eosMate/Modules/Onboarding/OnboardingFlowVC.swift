//
//  OnboardingFlowVC.swift
//  eosMate
//
//  Created by Cyril Cermak on 17.04.21.
//  Copyright © 2021 CyrilCermak. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

enum OnboardingLocalization: String, LocalizedStringRepresentable {
    case enable, skip, close, notifications, notificationsDetail
    case analytics, analyticsDetail, allSet, allSetDetail
    case addAccount
    case storeTokens, stake, observer, requests, developers
    var text: String { return "module.onboarding.\(rawValue)".localized() }
}

enum FirstLoginFlowModel: Int {
    case notification, analytics, allSet
}

extension FirstLoginFlowModel {
    var view: UIView {
        switch self {
        case .analytics:
            return BaseDialogFlowView(headerTitle: OnboardingLocalization.analytics.text,
                                      headerSubtitle: OnboardingLocalization.analyticsDetail.text,
                                      imageName: "ocularIcon",
                                      alignment: .left,
                                      expandedImage: false)
        case .notification:
            return BaseDialogFlowView(headerTitle: OnboardingLocalization.notifications.text,
                                      headerSubtitle: OnboardingLocalization.notificationsDetail.text,
                                      imageName: "notificationsIcon",
                                      alignment: .left,
                                      expandedImage: false)
        case .allSet:
            return BaseDialogFlowView(headerTitle: OnboardingLocalization.allSet.text,
                                      headerSubtitle: OnboardingLocalization.allSetDetail.text,
                                      imageName: "",
                                      alignment: .left,
                                      expandedImage: false, items: [
                                          OnboardingLocalization.storeTokens.text,
                                          OnboardingLocalization.stake.text,
                                          OnboardingLocalization.observer.text,
                                          OnboardingLocalization.requests.text,
                                          OnboardingLocalization.developers.text
                                      ])
        }
    }
    
    static var views: [UIView] {
        return [
            FirstLoginFlowModel.notification.view,
            FirstLoginFlowModel.analytics.view,
            FirstLoginFlowModel.allSet.view
        ]
    }
}

class FirstLoginFlowVC: BaseFlowVC {
    var wantsToAddAccount: (() -> Void)?
    var wantsToClose: (() -> Void)?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        views = FirstLoginFlowModel.views
        baseView.updateButtons(happyTitle: OnboardingLocalization.enable.text.uppercased(),
                               unhappyTitle: OnboardingLocalization.skip.text.uppercased())
        observeViewEvents()
    }
    
    override func loadView() {
        view = baseView
    }
    
    private func observeViewEvents() {
        // Happy case
        tappedHappyCaseAt.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            
            switch FirstLoginFlowModel(rawValue: index) {
            case .notification:
                self.registerRemoteNotifications()
            case .analytics:
                self.services.analytics.setAnalyticsCollecting(to: true)
                self.updateForAllSet()
                self.baseView.moveToNext()
            case .allSet:
                UserDefaultsService.shared.setFinishedOnboarding(to: true)
                self.wantsToAddAccount?()
            case .none: break
            }
        }).disposed(by: disposeBag)
        
        // Unappy case
        tappedUnhappyCaseAt.subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            
            switch FirstLoginFlowModel(rawValue: index) {
            case .notification:
                self.baseView.moveToNext()
            case .analytics:
                self.services.analytics.setAnalyticsCollecting(to: false)
                self.updateForAllSet()
                self.baseView.moveToNext()
            case .allSet:
                UserDefaultsService.shared.setFinishedOnboarding(to: true)
                self.wantsToClose?()
            case .none: break
            }
        }).disposed(by: disposeBag)
    }
    
    private func updateForAllSet() {
        baseView.updateButtons(happyTitle: OnboardingLocalization.addAccount.text.uppercased(),
                               unhappyTitle: OnboardingLocalization.close.text.uppercased())
    }
    
    private func registerRemoteNotifications() {
        let authOptions: UNAuthorizationOptions = [.alert, .badge, .sound]
        UNUserNotificationCenter.current().requestAuthorization(
            options: authOptions,
            completionHandler: { [weak self] granted, error in
                guard let self = self else { return }
                if granted {
                    self.services.analytics.log(event: .enabledNotifications, info: nil)
                }

                DispatchQueue.main.async {
                    self.baseView.moveToNext()
                }
            }
        )
    }
}
