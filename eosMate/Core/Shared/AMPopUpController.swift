//
//  AMPopUpController.swift
//  eosMate
//
//  Created by Cyril on 19/4/18.
//  Copyright © 2018 Cyril. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

struct AMPopUpOptions {
    var firstButtonTitle: String?
    var secondButtonTitle: String?
    var title: String?
    var text: String?
}

class AMPopUpController {
    let disposeBag = DisposeBag()
    
    static let shared = AMPopUpController()
    
    func createPopUp(at view: UIView, title: String, description: String,
                     proceedCompletion: @escaping () -> Void, cancelCompletion: @escaping () -> Void) {
        let popUp = AMPopUpCardView(type: .yesAndNoButtons)
        popUp.set(title: title, description: description)
        popUp.yesBtn.rx.tap.subscribe { _ in
            self.animateDissapearance(for: popUp)
            proceedCompletion()
        }.disposed(by: disposeBag)
        popUp.cancelBtn.rx.tap.subscribe { _ in
            self.animateDissapearance(for: popUp)
            cancelCompletion()
        }.disposed(by: disposeBag)
        view.addSubview(popUp)
        popUp.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        animateAppearance(for: popUp)
    }
    
    func createPopUp(at view: UIView, title: String, description: String, okCompletion: @escaping () -> Void) {
        let popUp = AMPopUpCardView(type: .okButton)
        popUp.set(title: title, description: description)
        popUp.okBtn.rx.tap.subscribe { _ in
            self.animateDissapearance(for: popUp)
            okCompletion()
        }.disposed(by: disposeBag)
        view.addSubview(popUp)
        popUp.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        animateAppearance(for: popUp)
    }
    
    func createPopUp(at view: UIView, options: AMPopUpOptions, firstBtn: @escaping () -> Void, secondBtn: @escaping () -> Void) {
        let popUp = AMPopUpCardView(type: .twoButtons(firstTitle: options.firstButtonTitle ?? "", secondTitle: options.secondButtonTitle ?? ""))
        popUp.set(title: options.title ?? "", description: options.text ?? "")
        popUp.firstBtn.rx.tap.subscribe { _ in
            self.animateDissapearance(for: popUp)
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                firstBtn()
            }
        }.disposed(by: disposeBag)
        popUp.secondBtn.rx.tap.subscribe { _ in
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.animateDissapearance(for: popUp)
                secondBtn()
            }
        }.disposed(by: disposeBag)
        view.addSubview(popUp)
        popUp.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        animateAppearance(for: popUp)
    }
    
    func createInputPopUp(at view: UIView, options: AMPopUpOptions, yesBtn: @escaping (_ text: String) -> Void, cancelBtn: @escaping () -> Void) {
        let popUp = AMPopUpCardInputView(type: .buttonTitles(confirm: options.firstButtonTitle ?? "", cancel: options.secondButtonTitle ?? ""))
        popUp.set(title: options.title ?? "", description: options.text ?? "")
        popUp.yesBtn.rx.tap.subscribe { _ in
            popUp.textView.resignFirstResponder()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.animateDissapearance(for: popUp)
                yesBtn(popUp.textView.text)
            }
        }.disposed(by: disposeBag)
        popUp.cancelBtn.rx.tap.subscribe { _ in
            popUp.textView.resignFirstResponder()
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) {
                self.animateDissapearance(for: popUp)
                cancelBtn()
            }
        }.disposed(by: disposeBag)
        view.addSubview(popUp)
        popUp.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
        animateAppearance(for: popUp)
        popUp.textView.becomeFirstResponder()
    }
    
    private func animateAppearance(for view: UIView) {
        view.alpha = 0
        UIView.animate(withDuration: 0.3) {
            view.alpha = 1
        }
    }
    
    private func animateDissapearance(for view: UIView) {
        view.alpha = 1
        UIView.animate(withDuration: 0.3, animations: {
            view.alpha = 0
        }) { completed in
            if completed {
                view.removeFromSuperview()
            }
        }
    }
}
