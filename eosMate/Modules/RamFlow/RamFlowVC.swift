//
//  RamFlowVC.swift
//  eosMate
//
//  Created by Cyril on 20/10/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

class RamFlowVC: BaseVC, LoadsActiveAccounts {
    weak var delegate: FinishesFlow?
    
    let ramFlowView = RamFlowView(frame: UIScreen.main.bounds)
    var action: RamAction? { didSet { summaryView.action = action } }
    var selectedActiveAccount: EOSAccount? { didSet { summaryView.activeAccount = selectedActiveAccount } }
    var ramAmount: Float? { didSet { self.summaryView.ramAmount = ramAmount } }
    
    lazy var summaryView: RamSummaryView = ramFlowView.summaryView
    
    lazy var selectAccountView: FlowSelectAccountView? = ramFlowView.selectAccountView
    
    override func loadView() {
        view = ramFlowView
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeForViewFlowEvents()
        loadSaveAccounts()
        observeCloseBtn()
    }
    
    func didSelectAccount(account: EOSAccount) {}
    
    private func observeCloseBtn() {
        ramFlowView.rightBtnClicked.subscribe(onNext: { [weak self] clicked in
            guard let self = self else { return }
            self.ramFlowView.endEditing(true)
            self.delegate?.didFinishFlow(at: self)
        }).disposed(by: disposeBag)
    }
    
    private func subscribeForViewFlowEvents() {
        ramFlowView.selectActionView.actionSelected
            .map { $0 == .positive ? RamAction.buy : RamAction.sell }
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.action = action
                self.ramFlowView.updateTitleFor(action: action)
                self.ramFlowView.moveScrollView(toFront: true)
            }).disposed(by: disposeBag)
        
        ramFlowView.selectAccountView.didSelectAccount.subscribe(onNext: { [weak self] selectedAccount in
            guard let self = self else { return }
            self.selectedActiveAccount = selectedAccount
            self.ramFlowView.moveScrollView(toFront: true)
            self.ramFlowView.ramBytesView.becomeActive()
        }).disposed(by: disposeBag)
        
        ramFlowView.ramBytesView.didTapContinue.subscribe(onNext: { [weak self] amount in
            if let formattedAmount = Float(amount.supportedFloatString()) {
                self?.ramAmount = formattedAmount
                self?.ramFlowView.moveScrollView(toFront: true)
            }
        }).disposed(by: disposeBag)
        
        summaryView.didTapSend.subscribe(onNext: { [weak self] tapped in
            guard let self = self else { return }
            if let toAccount = self.selectedActiveAccount, let action = self.action, let bytes = self.ramAmount {
                self.performeRamRequestWith(action: action, account: toAccount, ramBytes: bytes)
            }
            
        }).disposed(by: disposeBag)
    }
    
    private func performeRamRequestWith(action: RamAction, account: EOSAccount, ramBytes: Float) {
        ramFlowView.setSpinnerTo(action: .active)
        services.blockchain.sendRamRequestWith(action: action, account: account, ramBytes: ramBytes) { [weak self] result, error in
            guard let self = self else { return }
            self.ramFlowView.setSpinnerTo(action: .stopped)
            guard error == nil else { return self.showErrorMessage(error) }
            self.services.analytics.log(event: .requestedRAM, info: nil)
            
            self.showPopUpWith(title: RamFlowLocalization.success.text,
                               message: "\(RamFlowLocalization.trId.text) \(result?.transactionId ?? "")", okeyCompletion: { done in
                                   self.delegate?.didFinishFlow(at: self)
                               })
        }
    }
}
