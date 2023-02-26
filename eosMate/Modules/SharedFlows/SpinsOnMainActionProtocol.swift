//
//  SpinsOnMainActionProtocol.swift
//  eosMate
//
//  Created by Cyril on 21/10/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

enum SpinnerAction {
    case active, stopped
}

protocol SpinsOnMainAction {
    func setSpinnerTo(action: SpinnerAction)
}
