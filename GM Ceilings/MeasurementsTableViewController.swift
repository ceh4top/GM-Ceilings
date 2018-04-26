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
        performFetch()
        
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
        cell.projectId.text = String(measurement.projectId)
        cell.status.text = ((measurement.status != nil) ? measurement.status : "")
        cell.projectSum.text = ((measurement.projectSum != nil) ? measurement.projectSum : "")
        
        return cell
    }
    
    public func performFetch() {
        var user : [String : String] = [:]
        let userTemp = UserDefaults.getUser()
        user.updateValue(userTemp.login, forKey: "username")
        user.updateValue(userTemp.password, forKey: "password")
        
        Helper.sendServer(parameters: user as [String : AnyObject], href: PList.iOSauthorisation) {
            (status, json) in
            Log.msg(json)
            if status {
                if let answer = json as? [String:AnyObject] {
                    if let data = answer["data"] as? [String:AnyObject] {
                        if let projects = data["rgzbn_gm_ceiling_projects"] as? [AnyObject] {
                            CoreDataManager.instance.removeAll()
                            for project in projects {
                                if let calc = project as? [String : AnyObject] {
                                    let measurement = Measurement()
                                    
                                    if let address = calc["project_info"] as? String {
                                        if address != "<null>" {
                                            measurement.address = address
                                        }
                                    }
                                    
                                    if let status = calc["status_name"] as? String {
                                        if status != "<null>" {
                                            measurement.status = status
                                        }
                                    }
                                    
                                    if let projectId = calc["id"] as? String {
                                        if projectId != "<null>" {
                                            measurement.projectId = Int32(projectId)!
                                        }
                                    }
                                    
                                    if let projectSum = calc["project_sum"] as? String {
                                        if projectSum != "<null>" {
                                            measurement.projectSum = projectSum
                                        }
                                    }
                                }
                            }
                            CoreDataManager.instance.saveContext()
                            
                            do {
                                try self.fetchedResultsController?.performFetch()
                            } catch {
                                print(error)
                            }
                            
                            self.tableView.reloadData()
                        }
                    }
                }
            }
        }
        
        do {
            try fetchedResultsController?.performFetch()
        } catch {
            print(error)
        }
    }
    
    public func refresh()
    {
        performFetch()
        
        self.tableView.reloadData()
        self.refreshControl?.endRefreshing()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        self.navigationItem.title = "Заказы"
    }
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        self.fetchedResultsController = getRowsOfMeasurement(filter: searchText)
        
        performFetch()
        
        self.tableView.reloadData()
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let search = self.navigationItem.titleView as? UISearchBar {
            self.fetchedResultsController = getRowsOfMeasurement(filter: search.text)
        }
        
        performFetch()
        
        self.tableView.reloadData()
        searchBar.resignFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.refresh()
    }
}
