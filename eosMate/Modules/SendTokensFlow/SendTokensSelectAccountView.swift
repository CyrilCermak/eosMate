//
//  SendTokensSelectAccountView.swift
//  eosX
//
//  Created by Cyril on 29/9/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import RxSwift
import UIKit

class FlowSelectAccountView: BaseViewWithTableView {
    let didSelectAccount = PublishSubject<EOSAccount>()
    private var accounts = [EOSAccount]() { didSet { tableView.reloadData() } }
    private let disposeBag = DisposeBag()
    private let continueBtn = BaseButton(title: "CONTINUE", type: BaseButtonType.shinningBlue)
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.refreshControl = nil
        setAddAccountView()
        registerCell(for: MyAccountSimpleCell.self, id: "MyAccountSimpleCell")
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
    
    func setAddAccountView() {
        let bg = UIView()
        bg.backgroundColor = UIColor(patternImage: UIImage(named: "vcBgGradient")!)
        addSubview(bg)
        bg.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.height.equalTo(isIphoneX ? 85 : 90)
        }
    }
}

// MARK: - TableView
extension FlowSelectAccountView {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return 1 }
    override func numberOfSections(in tableView: UITableView) -> Int { return accounts.count }
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let account = accounts[indexPath.section]
        if let cell = tableView.dequeueReusableCell(withIdentifier: "MyAccountSimpleCell") as? MyAccountSimpleCell {
            cell.set(account: account)
            return cell
        }
        return UITableViewCell()
    }

    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return MyAccountSimpleCell.height }
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if let cell = tableView.cellForRow(at: indexPath) as? TappableCell {
            cell.didTapContentView { completed in
                self.didSelectAccount.onNext(self.accounts[indexPath.section])
            }
        }
    }

    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? { return UIView() }
    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat { return 10 }
}
