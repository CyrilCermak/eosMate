//
//  GraphCell.swift
//  eosMate
//
//  Created by Cyril on 6/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import SwiftChart
import RxSwift

class GraphCell: UITableViewCell {
    static let height: CGFloat = 200
    let chart = Chart()
    let nameLabel = UILabel()
    let dateLabel = UILabel()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        setContentView()
        setGraph()
        setNameLabel()
        setDateLabel()
    }
    
    private func setContentView() {
        contentView.snp.remakeConstraints { make in
            make.left.equalToSuperview().offset(15)
            make.right.equalToSuperview().offset(-15)
            make.top.equalToSuperview().offset(10)
            make.bottom.equalToSuperview().offset(-10)
        }
        contentView.addCellShadow(for: CGSize(width: screenSize.width - 30, height: GraphCell.height - 20))
        contentView.layer.cornerRadius = 10
        contentView.backgroundColor = UIColor.exDarkBlue()
        backgroundColor = .clear
        selectionStyle = .none
    }
    
    private func setGraph() {
        contentView.addSubview(chart)
        chart.isUserInteractionEnabled = false
        chart.snp.makeConstraints { make in
            make.top.equalToSuperview().offset(35)
            make.left.equalToSuperview()
            make.right.bottom.equalToSuperview()
        }
        chart.axesColor = UIColor.clear
        chart.gridColor = UIColor.clear
        chart.bottomInset = 0
        chart.lineWidth = 2
        chart.labelColor = UIColor.white
        chart.hideHighlightLineOnTouchEnd = true
        chart.highlightLineColor = UIColor.clear
        chart.labelFont = UIFont.exFontLatoRegular(size: 12)
        chart.layer.masksToBounds = false
        let mask = CALayer()
        mask.frame = CGRect(x: 0, y: 0, width: screenSize.width - 30, height: 145)
        mask.backgroundColor = UIColor.red.cgColor
        mask.cornerRadius = 10
        chart.layer.mask = mask
        chart.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        chart.yLabelsFormatter = { index, value in
            return "\(value.roundToTwoDecimal())"
        }
        chart.showXLabelsAndGrid = false
    }
    
    private func setNameLabel() {
        contentView.addSubview(nameLabel)
        nameLabel.text = "EOS/USD"
        nameLabel.textColor = .white
        nameLabel.font = UIFont.exFontLatoBold(size: 14)
        nameLabel.snp.makeConstraints { make in
            make.left.top.equalToSuperview().offset(15)
        }
    }
    
    private func setDateLabel() {
        contentView.addSubview(dateLabel)
        dateLabel.text = InfoLocalization.span24h.text
        dateLabel.textColor = .white
        dateLabel.font = UIFont.exFontLatoBold(size: 14)
        dateLabel.snp.makeConstraints { make in
            make.top.equalTo(self.nameLabel)
            make.right.equalToSuperview().offset(-15)
        }
    }
    
    func set(data: EOSChart?) {
        guard let data = data else { return }
        let series = ChartSeries(data: data.priceDataSet)
        series.area = true
        series.color = UIColor.exShiningBlue()
        series.line = true
        chart.add(series)
    }
}
