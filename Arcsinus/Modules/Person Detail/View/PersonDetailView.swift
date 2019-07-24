//
//  DesctiptionsViewController.swift
//  Arcsinus
//
//  Created by Qurban on 23.07.2019.
//  Copyright © 2019 Kurban. All rights reserved.
//

import UIKit
import RxSwift

class PersonDetailView: UIViewController {
    let viewModel = PersonDetailViewModel()
    let disposeBag = DisposeBag()
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var descriptionLabel: UITextView!
    
    var personName: String!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        _ = viewModel
            .person
            .observeOn(MainScheduler.instance)
            .subscribe(onNext: { [unowned self] person in
                self.nameLabel.text = person.name
                self.descriptionLabel.text = " Масса - \(person.mass)\n Рост - \(person.height)\n Цвет волос - \(person.hair_color) "
            })
            .disposed(by: disposeBag)
        
        viewModel
            .personName
            .onNext(personName)
    }
}
