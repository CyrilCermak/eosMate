//
//  BaseActionDialogView.swift
//  eosX
//
//  Created by Cyril Cermak on 17.04.21.
//  Copyright © 2021 CyrilCermak. All rights reserved.
//

import UIKit
import RxSwift

class BaseActionDialogView: UIView {
    let disposeBag = DisposeBag()
    let tappedHappyCaseAt = PublishSubject<Int>()
    let tappedUnhappyCaseAt = PublishSubject<Int>()
    
    private var pageControl: UIPageControl = {
        let pageControl = UIPageControl()
        pageControl.pageIndicatorTintColor = UIColor.exLightGray()
        pageControl.currentPageIndicatorTintColor = UIColor.exShiningBlue()
        return pageControl
    }()
    
    var views = [UIView]() { didSet { setArrangedSubviews() }}
    
    let actionUnhappyBtn = BaseButton(title: "SKIP", type: .shadow)
    let actionHappyBtn = BaseButton(title: "ENABLE", type: .shinningBlue)
    
    var closeBtn: UIButton = {
        let closeBtn = UIButton()
        closeBtn.setImage(UIImage(named: "btn_cancel"), for: .normal)
        return closeBtn
    }()
    
    private var scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.isScrollEnabled = false
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator = false
        scrollView.bounces = false
        scrollView.isPagingEnabled = true
        return scrollView
    }()
    
    convenience init(views: [UIView]) {
        self.init(frame: CGRect.zero)
        self.views = views
    }
    
    @available(*, unavailable)  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        initView()
    }
    
    private func initView() {
        backgroundColor = UIColor.exDarkBlue()
        
        [scrollView, closeBtn, actionHappyBtn, actionUnhappyBtn, pageControl].forEach { self.addSubview($0) }
        layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        layer.cornerRadius = 10
        
        setCloseButton()
        setActionUnhappyBtn()
        setActionHappyBtn()
        setScrollView()
        setPageControll()
        
        setArrangedSubviews()
    }
    
    private func setScrollView() {
        scrollView.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(self.safeArea.top)
            make.bottom.equalTo(actionUnhappyBtn).offset(-10)
        }
        scrollView.delegate = self
        scrollView.layoutIfNeeded()
    }
    
    private func setArrangedSubviews() {
        views.enumerated().forEach { index, view in
            bringSubview(toFront: view)
            scrollView.addSubview(view)
            view.snp.makeConstraints { make in
                if index >= 1 {
                    make.left.equalTo(views[index - 1].snp.right)
                } else {
                    make.left.equalToSuperview()
                }
                
                if index == views.count - 1 {
                    make.right.equalToSuperview()
                }
                
                make.width.equalTo(scrollView.snp.width)
                make.height.equalTo(scrollView.snp.height)
            }
            view.layoutIfNeeded()
        }
        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(views.count), height: 0)
        pageControl.numberOfPages = views.count > 1 ? views.count : 0
    }
    
    private func setCloseButton() {
        closeBtn.snp.makeConstraints { make in
            make.top.equalTo(self.safeArea.top)
            make.right.equalToSuperview().offset(-5)
            make.width.height.equalTo(44)
        }
    }
    
    private func setActionUnhappyBtn() {
        actionUnhappyBtn.rx.tap.map { self.pageControl.currentPage }
            .bind(to: tappedUnhappyCaseAt).disposed(by: disposeBag)
        
        actionUnhappyBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalTo(actionHappyBtn.snp.top).offset(-18)
            make.height.equalTo(52)
        }
    }
    
    private func setActionHappyBtn() {
        actionHappyBtn.rx.tap.map { self.pageControl.currentPage }
            .bind(to: tappedHappyCaseAt).disposed(by: disposeBag)
        
        actionHappyBtn.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(24)
            make.right.equalToSuperview().offset(-24)
            make.bottom.equalTo(self.safeArea.bottom).offset(-44)
            make.height.equalTo(52)
        }
    }
    
    private func setPageControll() {
        pageControl.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(actionHappyBtn.snp.bottom).offset(5)
        }
    }
    
    private func animateMoving(action: @escaping () -> Void, completion: ((_ completed: Bool) -> Void)? = nil) {
        UIView.animate(withDuration: 0.2, animations: action, completion: { completed in completion?(completed) })
    }
    
    func moveToNext() {
        animateMoving { self.scrollView.contentOffset.x += self.frame.width }
    }
    
    func updateButtons(happyTitle: String?, unhappyTitle: String? = nil) {
        if let happyTitle = happyTitle {
            actionHappyBtn.setTitle(happyTitle, for: .normal)
        }
        
        if let unhappyTitle = unhappyTitle {
            actionUnhappyBtn.setTitle(unhappyTitle, for: .normal)
        }
    }
}

extension BaseActionDialogView: UIScrollViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let currentPage = Int(floor((self.scrollView.contentOffset.x - (scrollView.frame.width / 2)) / (scrollView.frame.width) + 1))
        pageControl.currentPage = currentPage
    }
}
