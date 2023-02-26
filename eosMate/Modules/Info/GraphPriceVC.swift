//
//  GraphPriceVC.swift
//  eosMate
//
//  Created by Cyril on 21/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit

class GraphPriceVC: BasePopVC {
    var graphData: EOSChart?
    let graphView = GraphPriceView(frame: UIScreen.main.bounds)
    let navTitle = "EOS / USD \(InfoLocalization.past24h.text)"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        observeGraphTouches()
        title = navTitle
    }
    
    convenience init(services: Services, graphData: EOSChart) {
        self.init(services: services)
        self.graphData = graphData
        graphView.data = graphData
    }
    
    override func loadView() {
        view = graphView
    }
    
    private func observeGraphTouches() {
        graphView.touchedGraphAtPoint.subscribe(onNext: { [weak self] touchedPoint in
            self?.title = touchedPoint ?? self?.navTitle
        }).disposed(by: disposeBag)
    }
}
