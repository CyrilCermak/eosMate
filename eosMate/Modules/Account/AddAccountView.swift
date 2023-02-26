//
//  AddAccountView.swift
//  eosMate
//
//  Created by Cyril on 5/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

class AddAccountView: BaseViewWithTableView, HasSpinningCell {
    weak var delegate: AccountSearchViewDelegate?
    var hasSpinningProgress: Bool = false { didSet { reloadData() }}
    
    let closeButton = UIButton()
    let didClickAdd = PublishSubject<Void>()
    let didClickDone = PublishSubject<Void>()
    var account: EOSAccount?
    let pk = Variable<String?>(nil)
    
    fileprivate var cells: [UITableViewCell] = [SearchInputCell()]
    private let addAccountBtn = BaseButton(title: AccountFlowLocalization.addAccount.text,
                                           type: BaseButtonType.shinningBlue)
    private let disposeBag = DisposeBag()
    
    @available(*, unavailable)  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
        addAddAccountButton()
    }
    
    private func initView() {
        self.backgroundColor = UIColor(patternImage: UIImage(named: "vcBgGradient")!)
        self.addSubview(closeButton)
        self.closeButton.setImage(UIImage(named: "btnCancelGrey"), for: .normal)
        self.closeButton.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(20)
            make.right.equalToSuperview().offset(-10)
            make.width.height.equalTo(44)
        }
        self.tableView.snp.remakeConstraints { make in
            make.top.equalToSuperview().offset(64)
            make.left.right.bottom.equalToSuperview()
        }
        
        let addAccountCell = AddAccountCell()
        addAccountCell.didClickDone.bind(to: didClickDone).disposed(by: disposeBag)
        addAccountCell.observedText.bind(to: pk).disposed(by: disposeBag)
        
        self.cells.append(addAccountCell)
    }
    
    func addAddAccountButton() {
        self.addSubview(self.addAccountBtn)
        addAccountBtn.rx.tap.bind(to: self.didClickAdd).disposed(by: disposeBag)
        addAccountBtn.isEnabled = false
        setConstraintsFor(btn: addAccountBtn)
    }
    
    func set(account: EOSAccount) {
        self.account = account
        self.addAccountBtn.isEnabled = true
        self.tableView.reloadData()
    }
    
    func removeAccount() {
        self.addAccountBtn.isEnabled = false
        if self.account != nil {
            self.account = nil
            self.tableView.reloadData()
            if let cell = self.cells[0] as? SearchInputCell {
                cell.inputField.becomeFirstResponder()
            }
        }
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
extension AddAccountView {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if hasSpinningProgress {
            return 2
        }
        return account == nil ? 1 : cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = cells[indexPath.row]
        if let cell = cell as? SearchInputCell {
            cell.delegate = delegate
        }
        if indexPath.row == 1, hasSpinningProgress {
            return SpinningCell()
        }
        if let cell = cell as? AddAccountCell {
            if let account = account {
                cell.set(account: account)
            }
        }
        return cell
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        switch indexPath.row {
        case 0: return SearchInputCell.height
        case 1:
            if hasSpinningProgress {
                return 44
            }
            return account == nil ? 0 : AddAccountCell.height
        default: return 0
        }
    }
}
