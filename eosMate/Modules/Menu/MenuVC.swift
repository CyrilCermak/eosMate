//
//  MenuVC.swift
//  eosMate
//
//  Created by Cyril Cermak on 14.06.20.
//  Copyright © 2020 CyrilCermak. All rights reserved.
//

import UIKit
import RxSwift
import MessageUI

class MenuCell: UITableViewCell, TappableCell {
    var disposeBag: DisposeBag = .init()
    var model: MenuView.MenuItem? { didSet { textLabel?.text = model?.name } }
    
    var tappedContetnViewColor: UIColor = .exDarkGray()
    var baseContentViewColor: UIColor = .clear

    let didTapItem = PublishSubject<MenuView.MenuItem>()
    
    @available(*, unavailable)  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = .clear
        selectionStyle = .none
        textLabel?.font = UIFont.exFontLatoSemiBold(size: 18)
        textLabel?.textColor = .exWhite()
        accessoryType = .disclosureIndicator
        
        addTapRecognizer()
    }
    
    func didTapContentView(completion: @escaping (_ completed: Bool) -> Void) {
        UIView.animate(withDuration: 0.7, animations: {
            self.contentView.backgroundColor = self.tappedContetnViewColor
            self.contentView.backgroundColor = self.baseContentViewColor
            guard let model = self.model else { return }
            
            self.didTapItem.onNext(model)
        })
    }
}

class MenuView: BaseViewWithTableView {
    let didTapItem = PublishSubject<MenuItem>()
    
    enum MenuItem: CaseIterable {
        case about, support, removePKs, analytics, tac, privacyPolicy, imprint
        var name: String {
            switch self {
            case .about: return MenuLocalization.about.text
            case .support: return MenuLocalization.support.text
            case .removePKs: return MenuLocalization.removePKs.text
            case .analytics: return MenuLocalization.analytics.text
            case .tac: return MenuLocalization.tac.text
            case .privacyPolicy: return MenuLocalization.privacyPolicy.text
            case .imprint: return MenuLocalization.imprint.text
            }
        }
    }
    
    private let disposeBag: DisposeBag = .init()
    private let cellModels = MenuItem.allCases
    
    @available(*, unavailable)  required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.exDarkBlue()
        tableView.refreshControl = nil
        tableView.isScrollEnabled = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int { return 1 }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { return cellModels.count }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat { return 55 }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = MenuCell()
        cell.model = cellModels[indexPath.row]
        cell.didTapItem.bind(to: didTapItem).disposed(by: disposeBag)
        return cell
    }
}

class MenuVC: BasePopVC {
    private let menuView = MenuView(frame: screenSize)

    lazy var wantsToShow = PublishSubject<MenuView.MenuItem>()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        subscribeForViewActions()
        title = MenuLocalization.title.text
    }
    
    override func loadView() {
        view = menuView
    }
    
    private func subscribeForViewActions() {
        menuView.didTapItem.subscribe(onNext: { [weak self] item in
            guard let self = self else { return }
            self.wantsToShow.onNext(item)
        }).disposed(by: disposeBag)
    }
}
