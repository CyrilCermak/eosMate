//
//  AnalyticsView.swift
//  eosMate
//
//  Created by Cyril Cermak on 14.06.20.
//  Copyright © 2020 CyrilCermak. All rights reserved.
//

import UIKit

class BaseDialogView: UIView {
    var enableButton = BaseButton(title: "", type: .shinningBlue)
    var disableButton = BaseButton(title: "", type: .shadow)
    
    var closeBtn: UIButton = {
        let closeBtn = UIButton()
        closeBtn.setImage(UIImage(named: "btn_cancel"), for: .normal)
        return closeBtn
    }()
    
    private var headerView: DialogHeaderView = {
        let view = DialogHeaderView()
        return view
    }()
    
    private var promoLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.exFontLatoRegular(size: 22)
        label.textAlignment = .center
        label.textColor = UIColor.exWhite()
        label.adjustsFontSizeToFitWidth = true
        label.numberOfLines = 0
        return label
    }()
    
    private var promoImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    convenience init(headerTitle: String, headerSubtitle: String, promoText: String, enableText: String, disableText: String, image: UIImage? = nil) {
        self.init(frame: CGRect.zero)
        headerView.set(header: headerTitle, subtitle: headerSubtitle, alignment: .left)
        promoLabel.text = promoText
        enableButton.setTitle(enableText, for: .normal)
        disableButton.setTitle(disableText, for: .normal)
        
        if let image = image {
            promoLabel.isHidden = true
            promoImageView.image = image
            setPromoImageView()
        }
    }
    
    @available(*, unavailable)  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        [headerView, promoLabel, enableButton, closeBtn, disableButton].forEach { addSubview($0) }
        backgroundColor = UIColor.exDarkBlue()
        
        setHeaderView()
        setPromoLabel()
        setEnableBtn()
        setDisableBtn()
        setCloseButton()
    }

    private func setHeaderView() {
        headerView.snp.makeConstraints { make in
            make.top.equalTo(self.safeArea.top).offset(10)
            make.left.right.equalToSuperview()
            make.height.equalTo(100)
        }
    }

    private func setPromoLabel() {
        promoLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview().offset(isSmallIPhone ? 0 : -30)
        }
    }
    
    private func setEnableBtn() {
        enableButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalTo(self.safeArea.bottom).offset(-24)
            make.height.equalTo(52)
        }
    }
    
    private func setDisableBtn() {
        disableButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalTo(self.enableButton.snp.top).offset(-10)
            make.height.equalTo(52)
        }
    }
    
    private func setCloseButton() {
        closeBtn.snp.makeConstraints { make in
            make.top.equalTo(self.safeArea.top)
            make.right.equalToSuperview().offset(-5)
            make.width.height.equalTo(44)
        }
    }
    
    private func setPromoImageView() {
        addSubview(promoImageView)
        promoImageView.tintColor = UIColor.exWhite()
        promoImageView.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.centerY.equalToSuperview().offset(isSmallIPhone ? 0 : -30)
        }
    }
}
