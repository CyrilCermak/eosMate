//
//  PurchaseAboutTextsView.swift
//  eosMate
//
//  Created by Cyril Cermak on 18.04.20.
//  Copyright © 2020 Cyril. All rights reserved.
//

import Foundation
import UIKit

class PlainTextInContainerCell: UITableViewCell {
    static let height: CGFloat = 108
    
    private let descriptionLabel = UILabel()
    private let checkedView = UIView()

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
        backgroundColor = UIColor.clear
        selectionStyle = .none
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    private func initView() {
        setAddedImageView()
        setDescriptionLabel()
    }

    private func setDescriptionLabel() {
        contentView.addSubview(descriptionLabel)
        descriptionLabel.numberOfLines = 0
        descriptionLabel.sizeToFit()
        descriptionLabel.textColor = UIColor.exWhite()
        descriptionLabel.font = UIFont.exFontLatoRegular(size: 16)
        descriptionLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(50)
            make.right.equalToSuperview().offset(-20)
            make.top.equalToSuperview().offset(30)
            make.bottom.equalToSuperview().offset(-25)
        }
    }
    
    private func setAddedImageView() {
        addSubview(checkedView)
        checkedView.layer.cornerRadius = 3
        checkedView.backgroundColor = UIColor.exShiningBlue()
        checkedView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(19)
            make.centerY.equalToSuperview()
            make.width.height.equalTo(10)
        }
    }
    
    func set(text: String) {
        descriptionLabel.text = text
    }
}

class BaseTextTableView: UIView, UITableViewDelegate, UITableViewDataSource {
    private var items = [String]() { didSet { tableView.reloadData() } }
    private let tableView = UITableView()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        tableView.register(PlainTextInContainerCell.self, forCellReuseIdentifier: PlainTextInContainerCell.description())
        tableView.delegate = self
        tableView.dataSource = self
        tableView.backgroundColor = .clear
        addSubview(tableView)
        tableView.snp.makeConstraints { $0.edges.equalToSuperview() }
    }
    
    @available(*, unavailable)  required init?(coder aDecoder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    
    func set(items: [String]) {
        self.items = items
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: PlainTextInContainerCell.description()) as? PlainTextInContainerCell else {
            return UITableViewCell()
        }
        
        cell.set(text: items[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
}
