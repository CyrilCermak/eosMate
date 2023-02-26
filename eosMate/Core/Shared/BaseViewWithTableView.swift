//
//  BaseTableView.swift
//  eosMate
//
//  Created by Cyril on 19/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

class BaseViewWithTableView: UIView {
    let tableView = UITableView()
    
    lazy var errorLabel: UILabel = {
        let label = UILabel()
        label.font = .exFontLatoRegular(size: 12)
        label.textColor = .exWhite()
        label.numberOfLines = 0
        label.isHidden = true
        label.textAlignment = .center
        return label
    }()
    
    var refreshControl: UIRefreshControl = {
        let refreshControl = UIRefreshControl()
        refreshControl.tintColor = UIColor.white
        return refreshControl
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initTableView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func initTableView() {
        backgroundColor = UIColor(patternImage: UIImage(named: "vcBgGradient")!)
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.refreshControl = refreshControl
        tableView.delegate = self
        tableView.dataSource = self
        tableView.clipsToBounds = false
        tableView.separatorStyle = .none
        tableView.backgroundColor = .clear
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(isIphoneX ? 40 : 20)
            make.left.right.equalToSuperview()
            make.bottom.equalToSuperview()
        }
        
        addSubview(errorLabel)
        errorLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(tableView.snp.top).offset(20)
        }
    }
    
    func startRefreshing() {
        errorLabel.isHidden = true
        tableView.refreshControl = refreshControl
        tableView.contentOffset = CGPoint(x: 0, y: -refreshControl.frame.size.height)
        refreshControl.beginRefreshing()
    }
    
    func showError() {
        stopRefreshing()
        errorLabel.isHidden = false
    }
    
    func stopRefreshing() {
        tableView.contentOffset = CGPoint(x: 0, y: 0)
        refreshControl.endRefreshing()
    }
    
    func reloadData() {
        tableView.reloadData()
        tableView.contentOffset = CGPoint(x: 0, y: 0)
        refreshControl.endRefreshing()
    }
    
    func registerCell(for aClass: AnyClass, id: String) {
        tableView.register(aClass, forCellReuseIdentifier: id)
    }
}

extension BaseViewWithTableView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {}
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 0
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableViewAutomaticDimension
    }
}
