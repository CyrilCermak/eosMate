//
//  BaseFlowVC.swift
//  eosMate
//
//  Created by Cyril Cermak on 17.04.21.
//  Copyright © 2021 CyrilCermak. All rights reserved.
//

import UIKit
import RxSwift

class BaseFlowVC: BaseVC {
    var tappedHappyCaseAt: PublishSubject<Int> {
        return baseView.tappedHappyCaseAt
    }
    
    var tappedUnhappyCaseAt: PublishSubject<Int> {
        return baseView.tappedUnhappyCaseAt
    }
    
    let baseView = BaseActionFlowView()
    var views: [UIView]? { didSet { baseView.views = views ?? [] }}
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = baseView
    }
}
