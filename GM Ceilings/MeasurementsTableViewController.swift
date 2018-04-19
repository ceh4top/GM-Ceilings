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
        
        fetchedResultsController = getRowsOfEMeasurement(filter: nil)
        
        if let search = self.navigationItem.titleView as? UISearchBar {
            search.placeholder = "Введите"
        }

        fetchedResultsController?.delegate = self
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
        
        let refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        
        // this is the replacement of implementing: "collectionView.addSubview(refreshControl)"
        self.refreshControl = refreshControl
    }
    
    func getRowsOfEMeasurement(filter: String?) -> NSFetchedResultsController<NSFetchRequestResult> {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "EMeasurement")
        
        let sortDescriptor = NSSortDescriptor(key: "dateTimeMeasurement", ascending: false)
        fetchRequest.sortDescriptors = [sortDescriptor]
        
        if var filter = filter as String! {
            filter = Helper.removeSpecialCharsFromString(text: filter)
            let predicate = NSPredicate(format: "address MATCHES[cd] '.*(\(filter)).*' or user.name MATCHES[cd] '.*(\(filter)).*' or user.phone MATCHES[cd] '.*(\(filter)).*'")
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
        let measurement = fetchedResultsController?.object(at: indexPath as IndexPath) as! EMeasurement
        let cell = tableView.dequeueReusableCell(withIdentifier: "measurementsCell") as! MeasurmentsTableViewCell
        
        var address : String? = ""
        var user : String? = ""
        var date : String? = ""
        
        if (measurement.address != nil) {
            address = measurement.address
        }
        
        if (measurement.apartmentNumber != nil) {
            address = address! + " кв. " + (measurement.apartmentNumber)!
        }
        
        if (measurement.user?.name != nil) {
            user = measurement.user?.name
        }
        
        if (measurement.user?.phone != nil) {
            user = user! + " тел: " + (measurement.user?.phone)!
        }
        
        if (measurement.dateTimeMeasurement != nil) {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "dd.MM.yyyy HH:mm"
            date = String(describing: dateFormatter.string(from: measurement.dateTimeMeasurement as! Date) )
        }
        
        cell.address?.text = address
        cell.user?.text = user
        cell.date?.text = date
        
        return cell
    }
    
    public func refresh(sender:AnyObject)
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
        self.navigationItem.title = "Замеры"
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.fetchedResultsController = getRowsOfEMeasurement(filter: searchText)
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
        
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let search = self.navigationItem.titleView as? UISearchBar {
            self.fetchedResultsController = getRowsOfEMeasurement(filter: search.text)
        }
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
        
        self.tableView.reloadData()
        searchBar.resignFirstResponder()
    }
}
