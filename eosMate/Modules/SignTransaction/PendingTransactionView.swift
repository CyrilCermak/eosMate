//
//  PendingTransactionsVC.swift
//  eosMate
//
//  Created by Cyril on 22/9/19.
//  Copyright © 2019 CyrilCermak. All rights reserved.
//

import UIKit
import RxSwift

class PendingTransactionsView: BaseViewWithTableView {
    var pendingTransactions = [MateTransactionRequest]() { didSet { reloadData() } }
    let selectedTransaction = PublishSubject<MateTransactionRequest>()
    let transactionToDelete = PublishSubject<MateTransactionRequest>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        errorLabel.text = SignTransactionLocalization.transactionsUnavailable.text
        tableView.register(TransactionCell.self, forCellReuseIdentifier: "TransactionCell")
    }
    
    @available(*, unavailable)  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return pendingTransactions.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let transactionCell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as? TransactionCell else {
            fatalError("Cell was not found!")
        }
        
        let transaction = pendingTransactions[indexPath.row]
        transactionCell.set(pendingTransaction: transaction)
        transactionCell.addLongTapRecognizer()
        transactionCell.longTapPressed = { [weak self] in
            self?.transactionToDelete.onNext(transaction)
        }
        return transactionCell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return TransactionCell.height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        selectedTransaction.onNext(pendingTransactions[indexPath.row])
    }
}
