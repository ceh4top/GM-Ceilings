//
//  MeasurementsTableViewController.swift
//  GM Ceilings
//
//  Created by GM on 13.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import UIKit
import CoreData

class MeasurementsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchBarDelegate {
    
    var fetchedResultsController : NSFetchedResultsController<NSFetchRequestResult>?

    override func viewDidLoad() {
        super.viewDidLoad()
        
        fetchedResultsController = getRowsOfMeasurement(filter: nil)
        
        if let search = self.navigationItem.titleView as? UISearchBar {
            search.placeholder = "Введите"
            search.enablesReturnKeyAutomatically = false
        }

        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        self.refreshControl = refreshControl
        
        if (fetchedResultsController?.fetchedObjects?.count)! < 1 {
            Message.Show(title: "Нет заказов", message: "У вас пока нет заказов. Для того что бы добавить заказ, запешитесь на замер.", controller: self)
        }
    }
    
    func getRowsOfMeasurement(filter: String?) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Measurement")
        
        let sortDescriptor = NSSortDescriptor(key: "projectId", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if var filter = filter as String! {
            filter = Helper.removeSpecialCharsFromString(text: filter)
            let predicate = NSPredicate(format: "address MATCHES[cd] '.*(\(filter)).*' or projectId MATCHES[cd] '.*(\(filter)).*' or status MATCHES[cd] '.*(\(filter)).*'")
            fetchRequest.predicate = predicate
        }
        
        let fetchedResultsController = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: CoreDataManager.instance.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        return fetchedResultsController
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = fetchedResultsController?.sections {
            return sections[section].numberOfObjects
        } else {
            return 0
        }
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> MeasurmentsTableViewCell {
        let measurement = fetchedResultsController?.object(at: indexPath as IndexPath) as! Measurement
        let cell = tableView.dequeueReusableCell(withIdentifier: "measurementsCell") as! MeasurmentsTableViewCell
        
        cell.address.text = ((measurement.address != nil) ? measurement.address : "")
        cell.projectId.text = ((measurement.projectId != nil) ?  measurement.projectId : "")
        cell.status.text = ((measurement.status != nil) ? measurement.status : "")
        cell.projectSum.text = ((measurement.projectSum != nil) ? measurement.projectSum : "")
        
        return cell
    }
    
    public func refresh()
    {
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationItem.title = "Заказы"
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.fetchedResultsController = getRowsOfMeasurement(filter: searchText)
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
        
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let search = self.navigationItem.titleView as? UISearchBar {
            self.fetchedResultsController = getRowsOfMeasurement(filter: search.text)
        }
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
        
        self.tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.refresh()
    }
}
