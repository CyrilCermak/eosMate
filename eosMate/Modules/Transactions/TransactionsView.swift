//
//  TransactionsView.swift
//  eosMate
//
//  Created by Cyril on 10/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

enum TransactionTabBarItem: Int, CaseIterable {
    case all, apps, transfers, stake, ram
    
    var string: String {
        switch self {
        case .all: return TransactionsLocalization.all.text
        case .apps: return TransactionsLocalization.apps.text
        case .transfers: return TransactionsLocalization.transfers.text
        case .stake: return TransactionsLocalization.stake.text
        case .ram: return TransactionsLocalization.ram.text
        }
    }
    
    static var items: [String] {
        return TransactionTabBarItem.allCases.map { $0.string }
    }
}

class TransactionsView: BaseViewWithTableView {
    var transactions: [EOSXTransaction]? { didSet { updateFilteredTransactions(for: currentState) } }
    var filteredTransactions: [EOSXTransaction]? { didSet { reloadData() } }
    var accountName: String = ""
    let selectedTransaction = PublishSubject<EOSXTransaction>()
    let switchingTabBar = SwitchingTabBar()
    var currentState: TransactionTabBarItem = .all
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        registerCell(for: TransactionCell.self, id: "TransactionCell")
        errorLabel.text = TransactionsLocalization.upps.text
        addTabBar()
        updateViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func addTabBar() {
        addSubview(switchingTabBar)
        switchingTabBar.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(SwitchingTabBar.height)
        }
        switchingTabBar.set(titles: TransactionTabBarItem.items)
        switchingTabBar.state.asObservable().subscribe(onNext: { [weak self] index in
            guard let self = self else { return }
            self.currentState = TransactionTabBarItem(rawValue: index) ?? .all
            self.updateFilteredTransactions(for: self.currentState)
        }).disposed(by: disposeBag)
        
        bringSubview(toFront: switchingTabBar)
    }
    
    private func updateViewConstraints() {
        tableView.snp.updateConstraints { make in
            make.top.equalToSuperview().offset(SwitchingTabBar.height + 5)
        }
    }
    
    private func updateFilteredTransactions(for item: TransactionTabBarItem) {
        switch item {
        case .all:
            filteredTransactions = transactions
        case .apps:
            filteredTransactions = transactions?.filter { $0.transactionType == .unknown || $0.transactionType == .toWithMessage }
        case .ram:
            filteredTransactions = transactions?.filter { $0.transactionType == .buyRam || $0.transactionType == .sellRam }
        case .stake:
            filteredTransactions = transactions?.filter { $0.transactionType == .stakeTransfer || $0.transactionType == .unstakeTransfer }
        case .transfers:
            filteredTransactions = transactions?.filter { $0.transactionType == .transfer }
        }
        DispatchQueue.main.async {
            self.tableView.reloadData()
            if (self.filteredTransactions?.count ?? 0) > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
            }
        }
    }
}

extension TransactionsView {
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let transaction = filteredTransactions?[indexPath.row] else { return UITableViewCell() }
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TransactionCell") as? TransactionCell else {
            return UITableViewCell()
        }
        switch transaction.transactionType {
        case .buyRam:
            guard let buyRam = transaction.payload as? BuyRam else { return UITableViewCell() }
            cell.set(buyRam: buyRam, transaction: transaction, accountName: accountName)
        case .sellRam:
            guard let sellRam = transaction.payload as? SellRam else { return UITableViewCell() }
            cell.set(sellRam: sellRam, transaction: transaction, accountName: accountName)
        case .stakeTransfer:
            guard let stakeTransfer = transaction.payload as? StakeTransfer else { return UITableViewCell() }
            cell.set(stake: stakeTransfer, transaction: transaction, accountName: accountName)
        case .unstakeTransfer:
            guard let unstakeTransfer = transaction.payload as? UnstakeTransfer else { return UITableViewCell() }
            cell.set(unstake: unstakeTransfer, transaction: transaction, accountName: accountName)
        case .toWithMessage:
            guard let toWithMessage = transaction.payload as? ToWithMessage else { return UITableViewCell() }
            cell.set(toWith: toWithMessage, transaction: transaction, accountName: accountName)
        case .transfer:
            guard let tr = transaction.payload as? Transfer else { return UITableViewCell() }
            cell.set(tr: tr, transaction: transaction, accountName: accountName)
        case .unknown:
            cell.set(unknown: transaction, accountName: accountName)
        }

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let transaction = filteredTransactions?[indexPath.row] else { return }
        
        selectedTransaction.onNext(transaction)
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return filteredTransactions?.count ?? 0
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        guard let _ = filteredTransactions?[indexPath.row] else { return CGFloat.leastNormalMagnitude }
        if let _ = transactions {
            return TransactionCell.height
        }
        return CGFloat.leastNormalMagnitude
    }
}
