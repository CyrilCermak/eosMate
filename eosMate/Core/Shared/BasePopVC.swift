//
//  BasePopVC.swift
//  eosMate
//
//  Created by Cyril on 22/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.

import Foundation
import UIKit
import RxSwift

class BasePopVC: BaseVC {
    let didClickClose = PublishSubject<Void>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setNavigation()
    }
    
    private func setNavigation() {
        navigationController?.isNavigationBarHidden = false
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: UIImage(named: "btnCancelGrey"), style: .done, target: self, action: #selector(didClickCloseBtn))
    }
    
    @objc func didClickCloseBtn() {
        didClickClose.onNext(())
    }
}
