//
//  Person.swift
//  Arcsinus
//
//  Created by Qurban on 24.07.2019.
//  Copyright © 2019 Kurban. All rights reserved.
//

import Foundation
import RealmSwift

class Person: Object, Codable {
    @objc dynamic var name: String
    @objc dynamic var height: String
    @objc dynamic var mass: String
    @objc dynamic var hair_color: String
}
