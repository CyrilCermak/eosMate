//
//  BaseFlowImageView.swift
//  eosMate
//
//  Created by Cyril Cermak on 17.04.21.
//  Copyright © 2021 CyrilCermak. All rights reserved.
//

import RxSwift
import UIKit

class BaseDialogFlowView: UIView {
    private var headerView: DialogHeaderView = {
        let view = DialogHeaderView()
        return view
    }()
    
    private var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    private var tableView: BaseTextTableView = .init()
    
    convenience init(headerTitle: String, headerSubtitle: String, imageName: String?, alignment: NSTextAlignment, expandedImage: Bool = true, items: [String]? = nil) {
        self.init(frame: CGRect.zero)
        [headerView, imageView].forEach { addSubview($0) }
        
        setHeaderView()
        setImageView(imageName: imageName, expanded: expandedImage)
        setListView(items: items)
    
        headerView.set(header: headerTitle, subtitle: headerSubtitle, alignment: alignment)
    }
    
    @available(*, unavailable)  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    private func setHeaderView() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(self.safeArea.top).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
    }

    private func setImageView(imageName: String?, expanded: Bool) {
        guard let imageName = imageName else { return }
        guard !imageName.isEmpty else { return }
        
        imageView.image = UIImage(named: imageName)
        imageView.tintColor = UIColor.exWhite()
        imageView.snp.makeConstraints { make in
            if expanded {
                make.left.equalToSuperview().offset(24)
                make.right.equalToSuperview().offset(-24)
                make.centerY.equalToSuperview().offset(isSmallIPhone ? 0 : -30)
            } else {
                make.width.height.equalTo(50)
                make.centerX.equalToSuperview()
                make.centerY.equalToSuperview().offset(isSmallIPhone ? 0 : 40)
            }
        }
    }
    
    private func setListView(items: [String]?) {
        guard let items = items else { return }
        tableView.set(items: items)
        
        addSubview(tableView)
        tableView.snp.makeConstraints { make in
            make.left.equalToSuperview()
            make.right.equalToSuperview()
            make.top.equalTo(headerView.snp.bottom).offset(30)
            make.bottom.equalTo(self.safeAreaInsets.bottom).offset(-70)
        }
    }
}
