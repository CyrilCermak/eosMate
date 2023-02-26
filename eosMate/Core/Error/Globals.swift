//
//  Globals.swift
//  eosMate
//
//  Created by Cyril on 17/3/18.
//  Copyright © 2018 Cyril. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

func addShadowTo(view: UIView) {
    view.layer.shadowColor = UIColor.black.cgColor
    view.layer.shadowOffset = CGSize(width: 5, height: 5)
    view.layer.shadowOpacity = 0.2
}

func jsonDict(from data: Data) -> [String: Any]? {
    do {
        return try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any]
    } catch let e {
        print(e.localizedDescription)
    }
    
    return [:]
}

func json<T: Codable>(from object: T) -> [String: Any] {
    do {
        return try JSONSerialization.jsonObject(with: JSONEncoder().encode(object)) as? [String: Any] ?? [:]
    } catch let e {
        print(e.localizedDescription)
    }
    return [:]
}

func jsonTo<T: Codable>(json: [String: Any], type: T.Type) -> T? {
    do {
        return try JSONDecoder().decode(type, from: JSON(json).rawData())
    } catch let e {
        print(e.localizedDescription)
    }
    return nil
}

func jsonObjects<T: Codable>(from objects: T) -> [[String: Any]] {
    do {
        return try JSONSerialization.jsonObject(with: JSONEncoder().encode(objects)) as? [[String: Any]] ?? [[:]]
    } catch let e {
        print(e.localizedDescription)
    }
    return [[:]]
}

func dispatchAfterKeayboardAnimation(action: @escaping () -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.4) {
        action()
    }
}
