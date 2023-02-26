//
//  TermsAndCond.swift
//  eosMate
//
//  Created by Cyril on 29/10/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

protocol TermsAndCondDelegate: AnyObject {
    func userDidTapAcceptTaC(at vc: BaseVC)
}

class TermsAndCondVC: BaseVC {
    weak var delegate: TermsAndCondDelegate?
    let termsAndCondView = TermsAndCondView(frame: screenSize)
    
    convenience init(services: Services) {
        self.init()
        self.services = services
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = InfoLocalization.tac.text
        bindButton()
    }
    
    override func loadView() {
        view = termsAndCondView
    }
    
    private func bindButton() {
        termsAndCondView.acceptBtn.rx.tap.subscribe(onNext: { [weak self] tap in
            guard let self = self else { return }
            UserDefaultsService.shared.userDidReadTermsAndCond()
            self.delegate?.userDidTapAcceptTaC(at: self)
        }).disposed(by: disposeBag)
    }
}
