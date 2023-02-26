//
//  RequestTransactionSummaryView.swift
//  eosMate
//
//  Created by Cyril Cermak on 07.06.20.
//  Copyright © 2020 CyrilCermak. All rights reserved.
//

import UIKit

class RequestTransactionSummaryView: BaseFlowSummaryView, HasSpinningCell {
    var requestType: TransactionRequestType? { didSet { tableView.reloadData() }}
    var fromAccount: EOSAccount? { didSet { self.tableView.reloadData() }}
    var toAccount: EOSAccount? { didSet { self.tableView.reloadData() }}
    var eosAmount: String? { didSet { self.tableView.reloadData() }}
    
    @available(*, unavailable)  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setCells()
        sendButton.setTitle(RequestTransactionLocalization.request.text,
                            for: .normal)
    }
    
    private func setCells() {
        self.cells = [InfoInputCell(), InfoInputCell(), InfoInputCell(), InfoInputCell()]
    }
    
    func checkForButton() {
        sendButton.isEnabled = fromAccount != nil && toAccount != nil && eosAmount != nil
    }
}

extension RequestTransactionSummaryView {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if hasSpinningProgress, indexPath.row == cells.count { return SpinningCell() }
        let cell = cells[indexPath.row]
        cell.inputField.isUserInteractionEnabled = false
        switch indexPath.row {
        case 0: cell.set(text: requestType?.detailName ?? "",
                         withInfo: RequestTransactionLocalization.summeryTransaction.text)
            
        case 1: cell.set(text: fromAccount?.accountName ?? "",
                         withInfo: RequestTransactionLocalization.summeryRequestFrom.text)
            
        case 2: cell.set(text: toAccount?.accountName ?? "",
                         withInfo: RequestTransactionLocalization.summerySendTo.text)
            
        case 3: cell.set(text: eosAmount ?? "",
                         withInfo: RequestTransactionLocalization.summeryAmount.text)
            
        default: break
        }
        
        return cell
    }
}
