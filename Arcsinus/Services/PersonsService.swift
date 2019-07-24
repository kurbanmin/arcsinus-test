//
//  PersonsService.swift
//  Arcsinus
//
//  Created by Qurban on 21.07.2019.
//  Copyright © 2019 Kurban. All rights reserved.
//

import Foundation
import RealmSwift
import Alamofire
import RealmSwift

class PersonsService {
    func getPersons(with name: String, completion: @escaping (Result<[Person]>) -> ()) {
        if name.isEmpty {
            let realm = try! Realm()
            let persons = realm.objects(Person.self)
            completion(Result.success(Array(persons)))
            return
        }
        
        let urlString = "https://swapi.co/api/people/?search=\(name)".addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        Alamofire.request(urlString).responseJSON { (response) in
            guard response.result.isSuccess else { return }
            guard let data = response.data else { return }
            
            do {
                let response = try JSONDecoder().decode(Response<[Person]>.self, from: data)
                completion(Result.success(response.results))
            } catch {
                completion(Result.failure(error))
            }
        }
    }
    
    func getPerson(with name: String, completion: @escaping (Result<Person>) ->()) {
        let realm = try! Realm()
        
        if let person = realm.objects(Person.self).filter("name == '\(name)'").first {
            completion(Result.success(person))
        } else {
            getPersons(with: name) { (result: Result<[Person]>) in
                switch result {
                case .success(let persons):
                    guard let person = persons.first else { break }
                    try! realm.write {
                        realm.add(person)
                    }
                    completion(Result.success(person))
                case .failure(let error):
                    completion(Result.failure(error))
                }
            }
        }
    }
    
}
