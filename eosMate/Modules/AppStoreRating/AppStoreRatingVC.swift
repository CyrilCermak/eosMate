//
//  AppStoreRatingVC.swift
//  eosMate
//
//  Created by Cyril Cermak on 13.05.21.
//  Copyright © 2021 CyrilCermak. All rights reserved.
//

import UIKit

class AppStoreRatingVC: BasePopVC {
    private lazy var ratingView: BaseDialogView = {
        let dialogView = BaseDialogView(headerTitle: RatingsLocalization.enjoying.text,
                                        headerSubtitle: RatingsLocalization.pleaseRateUs.text,
                                        promoText: "",
                                        enableText: RatingsLocalization.rateUs.text,
                                        disableText: RatingsLocalization.nextTime.text,
                                        image: UIImage(named: "five_stars")!)
        
        dialogView.disableButton.rx.tap.subscribe(onNext: { [weak self] tapped in
            self?.didClickClose.onNext(())
        }).disposed(by: disposeBag)
        
        dialogView.enableButton.rx.tap.subscribe(onNext: { [weak self] tapped in
            UserDefaultsService.shared.didPresentRatingVC()
            self?.services.analytics.reviewInTheAppStore()
            
            self?.didClickClose.onNext(())
        }).disposed(by: disposeBag)

        return dialogView
        
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = RatingsLocalization.rating.text
    }
    
    override func loadView() {
        view = ratingView
    }
}
