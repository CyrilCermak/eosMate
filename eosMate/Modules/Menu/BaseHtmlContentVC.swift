//
//  BaseHtmlContentVC.swift
//  eosMate
//
//  Created by Cyril Cermak on 14.06.20.
//  Copyright © 2020 CyrilCermak. All rights reserved.
//

import UIKit

class BaseHtmlContentVC: BasePopVC {
    enum ContentType: String {
        case imprint, tac, usedLibraries, privacyPolicy
    }

    private let htmlView = BaseHtmlContentView(frame: screenSize)

    convenience init(services: Services, contentType: ContentType, title: String) {
        self.init(services: services)
        load(content: contentType)
        self.title = title
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func loadView() {
        view = htmlView
    }
    
    private func load(content: ContentType) {
        guard let fileUrl = Bundle.main.url(forResource: content.rawValue, withExtension: "html") else { return }
        
        htmlView.text = try? String(contentsOf: fileUrl, encoding: .utf8).convertHtml()
    }
}
