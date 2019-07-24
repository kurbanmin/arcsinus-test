//
//  PersonViewModel.swift
//  Arcsinus
//
//  Created by Qurban on 24.07.2019.
//  Copyright © 2019 Kurban. All rights reserved.
//

import Foundation
import RxSwift
import Alamofire

class PersonDetailViewModel {
    var personsService = PersonsService()
    var disposeBag = DisposeBag()
    
    private var model: PersonDetailModel? {
        didSet {
            if let person = model?.person {
                self.person.onNext(person)
            }
        }
    }
    
    var person = PublishSubject<Person>()
    var personName = PublishSubject<String>()
    
    init() {
        _ = personName.asObserver()
            .subscribe(onNext: { [unowned self] personName in
                self.getPerson(with: personName)
            })
            .disposed(by: disposeBag)
    }
    
    func getPerson(with name: String) {
        personsService.getPerson(with: name) { [unowned self] result in
            switch result {
            case .success(let person):
                self.model = PersonDetailModel(person: person)
            case .failure(let error):
                print(error.localizedDescription)
            }
        }
    }
    
}
