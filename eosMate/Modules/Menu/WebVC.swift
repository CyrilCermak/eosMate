//
//  WebVC.swift
//  eosMate
//
//  Created by Cyril Cermak on 19.07.20.
//  Copyright © 2020 CyrilCermak. All rights reserved.
//

import UIKit
import WebKit

class WebVC: BaseVC {
    private lazy var webView: WKWebView = {
        let webView = WKWebView(frame: screenSize)
        webView.scrollView.delegate = self
        return webView
    }()
    
    override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
        super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
    }
    
    convenience init(services: Services, url: URL) {
        self.init(nibName: nil, bundle: nil)
        self.services = services
        initView()
        loadWebView(with: url)
    }
    
    @available(*, unavailable)  required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func loadView() {
        view = UIView()
        view.backgroundColor = UIColor.exDarkGray()
    }
    
    private func initView() {
        view.addSubview(webView)
        webView.snp.makeConstraints { make in
            make.top.equalTo(self.view.safeAreaInsets.top)
            make.bottom.right.left.equalToSuperview()
        }
        view.layoutIfNeeded()
    }
    
    private func loadWebView(with url: URL) {
        webView.load(URLRequest(url: url))
    }
}

extension WebVC: UIScrollViewDelegate {
    func scrollViewWillBeginZooming(_ scrollView: UIScrollView, with view: UIView?) {
        scrollView.pinchGestureRecognizer?.isEnabled = false
    }
}
