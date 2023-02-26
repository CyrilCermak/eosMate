//
//  AppFlow.swift
//  eosMate
//
//  Created by Cyril on 08/05/17.
//  Copyright © 2017 Cyril. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AppFlow {
    let services: Services = EOSServices()
    let disposeBag = DisposeBag()
    var navController: BaseNavigationController!
    var currentVC: UIViewController? {
        return navController.viewControllers.last
    }
    
    let baseTopNav: BaseTopNavVC
    
    init() {
        baseTopNav = BaseTopNavVC(services: services)
        baseTopNav.delegate = self
        navController = BaseNavigationController(rootViewController: baseTopNav)
    }
}

extension AppFlow: BaseNavDelegate {
    func wantsToShowMenu() {
        let vc = MenuVC(services: services)
        vc.didClickClose.subscribe(onNext: { [weak vc] tapped in
            vc?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        vc.wantsToShow.subscribe(onNext: { [weak vc, weak self] item in
            guard let vc = vc, let self = self else { return }
            
            var pushVC: UIViewController?
            switch item {
            case .about:
                UIApplication.shared.open(URL(string: Configuration.eosMateWeb)!, options: [:], completionHandler: nil)
                return
            case .support:
                UIApplication.shared.open(URL(string: Configuration.eosMateTelegram)!, options: [:], completionHandler: nil)
                return
            case .removePKs:
                let removePKsVC = RemoveAllPKsVC(services: self.services)
                pushVC = removePKsVC
            case .analytics:
                let vc = AnalyticsVC(services: self.services)
                vc.shouldDisableAnalyticsOnCloseButton = false
                pushVC = vc
            case .tac:
                pushVC = BaseHtmlContentVC(services: self.services, contentType: .tac, title: item.name)
            case .privacyPolicy:
                pushVC = BaseHtmlContentVC(services: self.services, contentType: .privacyPolicy, title: item.name)
            case .imprint:
                pushVC = BaseHtmlContentVC(services: self.services, contentType: .imprint, title: item.name)
            }
            
            (pushVC as? BasePopVC)?.didClickClose.subscribe(onNext: { [weak pushVC] tapped in
                pushVC?.navigationController?.popViewController(animated: true)
            }).disposed(by: self.disposeBag)
            
            vc.navigationController?.pushViewController(pushVC ?? UIViewController(), animated: true)
        }).disposed(by: disposeBag)
        navController.present(BasePopNavigationController(rootViewController: vc), animated: true, completion: nil)
    }
    
    func wantsToshowOnboarding() {
        let onboardingFlowVC = FirstLoginFlowVC(services: services)
        onboardingFlowVC.modalPresentationStyle = .fullScreen
        onboardingFlowVC.wantsToClose = { [weak onboardingFlowVC] in onboardingFlowVC?.dismiss(animated: true, completion: nil) }
        onboardingFlowVC.wantsToAddAccount = { [weak self, weak onboardingFlowVC] in
            guard let self = self else { return }
            self.baseTopNav.topNavView.moveScrollView(toFront: true)
            
            onboardingFlowVC?.dismiss(animated: true, completion: {
                self.wantsToAddAccount(at: self.baseTopNav.accountVC)
            })
        }
        navController.present(onboardingFlowVC, animated: true, completion: nil)
    }
}

extension AppFlow: TermsAndCondDelegate {
    func userDidTapAcceptTaC(at vc: BaseVC) {
        let analyticsVC = AnalyticsVC(services: services)
        analyticsVC.shouldDisableAnalyticsOnCloseButton = true
        analyticsVC.hideDisableButton()
        analyticsVC.didClickClose.subscribe(onNext: { tapped in
            analyticsVC.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        vc.dismiss(animated: true, completion: {
            self.navController.present(BasePopNavigationController(rootViewController: analyticsVC), animated: true, completion: nil)
        })
    }
}

extension AppFlow: AccountSearchDelegate {
    func presentTransactions(for account: EOSAccount) {
        let transactionVC = TransactionsVC(services: services, account: account)
        transactionVC.didClickClose.subscribe(onNext: { [weak transactionVC] clicked in
            transactionVC?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        transactionVC.selectedAccount.subscribe(onNext: { [weak self, weak transactionVC] selectedAccount in
            guard let transactionVC = transactionVC else { return }
            self?.showTransactionsFor(account: selectedAccount, at: transactionVC)
        }).disposed(by: disposeBag)
        
        currentVC?.present(BaseNavigationController(rootViewController: transactionVC), animated: true, completion: nil)
    }
    
    private func showTransactionsFor(account: EOSAccount, at vc: TransactionsVC) {
        let transactionVC = TransactionsVC(services: services, account: account)
        transactionVC.didClickClose.subscribe(onNext: { [weak transactionVC] clicked in
            transactionVC?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)

        transactionVC.selectedAccount.subscribe(onNext: { [weak self, weak transactionVC] selectedAccount in
            guard let transactionVC = transactionVC else { return }
            self?.showTransactionsFor(account: selectedAccount, at: transactionVC)
        }).disposed(by: disposeBag)
        
        vc.navigationController?.pushViewController(transactionVC, animated: true)
    }
    
    func presentOtherTokens(for account: EOSAccount) {
        let tokensVC = AccountTokensVC(services: services, title: CoreLocalization.tokens.text,
                                       account: account)
        tokensVC.didClickClose.subscribe(onNext: { [weak tokensVC] tap in
            tokensVC?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        currentVC?.present(BasePopNavigationController(rootViewController: tokensVC), animated: true, completion: nil)
    }
}

extension AppFlow: MyAccountsDelegate {
    func showAccountDetail(for account: EOSAccount, at vc: BaseVC) {
        let detailVC = AccountDetailVC(services: services, title: account.accountName ?? "", account: account)
        detailVC.didClickClose.subscribe(onNext: { [weak detailVC] close in
            detailVC?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        detailVC.didClickTransaction.subscribe(onNext: { [weak self] account in
            detailVC.dismiss(animated: true, completion: { [weak self] in
                self?.presentTransactions(for: account)
            })
        }).disposed(by: disposeBag)
        
        detailVC.didClickOtherTokens.asDriver(onErrorJustReturn: EOSAccount(accountName: ""))
            .drive(onNext: { account in
                detailVC.dismiss(animated: true, completion: { [weak self] in
                    self?.presentOtherTokens(for: account)
                })
            }).disposed(by: disposeBag)
        currentVC?.present(BasePopNavigationController(rootViewController: detailVC), animated: true, completion: nil)
    }
    
    func wantsToAddAccount(at vc: MyAccountsVC) {
        let addAccountVC = AddAccountVC(services: services)
        addAccountVC.didClickClose.subscribe(onNext: { tap in
            addAccountVC.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        addAccountVC.didAddedAccount.subscribe(onNext: { [weak vc] account in
            vc?.didAdded(account: account)
        }).disposed(by: disposeBag)
        addAccountVC.didClickOtherTokens.asDriver(onErrorJustReturn: EOSAccount(accountName: ""))
            .drive(onNext: { account in
                addAccountVC.dismiss(animated: true, completion: { [weak self] in
                    self?.presentOtherTokens(for: account)
                })
            }).disposed(by: disposeBag)
        
        currentVC?.present(addAccountVC, animated: true, completion: nil)
    }
}

extension AppFlow: ChainInfoDelegate {
    func wantsToShowGraphDetail(with data: EOSChart) {
        let graphVC = GraphPriceVC(services: services, graphData: data)
        graphVC.didClickClose.subscribe(onNext: { [weak graphVC] tap in
            graphVC?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        currentVC?.present(BasePopNavigationController(rootViewController: graphVC), animated: true, completion: nil)
    }
    
    func wantsToSendTokensFlow() {
        let vc = SendTokensFlowVC(services: services)
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        currentVC?.present(vc, animated: true, completion: nil)
    }
    
    func wantsToShowRamFlow() {
        let vc = RamFlowVC(services: services)
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        currentVC?.present(vc, animated: true, completion: nil)
    }
    
    func wantsToShowResroucesFlow() {
        let vc = ResourceFlowVC(services: services)
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        currentVC?.present(vc, animated: true, completion: nil)
    }
    
    func wantsToDoTransactionRequest() {
        let vc = RequestTransactionFlowVC(services: services)
        vc.modalPresentationStyle = .overFullScreen
        vc.delegate = self
        currentVC?.present(vc, animated: true, completion: nil)
    }
    
    func wantsToShowPendingTransactions() {
        let vc = PendingTransactionsVC(services: services, title: CoreLocalization.trToSign.text)
        vc.didClickClose.subscribe(onNext: { [weak vc] tapped in
            vc?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        
        vc.didSelect = { [weak self] pendingTransaction, vc in
            self?.didSelect(pendingTransaction: pendingTransaction, at: vc)
        }
        currentVC?.present(BasePopNavigationController(rootViewController: vc), animated: true, completion: nil)
    }
}

extension AppFlow {
    func presentAppStoreRatingDialog() {
        guard services.analytics.shouldShowAppStoreReview() else { return }

        guard navController.presentedViewController == nil else { return }
        
        let vc = AppStoreRatingVC(services: services)
        vc.didClickClose
            .subscribe(onNext: { [weak vc] in vc?.dismiss(animated: true, completion: nil) })
            .disposed(by: disposeBag)
        
        // Waiting 1 second to load the dashboard first
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.navController.present(BasePopNavigationController(rootViewController: vc), animated: true, completion: nil)
        }
    }
}

/// Pending transaction detail
extension AppFlow {
    func didSelect(pendingTransaction: MateTransactionRequest, at vc: PendingTransactionsVC) {
        let signTransactionVC = SignTransactionVC(services: services)
        signTransactionVC.transaction = pendingTransaction
        signTransactionVC.didClickClose.subscribe(onNext: { [weak signTransactionVC] () in
            signTransactionVC?.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        signTransactionVC.transactionSigend.subscribe(onNext: { [weak vc] transaction in
            vc?.signed(transaction: transaction)
        }).disposed(by: disposeBag)
        vc.navigationController?.pushViewController(signTransactionVC, animated: true)
    }
}

extension AppFlow: FinishesFlow {
    func didFinishFlow(at vc: BaseVC) {
        vc.dismiss(animated: true, completion: nil)
    }
}

extension AppFlow {
    func presentSign(transaction: MateTransactionRequest) {
        let vc = SignTransactionVC(services: services)
        vc.transaction = transaction
        vc.didClickClose.subscribe(onNext: { tap in
            vc.dismiss(animated: true, completion: nil)
        }).disposed(by: disposeBag)
        currentVC?.present(BasePopNavigationController(rootViewController: vc), animated: true, completion: nil)
    }
}
