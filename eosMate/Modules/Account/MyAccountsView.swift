//
//  AccountView.swift
//  eosMate
//
//  Created by Cyril on 5/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class MyAccountsView: BaseViewWithTableView {
    var accounts = [EOSAccount]() { didSet { tableView.reloadData() } }

    let addAccountBtn = BaseButton(title: AccountFlowLocalization.addAccount.text.uppercased(),
                                   type: BaseButtonType.shinningBlue)
    private let disposeBag = DisposeBag()
    let didSelectAccount = PublishSubject<EOSAccount>()
    let didTapDeleteAccount = PublishSubject<EOSAccount>()
    var didClickAdd = PublishSubject<Void>()

    override init(frame: CGRect) {
        super.init(frame: frame)
        setAddAccountView()
        registerCell(for: MyAccountSimpleCell.self, id: "MyAccountSimpleCell")
        updateTableViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func add(account: EOSAccount) {
        guard accounts.map({ $0.accountName ?? "" }).contains(account.accountName ?? "") == false else {
            return update(account: account)
        }
        accounts.append(account)
        tableView.reloadData()
    }
    
    func update(account: EOSAccount) {
        guard let index = accounts.index(where: { account.accountName ?? "" == $0.accountName ?? "" }) else { return }
        accounts[index] = account
        tableView.reloadData()
    }
    
    private func updateTableViewConstraints() {
        tableView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(isIphoneX ? 40 : 20)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(self.addAccountBtn.snp.top).offset(-25)
        }
    }
    
    func setAddAccountView() {
        let bg = UIView()
        bg.backgroundColor = UIColor(patternImage: UIImage(named: "vcBgGradient")!)
        addSubview(bg)
        bg.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(isIphoneX ? 85 : 90)
        }
        bg.addSubview(addAccountBtn)

        addAccountBtn.rx.tap.bind(to: didClickAdd).disposed(by: disposeBag)
        addAccountBtn.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(kBottomButtonInset)
        }
    }
    
    func remove(account: EOSAccount) {
        if let indexToDelete = accounts.index(where: { $0.accountName ?? "" == account.accountName ?? "" }) {
            accounts.remove(at: indexToDelete)
            tableView.reloadData()
        }
    }
}

// MARK: - TableView
extension MyAccountsView {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return accounts.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let account = accounts[indexPath.section]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyAccountSimpleCell") as? MyAccountSimpleCell {
            cell.set(account: account)
            cell.delegate = self
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return MyAccountSimpleCell.height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let account = accounts[indexPath.section]
        if let cell = tableView.cellForRow(at: indexPath) as? TappableCell {
            cell.didTapContentView { completed in
                self.didSelectAccount.onNext(account)
            }
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return UIView() }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 10 }
}

extension MyAccountsView: MyAccountCellDelegate {
    func didLongTap(account: EOSAccount) {
        didTapDeleteAccount.onNext(account)
    }
}
