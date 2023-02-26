//
//  AccountDetailView.swift
//  eosMate
//
//  Created by Cyril on 6/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AccountDetailView: BaseViewWithTableView {
    var account: EOSAccount?
    let transactionBtn = BaseButton(title: SearchLocalization.transactions.text,
                                    type: BaseButtonType.shinningBlue)
    let didClickTransactions = PublishSubject<EOSAccount>()
    let didClickShowOtherTokens = PublishSubject<EOSAccount>()
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setAddTransactionButton()
        registerCell(for: MyAccountCell.self, id: "MyAccountCell")
        tableView.refreshControl = nil
    }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
    
    private func setAddTransactionButton() {
        addSubview(transactionBtn)
        transactionBtn.rx.tap
            .map { [weak self] tap -> EOSAccount? in
                return self?.account
            }
            .flatMap { Observable.from(optional: $0) }
            .bind(to: didClickTransactions).disposed(by: disposeBag)
        
        transactionBtn.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(kBottomButtonInset)
        }
    }
}

extension AccountDetailView {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let account = account {
            let detailCell = AccountDetailCell()
            detailCell.set(account: account)
            detailCell.delegate = self
            return detailCell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if account != nil {
            return AccountDetailCell.height
        }
        return CGFloat.leastNormalMagnitude
    }
}

extension AccountDetailView: AccountDetailCellDelegate {
    func didClickOtherTokens() {
        guard let account = account else { return }
        didClickShowOtherTokens.onNext(account)
    }
}
