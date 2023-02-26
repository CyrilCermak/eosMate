//
//  ChainInfoVC.swift
//  eosMate
//
//  Created by Cyril on 1/8/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import RxSwift

protocol ChainInfoDelegate: AnyObject {
    func wantsToShowGraphDetail(with data: EOSChart)
    func wantsToSendTokensFlow()
    func wantsToShowResroucesFlow()
    func wantsToShowRamFlow()
    func wantsToShowPendingTransactions()
    func wantsToDoTransactionRequest()
}

class ChainInfoVC: BaseVC {
    weak var delegate: ChainInfoDelegate?
    let infoView = ChainInfoView(frame: kBaseTopNavScreenSize)
    var chartData: EOSChart? { didSet { self.infoView.chartData = chartData } }
    
    convenience init(services: Services, title: String) {
        self.init(services: services)
        self.title = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        loadData()
    
        observePullDown()
        observeGraphTap()
        observeChainActions()
    }
    
    override func loadView() {
        view = infoView
    }
    
    private func loadData() {
        getMarketInfo()
        getGraphData()
        getRamPrice()
    }
    
    private func getMarketInfo() {
        services.market.getMarketData().subscribe(onNext: { [weak self] market in
            self?.infoView.market = market
        }, onError: { [weak self] error in
            self?.infoView.stopRefreshing()
            print(error)
        }).disposed(by: disposeBag)
    }
    
    private func getGraphData() {
        services.market.getChartData(days: 1).subscribe(onNext: { [weak self] chartData in
            self?.chartData = chartData
        }).disposed(by: disposeBag)
    }
    
    private func getRamPrice() {
        services.blockchain.getRam().subscribe(onNext: { [weak self] ramRow in
            self?.infoView.ramPrice = ramRow.ramPrice
        }).disposed(by: disposeBag)
    }
    
    private func observePullDown() {
        infoView.refreshControl.rx.controlEvent(UIControlEvents.valueChanged)
            .filter { [weak self] pulledDown -> Bool in
                return (self?.infoView.refreshControl.isRefreshing == true)
            }
            .subscribe(onNext: { [weak self] pulledDown in
                self?.loadData()
            }).disposed(by: disposeBag)
    }
    
    private func observeGraphTap() {
        infoView.didTapGraph.subscribe(onNext: { [weak self] tapped in
            DispatchQueue.main.async {
                guard let chartData = self?.infoView.chartData else { return }
                self?.delegate?.wantsToShowGraphDetail(with: chartData)
            }
        }).disposed(by: disposeBag)
    }
    
    private func observeChainActions() {
        infoView.actionsView.didSelectAction.subscribe(onNext: { [weak self] action in
            guard let self = self else { return }
            guard self.services.blockchain.hasActiveAccounts() == true else {
                let error = AMError(localizedTitle: InfoLocalization.noActiveAccountsTitle.text,
                                    localizedDescription: InfoLocalization.noActiveAccountsDsc.text,
                                    code: 0)
                return self.showErrorMessage(error)
            }
            DispatchQueue.main.async {
                switch action {
                case .sendEos:
                    self.services.analytics.log(event: .didTapSendToken, info: [:])
                    self.delegate?.wantsToSendTokensFlow()
                case .resource:
                    self.services.analytics.log(event: .didTapSendResources, info: [:])
                    self.delegate?.wantsToShowResroucesFlow()
                case .ram:
                    self.services.analytics.log(event: .didTapRam, info: [:])
                    self.delegate?.wantsToShowRamFlow()
                case .pendingTransactions:
                    self.services.analytics.log(event: .didTapPendingTransactions, info: [:])
                    self.delegate?.wantsToShowPendingTransactions()
                case .transactionRequest:
                    self.services.analytics.log(event: .didTapRequestTransaction, info: [:])
                    self.delegate?.wantsToDoTransactionRequest()
                }
            }
        }).disposed(by: disposeBag)
    }
}
