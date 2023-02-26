//
//  GraphPriceView.swift
//  eosMate
//
//  Created by Cyril on 21/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import SwiftChart
import RxSwift

class GraphPriceView: UIView {
    let chart = Chart()
    var data: EOSChart? { didSet { set(data: data) } }
    let touchedGraphAtPoint = PublishSubject<String?>()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor(patternImage: UIImage(named: "vcBgGradient")!)
        setGraph()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func setGraph() {
        addSubview(chart)
        chart.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(35)
            make.left.equalToSuperview()
            make.right.bottom.equalToSuperview()
        }
        chart.showXLabelsAndGrid = true
        chart.showYLabelsAndGrid = true
        chart.delegate = self
        chart.hideHighlightLineOnTouchEnd = true
        chart.bottomInset = 0
        chart.lineWidth = 2
        chart.labelColor = UIColor.white
        chart.labelFont = UIFont.exFontLatoRegular(size: 12)
        chart.layer.masksToBounds = false
        chart.yLabelsFormatter = { index, value in
            return "\(value.roundToTwoDecimal())"
        }
        chart.showXLabelsAndGrid = false
    }
    
    private func set(data: EOSChart?) {
        guard let data = data else { return }
        let series = ChartSeries(data: data.priceDataSet)
        series.area = true
        series.color = UIColor.exShiningBlue()
        series.line = true
        chart.add(series)
    }
}

extension GraphPriceView: ChartDelegate {
    func didTouchChart(_ chart: Chart, indexes: [Int?], x: Double, left: CGFloat) {
        if let index = indexes.first {
            if let index = index {
                touchedGraphAtPoint.onNext("\(data?.priceDataSet[index].y ?? 0)")
            }
        }
    }
    
    func didFinishTouchingChart(_ chart: Chart) {
        touchedGraphAtPoint.onNext(nil)
    }
    
    func didEndTouchingChart(_ chart: Chart) {
        touchedGraphAtPoint.onNext(nil)
    }
}
