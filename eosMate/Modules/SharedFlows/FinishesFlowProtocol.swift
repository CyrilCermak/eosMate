//
//  FinishesFlowProtocol.swift
//  eosMate
//
//  Created by Cyril on 21/10/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation

protocol FinishesFlow: AnyObject {
    func didFinishFlow(at vc: BaseVC)
}

extension FinishesFlow {
    func didFinishFlow(at vc: BaseVC) {
        vc.dismiss(animated: true, completion: nil)
    }
}
