//
//  ViewController.swift
//  Arcsinus
//
//  Created by Qurban on 20.07.2019.
//  Copyright © 2019 Kurban. All rights reserved.
//

import UIKit
import RxSwift

class PersonListView: UIViewController {
    let viewModel = PersonListViewModel()
    let disposeBag = DisposeBag()
    
    var persons: [Person] = []
    
    var searchController: UISearchController = UISearchController(searchResultsController: nil)
    
    @IBOutlet weak var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        searchController.searchResultsUpdater = self
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        navigationItem.searchController = searchController
        navigationItem.hidesSearchBarWhenScrolling = false
        
        tableView.register(UINib(nibName: "PersonCell", bundle: nil), forCellReuseIdentifier: "PersonCell")
        
        tableView.dataSource = self
        tableView.delegate = self
        
        viewModel
            .persons
            .observeOn(MainScheduler.instance)
            .subscribe(
                onNext: { [unowned self] persons in
                    self.persons = persons
                    self.tableView.reloadData()
                },
                onError: { error in
                    
            })
            .disposed(by: disposeBag)
        
        viewModel
            .searchText
            .onNext("")
    }
}

extension PersonListView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return persons.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "PersonCell", for: indexPath) as! PersonCell
        
        let person = persons[indexPath.row]
        cell.nameLabel.text = person.name
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        let person = persons[indexPath.row]
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let personDetailView = storyboard.instantiateViewController(withIdentifier: "PersonDetailView") as! PersonDetailView
        personDetailView.personName = person.name
        navigationController?.pushViewController(personDetailView, animated: true)
    }
}

extension PersonListView: UISearchResultsUpdating {
    func updateSearchResults(for searchController: UISearchController) {
        viewModel.searchText.onNext(searchController.searchBar.text)
    }
}
