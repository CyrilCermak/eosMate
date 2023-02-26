//
//  SignTransactionView.swift
//  eosMate
//
//  Created by Cyril Cermak on 07.06.20.
//  Copyright © 2020 CyrilCermak. All rights reserved.
//

import UIKit
import RxSwift

class SignTransactionView: BaseViewWithTableView {
    var transaction: MateTransactionRequest? { didSet { updateView() }}
    let didSelectParametrs = PublishSubject<MateTransactionRequest>()
    let didTapSign = PublishSubject<Void>()

    private let signButton = BaseButton(title: SignTransactionLocalization.sign.text,
                                        type: BaseButtonType.shinningBlue)
    private let disposeBag = DisposeBag()
    
    @available(*, unavailable)  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    private var cells: [UITableViewCell] = []
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setSignButton()
        tableView.refreshControl = nil
    }
    
    private func updateView() {
        guard let tr = transaction else { return }
        
        let nameCell = InfoInputCell()
        nameCell.set(text: tr.transactionName, withInfo: SignTransactionLocalization.signName.text)
        
        let accountNameCell = InfoInputCell()
        accountNameCell.set(text: tr.accountName, withInfo: SignTransactionLocalization.signAccount.text)
        
        let tableNameCell = InfoInputCell()
        tableNameCell.set(text: tr.tableName, withInfo: SignTransactionLocalization.signTable.text)
        
        let actionCell = InfoInputCell()
        actionCell.set(text: tr.action, withInfo: SignTransactionLocalization.signAction.text)
        
        let parametersCell = UnlimitedInfoCell()
        if let data = Data(base64Encoded: tr.parameters), let string = String(data: data, encoding: .utf8) {
            parametersCell.set(text: string, withInfo: SignTransactionLocalization.signParams.text)
        }
        
        self.cells = [
            nameCell, accountNameCell, tableNameCell, actionCell, parametersCell
        ]
        
        self.tableView.reloadData()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cells.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return cells[indexPath.row]
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if cells[indexPath.row] is InfoInputCell {
            return InfoInputCell.height
        }
        return UnlimitedInfoCell.height
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard indexPath.row == 4 else { return }
        guard let transaction = transaction else { return }
        didSelectParametrs.onNext(transaction)
    }
    
    private func setSignButton() {
        self.addSubview(signButton)
        signButton.rx.tap.bind(to: self.didTapSign).disposed(by: disposeBag)
        signButton.snp.makeConstraints { make in
            make.height.equalTo(52)
            make.left.equalToSuperview().offset(12)
            make.right.equalToSuperview().offset(-12)
            make.bottom.equalToSuperview().offset(kBottomButtonInset)
        }
    }
}
