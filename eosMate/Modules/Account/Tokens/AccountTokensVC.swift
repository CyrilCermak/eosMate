//
//  AccountTokensVC.swift
//  eosMate
//
//  Created by Cyril on 9/9/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AccountTokensVC: BasePopVC {
    weak var delegate: MyAccountsDelegate?
    
    let tokensView = AccountTokensView(frame: UIScreen.main.bounds)
    
    convenience init(services: Services, title: String, account: EOSAccount) {
        self.init(services: services)
        self.title = title
        loadAdditionalTokensFor(accountName: account.accountName ?? "")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = tokensView
    }
    
    private func loadAdditionalTokensFor(accountName: String) {
        var additionalTokens = AdditionalTokens()
        AdditionalTokenName.supportedTokens.enumerated().forEach { index, token in
            print("Getting - \(token.tokenAccount.account)")
            DispatchQueue.main.asyncAfter(deadline: DispatchTime.now() + Double(index / 5)) {
                self.services.blockchain.getToken(name: token.tokenAccount.account, for: accountName)
                    .subscribe(onNext: { [weak self] tokenBalance in
                        guard let self = self else { return }
                        print("Returned - \(token.tokenAccount.account)")
                        DispatchQueue.main.async {
                            additionalTokens.set(value: tokenBalance ?? "0 tokens", for: token)
                            self.tokensView.additionalTokens = additionalTokens
                        }
                    }).disposed(by: self.disposeBag)
            }
        }
    }
}
