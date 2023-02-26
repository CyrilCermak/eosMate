//
//  BaseFlowView.swift
//  eosMate
//
//  Created by Cyril on 26/9/18.
//  Copyright © 2018 CyrilCermak. All rights reserved.
//

import Foundation
import UIKit
import SnapKit
import RxSwift

class BaseFlowView: UIView {
    let mainActionView = UIScrollView()
    var titles = [String]() { didSet { setViewState(); pagingControl.numberOfPages = titles.count } }
    let rightBtnClicked = PublishSubject<Void>()
    let leftBtnClicked = PublishSubject<Void>()
    
    private let topNavView = UIView()
    private let leftButton = UIButton()
    private let rightButton = UIButton()
    private let pagingControl = UIPageControl()
    private let navTitle = UILabel()
    let disposeBag = DisposeBag()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    private func initView() {
        addViews()
        
        setTopNavView()
        setButtons()
        setMainActionView()
        setPageControl()
        setNavTitle()
        setViewState()
    }
    
    private func addViews() {
        [topNavView, mainActionView, leftButton, rightButton, pagingControl, navTitle].forEach { self.addSubview($0) }
    }
    
    private func setTopNavView() {
        topNavView.backgroundColor = UIColor.exDarkBlue()
        sendSubview(toBack: mainActionView)
        topNavView.addBaseShadow()
        topNavView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.equalToSuperview()
            make.height.equalTo(isIphoneX ? 88 : 64)
        }
    }
    
    private func setButtons() {
        leftButton.rx.tap.bind(to: leftBtnClicked).disposed(by: disposeBag)
        leftButton.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(20)
            make.top.equalToSuperview().offset(isIphoneX ? 45 : 25)
            make.width.height.equalTo(25)
        }
        rightButton.setImage(UIImage(named: "btnCancelGrey"), for: .normal)
        rightButton.rx.tap.bind(to: rightBtnClicked).disposed(by: disposeBag)
        rightButton.snp.makeConstraints { make in
            make.right.equalToSuperview().offset(-20)
            make.top.equalTo(self.leftButton)
            make.width.height.equalTo(25)
        }
    }
    
    private func setMainActionView() {
        mainActionView.isScrollEnabled = true
        mainActionView.showsHorizontalScrollIndicator = false
        mainActionView.showsVerticalScrollIndicator = false
        mainActionView.clipsToBounds = false
        mainActionView.bounces = false
        mainActionView.isPagingEnabled = true
        mainActionView.delegate = self
        mainActionView.backgroundColor = UIColor.exDarkBlue()
        mainActionView.contentInsetAdjustmentBehavior = .never
        mainActionView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.left.right.bottom.equalToSuperview()
        }
    }
    
    private func setNavTitle() {
        navTitle.textColor = UIColor.exWhite()
        navTitle.textAlignment = .center
        navTitle.font = UIFont.exFontLatoBold(size: 16)
        navTitle.snp.makeConstraints { make in
            make.width.equalTo(200)
            make.height.equalTo(20)
            if isIphoneX {
                make.centerY.equalTo(self.topNavView).offset(10)
                make.centerX.equalTo(self.topNavView)
            } else {
                make.center.equalTo(self.topNavView)
            }
        }
    }
    
    fileprivate func setPageControl() {
        pagingControl.currentPage = 0
        pagingControl.numberOfPages = titles.count
        pagingControl.pageIndicatorTintColor = UIColor.exDarkGray()
        pagingControl.currentPageIndicatorTintColor = UIColor.exShiningBlue()
        
        pagingControl.snp.makeConstraints { make in
            make.centerX.equalTo(self.topNavView)
            make.height.equalTo(10)
            make.bottom.equalTo(self.topNavView.snp.bottom).offset(-8)
        }
    }
    
    fileprivate func setViewState() {
        guard titles.count > 0 else { return }
        if titles.count >= pagingControl.currentPage {
            navTitle.text = titles[pagingControl.currentPage]
        }
    }
    
    func didScroll() {} // Override this to add action to the didScroll
}

extension BaseFlowView: UIScrollViewDelegate {
    func moveScrollView(toFront: Bool) {
        if toFront {
            pagingControl.currentPage += 1
            animateTheMoving(action: {
                self.mainActionView.contentOffset.x += self.frame.width
            })
        } else {
            pagingControl.currentPage -= 1
            animateTheMoving(action: {
                self.mainActionView.contentOffset.x -= self.frame.width
            })
        }
        setViewState()
    }
    
    fileprivate func animateTheMoving(action: @escaping () -> Void, completion: ((_ completed: Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: action, completion: { completed in completion?(completed) })
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        didScroll()
        if mainActionView.frame.width > 0 {
            let currentPage = Int(floor((mainActionView.contentOffset.x - (mainActionView.frame.width / 2)) / (mainActionView.frame.width) + 1))
            pagingControl.currentPage = currentPage
            setViewState()
        }
    }
}
