//
//  SendTokensFlowVC.swift
//  eosMate
//
//  Created by Cyril on 25/9/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class SendTokensFlowVC: BasePopVC, LoadsActiveAccounts {
    weak var delegate: FinishesFlow?

    var selectedActiveAccount: EOSAccount? { didSet { summaryView.fromAccount = selectedActiveAccount }}
    var toAccount: EOSAccount? { didSet { self.summaryView.toAccount = toAccount }}
    var eosAmount: String? { didSet { self.summaryView.eosAmount = eosAmount?.formatAmount() }}
    
    let sendTokenView = SendTokensFlowView(frame: UIScreen.main.bounds)
    
    lazy var summaryView: SendTokensSummaryView = sendTokenView.summaryView

    lazy var selectAccountView: FlowSelectAccountView? = sendTokenView.selectAccountView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeCloseBtn()
        subscribeForEvents()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        loadSaveAccounts()
    }
    
    override func loadView() {
        self.view = sendTokenView
        sendTokenView.accountSearchView.delegate = self
    }
    
    private func observeCloseBtn() {
        sendTokenView.rightBtnClicked.subscribe(onNext: { [weak self] clicked in
            guard let self = self else { return }
            self.sendTokenView.endEditing(true)
            self.delegate?.didFinishFlow(at: self)
        }).disposed(by: disposeBag)
    }
    
    func didSelectAccount(account: EOSAccount) {
        self.selectedActiveAccount = account
    }
    
    private func subscribeForEvents() {
        self.sendTokenView.summaryView.didTapSend
            .subscribe(onNext: { [weak self] tapped in
                guard let self = self else { return }
                if let sender = self.selectedActiveAccount, let reciever = self.toAccount, let amount = self.eosAmount?.formatAmount() {
                    self.sendTokens(sender: sender, reciever: reciever, amount: amount)
                }
            }).disposed(by: disposeBag)
        
        sendTokenView.selectAccountView.didSelectAccount.subscribe(onNext: { [weak self] account in
            guard let self = self else { return }
            self.selectedActiveAccount = account
            self.sendTokenView.moveScrollView(toFront: true)
            self.sendTokenView.accountSearchView.becomeActive()
        }).disposed(by: disposeBag)
        
        sendTokenView.accountSearchView.didTapContinue.subscribe(onNext: { [weak self] account in
            guard let self = self else { return }
            self.sendTokenView.moveScrollView(toFront: true)
            self.toAccount = account
            self.sendTokenView.amountToSendView.becomeActive()
        }).disposed(by: disposeBag)
        
        sendTokenView.amountToSendView.didTapContinue.subscribe(onNext: { [weak self] amount in
            guard let self = self else { return }
            self.eosAmount = amount
            self.sendTokenView.moveScrollView(toFront: true)
        }).disposed(by: disposeBag)
    }
    
    private func sendTokens(sender: EOSAccount, reciever: EOSAccount, amount: String) {
        self.sendTokenView.setSpinnerTo(action: .active)
        self.services.blockchain.sendTokens(sender: sender, reciever: reciever, amount: amount) { [weak self] result, error in
            guard let self = self else { return }
            self.sendTokenView.setSpinnerTo(action: .stopped)
            guard error == nil else { return self.showErrorMessage(error) }
            self.services.analytics.log(event: .sentTokens, info: nil)
            self.showPopUpWith(title: TokensFlowLocalization.success.text,
                               message: "\(TokensFlowLocalization.trId.text) \(result?.transactionId ?? "")", okeyCompletion: { [weak self] done in
                                   guard let self = self else { return }
                                   self.delegate?.didFinishFlow(at: self)
                               })
        }
    }
}

extension SendTokensFlowVC: AccountSearchViewDelegate {
    func didClickSearch(for name: String) {
        sendTokenView.accountSearchView.startSpinning()
        services.blockchain.getAccount(name: name.lowercased()).asObservable()
            .subscribe(onNext: { [weak self] account in
                self?.sendTokenView.accountSearchView.set(account: account)
            }, onError: { [weak self] error in
                self?.sendTokenView.accountSearchView.stopSpinning()
                self?.sendTokenView.accountSearchView.removeAccount()
                self?.showErrorMessage(AMError(localizedTitle: TokensFlowLocalization.notFoundTitle.text,
                                               localizedDescription: TokensFlowLocalization.notFoundDsc.text,
                                               code: 500))
            }).disposed(by: disposeBag)
    }
    
    func didClickOtherTokens(for account: EOSAccount) {}
    
    func searchDidBecomeActive() {
        DispatchQueue.main.async {
            self.sendTokenView.accountSearchView.removeAccount()
        }
    }
}
