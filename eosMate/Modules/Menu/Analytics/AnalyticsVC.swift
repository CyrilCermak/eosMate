//
//  AnalyticsVC.swift
//  eosMate
//
//  Created by Cyril Cermak on 14.06.20.
//  Copyright © 2020 CyrilCermak. All rights reserved.
//

import UIKit
import SnapKit
import RxSwift

class AnalyticsVC: BasePopVC {
    var shouldDisableAnalyticsOnCloseButton = true
    private let analyticsView = BaseDialogView(headerTitle: AnalyticsLocalization.headerTitle.text,
                                               headerSubtitle: AnalyticsLocalization.headerSubtitle.text,
                                               promoText: AnalyticsLocalization.promo.text,
                                               enableText: AnalyticsLocalization.enable.text,
                                               disableText: AnalyticsLocalization.disable.text)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = AnalyticsLocalization.screenTitle.text
        bindView()
        services.analytics.presentedConfirmation()
    }
    
    override func loadView() {
        view = analyticsView
    }
    
    func hideDisableButton() {
        analyticsView.disableButton.isHidden = true
    }
    
    private func bindView() {
        analyticsView.disableButton.rx.tap.subscribe(onNext: { [weak self] tapped in
            guard let self = self else { return }
            self.services.analytics.setAnalyticsCollecting(to: false)
            self.navigationController?.popViewController(animated: true)
            self.didClickClose.onNext(())
        }).disposed(by: disposeBag)
        
        analyticsView.closeBtn.rx.tap.subscribe(onNext: { [weak self] tapped in
            guard let self = self else { return }
            if self.shouldDisableAnalyticsOnCloseButton {
                self.services.analytics.setAnalyticsCollecting(to: false)
            }
            self.navigationController?.popViewController(animated: true)
            self.didClickClose.onNext(())
        }).disposed(by: disposeBag)
        
        analyticsView.enableButton.rx.tap.subscribe(onNext: { [weak self] tapped in
            guard let self = self else { return }
            self.services.analytics.setAnalyticsCollecting(to: true)
            self.navigationController?.popViewController(animated: true)
            self.didClickClose.onNext(())
        }).disposed(by: disposeBag)
    }
}
