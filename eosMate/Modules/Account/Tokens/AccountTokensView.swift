//
//  AccountTokensView.swift
//  eosMate
//
//  Created by Cyril on 9/9/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

class AccountTokensView: BaseViewWithTableView {
    var additionalTokens: AdditionalTokens? { didSet { self.tableView.reloadData() } }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        tableView.refreshControl = nil
        tableView.rowHeight = AdditionalTokensCell.height
        tableView.estimatedRowHeight = AdditionalTokensCell.height
        registerCell(for: AdditionalTokensCell.self, id: "AdditionalTokensCell")
    }
    
    required init?(coder aDecoder: NSCoder) { super.init(coder: aDecoder) }
}

extension AccountTokensView {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let cell = tableView.dequeueReusableCell(withIdentifier: "AdditionalTokensCell") as? AdditionalTokensCell {
            cell.set(tokens: additionalTokens)
            return cell
        }
        return UITableViewCell()
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return AdditionalTokensCell.height
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return AdditionalTokensCell.height
    }
}
