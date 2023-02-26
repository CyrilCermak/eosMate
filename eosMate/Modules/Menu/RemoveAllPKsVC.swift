//
//  RemoveAllPKsVC.swift
//  eosMate
//
//  Created by Cyril Cermak on 19.07.20.
//  Copyright © 2020 CyrilCermak. All rights reserved.
//

import Foundation

class RemoveAllPKsVC: BasePopVC {
    var shouldDisableAnalyticsOnCloseButton = true
    private let baseDialogView = BaseDialogView(headerTitle: RemovePKsLocalization.title.text,
                                                headerSubtitle: RemovePKsLocalization.subtitle.text,
                                                promoText: "",
                                                enableText: RemovePKsLocalization.remove.text,
                                                disableText: RemovePKsLocalization.disable.text)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = RemovePKsLocalization.screenTitle.text
        bindView()
        services.analytics.presentedConfirmation()
    }
    
    override func loadView() {
        view = baseDialogView
    }
    
    func hideDisableButton() {
        baseDialogView.disableButton.isHidden = true
    }
    
    private func bindView() {
        baseDialogView.disableButton.isHidden = true
        
        baseDialogView.closeBtn.rx.tap.subscribe(onNext: { [weak self] tapped in
            guard let self = self else { return }
            if self.shouldDisableAnalyticsOnCloseButton {
                self.services.analytics.setAnalyticsCollecting(to: false)
            }
            self.navigationController?.popViewController(animated: true)
            self.didClickClose.onNext(())
        }).disposed(by: disposeBag)
        
        baseDialogView.enableButton.rx.tap.subscribe(onNext: { [weak self] tapped in
            guard let self = self else { return }
            self.services.blockchain.deleteAllPKs()
            self.showMessage()
        }).disposed(by: disposeBag)
    }
    
    private func showMessage() {
        AMPopUpController.shared.createPopUp(at: view,
                                             title: RemovePKsLocalization.deletedTitle.text,
                                             description: RemovePKsLocalization.deletedDsc.text) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.didClickClose.onNext(())
            }
        }
    }
}
