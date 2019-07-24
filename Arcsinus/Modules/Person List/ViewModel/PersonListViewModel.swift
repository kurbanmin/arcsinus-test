//
//  PersonsModel.swift
//  Arcsinus
//
//  Created by Qurban on 21.07.2019.
//  Copyright © 2019 Kurban. All rights reserved.
//

import Foundation
import Alamofire
import RxSwift

class PersonListViewModel {
    let personsService = PersonsService()
    let disposeBag = DisposeBag()
    
    private var model: PersonListModel? {
        didSet {
            if let persons = model?.persons {
                self.persons.onNext(persons)
            }
        }
    }
    
    var persons = PublishSubject<[Person]>()
    
    var searchText = PublishSubject<String?>()
    
    init() {
        _ = searchText.asObservable()
            .debounce(0.3, scheduler: MainScheduler.instance)
            .distinctUntilChanged()
            .subscribe(onNext: { [unowned self] searchText in
                guard let searchText = searchText else { return }
                self.search(name: searchText)
            })
    }
    
    func search(name: String) {
        personsService.getPersons(with: name) { [unowned self] (result: Result<[Person]>) in
            switch result {
            case .success(let persons):
                self.model = PersonListModel(persons: persons)
            case .failure(_):
                print("error")
            }
        }
    }
}
