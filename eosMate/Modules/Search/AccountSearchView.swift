//
//  AccountSearchView.swift
//  eosMate
//
//  Created by Cyril on 3/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol AccountSearchViewDelegate: AnyObject {
    func didClickSearch(for name: String)
    func searchDidBecomeActive()
    func didClickOtherTokens(for account: EOSAccount)
}

class AccountSearchView: BaseViewWithTableView {
    weak var delegate: AccountSearchViewDelegate? { didSet { tableView.reloadData() }}
    let spinner = UIActivityIndicatorView()
    var account: EOSAccount?

    private var cells: [UITableViewCell] = [SearchInputCell(), AccountDetailCell()]
    private var disposeBag = DisposeBag()
    private let transactionsBtn = BaseButton(title: SearchLocalization.transactions.text,
                                             type: BaseButtonType.shinningBlue)

    let didClickTransactions = PublishSubject<Void>()
    var searchedAccount: String?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setTableView()
        addSpinner()
    }
    
    deinit { NotificationCenter.default.removeObserver(self) }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setTableView() {
        self.tableView.refreshControl = nil
        NotificationCenter.default.addObserver(forName: NSNotification.Name.baseNavScrollViewDidScroll, object: nil, queue: nil) { [weak self] notification in
            let searchCell = self?.cells.first as? SearchInputCell
            guard searchCell?.inputField.isFirstResponder ?? false else { return }
            searchCell?.inputField.resignFirstResponder()
        }
    }
    
    func set(account: EOSAccount) {
        self.account = account
        self.transactionsBtn.isEnabled = true
        self.stopSpinning()
        self.tableView.reloadData()
    }
    
    func removeAccount() {
        self.transactionsBtn.isEnabled = false
        if self.account != nil {
            self.account = nil
            self.tableView.reloadData()
            if let cell = self.cells[0] as? SearchInputCell {
                cell.inputField.becomeFirstResponder()
            }
        }
    }
    
    func addTransactionBtn() {
        self.addSubview(self.transactionsBtn)
        
        transactionsBtn.rx.tap.bind(to: self.didClickTransactions).disposed(by: disposeBag)
        transactionsBtn.isEnabled = false
        setConstraintsFor(btn: transactionsBtn)
    }
    
    func startSpinning() {
        self.spinner.isHidden = false
        self.spinner.startAnimating()
    }
    
    func stopSpinning() {
        self.spinner.isHidden = true
        self.spinner.stopAnimating()
    }
    
    private func addSpinner() {
        self.spinner.color = .exWhite()
        self.addSubview(spinner)
        spinner.snp.makeConstraints { make in
            make.width.height.equalTo(40)
            make.top.equalToSuperview().offset(isIphoneX ? SearchInputCell.height + 30 : SearchInputCell.height + 20)
            make.centerX.equalToSuperview()
        }
        stopSpinning()
    }
    
    private func setConstraintsFor(btn: UIButton) {
        btn.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(kBottomButtonInset)
        }
    }
}

// MARK: - TableView
extension AccountSearchView {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return account == nil ? 1 : cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cells[indexPath.row]
        if let cell = cell as? SearchInputCell {
            cell.delegate = delegate
        }
        if let cell = cell as? AccountDetailCell {
            if let account = account {
                cell.delegate = self
                cell.set(account: account)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return SearchInputCell.height
        case 1: return account == nil ? 0 : AccountDetailCell.height
        default: return 0
        }
    }
}

extension AccountSearchView: AccountDetailCellDelegate {
    func didClickOtherTokens() {
        guard let account = account else { return }
        delegate?.didClickOtherTokens(for: account)
    }
}
