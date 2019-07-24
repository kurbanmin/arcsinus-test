//
//  PersonsViewModel.swift
//  Arcsinus
//
//  Created by Qurban on 21.07.2019.
//  Copyright © 2019 Kurban. All rights reserved.
//

import Foundation
import RealmSwift

class PersonListModel {
    var persons: [Person]?
    
    init(persons: [Person]) {
        self.persons = persons
    }
}

