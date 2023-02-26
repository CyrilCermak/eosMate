//
//  ResourceFlowVC.swift
//  eosMate
//
//  Created by Cyril on 20/10/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

class ResourceFlowVC: BaseVC, LoadsActiveAccounts {
    weak var delegate: FinishesFlow?
    
    let resourceFlowView = ResourceFlowView(frame: UIScreen.main.bounds)
    var selectedActiveAccount: EOSAccount? { didSet { summaryView.activeAccount = selectedActiveAccount } }
    var action: ResourceAction? { didSet { summaryView.action = action } }
    var cpuAmount: Float? { didSet { summaryView.cpuAmount = cpuAmount } }
    var netAmount: Float? { didSet { self.summaryView.netAmount = netAmount } }
    
    lazy var summaryView: ResourceSummaryView = resourceFlowView.summaryView
    
    lazy var selectAccountView: FlowSelectAccountView? = resourceFlowView.selectAccountView
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeForViewFlowEvents()
        loadSaveAccounts()
        observeCloseBtn()
    }
    
    override func loadView() {
        view = resourceFlowView
    }
    
    private func observeCloseBtn() {
        resourceFlowView.rightBtnClicked.subscribe(onNext: { [weak self] clicked in
            guard let self = self else { return }
            self.resourceFlowView.endEditing(true)
            self.delegate?.didFinishFlow(at: self)
        }).disposed(by: disposeBag)
    }
    
    func didSelectAccount(account: EOSAccount) {
        selectedActiveAccount = account
    }
    
    private func subscribeForViewFlowEvents() {
        resourceFlowView.selectActionView.actionSelected
            .map { $0 == .positive ? ResourceAction.stake : ResourceAction.unstake }
            .subscribe(onNext: { [weak self] action in
                guard let self = self else { return }
                self.action = action
                self.resourceFlowView.moveScrollView(toFront: true)
            }).disposed(by: disposeBag)
        
        resourceFlowView.selectAccountView.didSelectAccount.subscribe(onNext: { [weak self] selectedAccount in
            guard let self = self else { return }
            self.selectedActiveAccount = selectedAccount
            self.resourceFlowView.moveScrollView(toFront: true)
            self.resourceFlowView.cpuInputView.becomeActive()
        }).disposed(by: disposeBag)
        
        resourceFlowView.cpuInputView.didTapContinue.subscribe(onNext: { [weak self] amount in
            if let formattedAmount = Float(amount.supportedFloatString()) {
                self?.cpuAmount = formattedAmount
                self?.resourceFlowView.moveScrollView(toFront: true)
                self?.resourceFlowView.netInputView.becomeActive()
            }
        }).disposed(by: disposeBag)
        
        resourceFlowView.netInputView.didTapContinue.subscribe(onNext: { [weak self] amount in
            guard let self = self else { return }
            if let formattedAmount = Float(amount.supportedFloatString()) {
                self.netAmount = formattedAmount
                self.resourceFlowView.moveScrollView(toFront: true)
            }
        }).disposed(by: disposeBag)
        
        summaryView.didTapSend.subscribe(onNext: { [weak self] tapped in
            guard let self = self else { return }
            if let toAccount = self.selectedActiveAccount, let action = self.action {
                self.sendResourceRequestWith(action: action, account: toAccount, cpu: self.cpuAmount ?? 0, net: self.netAmount ?? 0)
            }
            
        }).disposed(by: disposeBag)
    }
    
    private func sendResourceRequestWith(action: ResourceAction, account: EOSAccount, cpu: Float, net: Float) {
        resourceFlowView.setSpinnerTo(action: .active)
        services.blockchain.sendResourceRequestWith(action: action, account: account, cpu: cpu, net: cpu) { [weak self] result, error in
            guard let self = self else { return }
            self.resourceFlowView.setSpinnerTo(action: .stopped)
            guard error == nil else { return self.showErrorMessage(error) }
            self.services.analytics.log(event: .requestedResources, info: nil)
            self.showPopUpWith(title: ResourcesFlowLocalization.success.text,
                               message: "\(ResourcesFlowLocalization.trId.text) \(result?.transactionId ?? "")", okeyCompletion: { [weak self] done in
                                   guard let self = self else { return }
                                   self.delegate?.didFinishFlow(at: self)
                               })
        }
    }
}
