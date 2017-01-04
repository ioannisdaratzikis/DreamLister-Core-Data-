//
//  MainViewController.swift
//  DreamLister
//
//  Created by John Daratzikis on 11/12/2016.
//  Copyright © 2016 ioannisdaratzikis. All rights reserved.
//

import UIKit
import CoreData

class MainViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
   
    var fetchedResultsController: NSFetchedResultsController<Item>!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        tableView.delegate = self
        tableView.dataSource = self
        
        //generateTestData()
        
        attemptFetch()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell
    }
    
    func configureCell (cell: ItemCell, indexPath: NSIndexPath){
    
        let item = fetchedResultsController.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if let sections = fetchedResultsController.sections {
            
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
            
        }
        
        return 0
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
     
        if let sections = fetchedResultsController.sections {
            
            return sections.count
            
        }
        
        return 0
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if let objs = fetchedResultsController.fetchedObjects, objs.count > 0 {
        
            let item = objs[indexPath.row]
            performSegue(withIdentifier: "ItemDetailsVC", sender: item)
        
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ItemDetailsVC"{
        
            if let destination = segue.destination as? ItemDetailsViewController {
                
                if let item = sender as? Item {
                
                    destination.itemToEdit = item
                
                }
            
            }
        
        }
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        return 150
    }
    
    func attemptFetch() {
        
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "created", ascending: false)
        let priceSort = NSSortDescriptor(key: "price", ascending: true)
        let titleSort = NSSortDescriptor(key: "title", ascending: true)
        let typeSort = NSSortDescriptor(key: "toItemType", ascending: true)
        
        if segment.selectedSegmentIndex == 0 {
        
            fetchRequest.sortDescriptors = [dateSort]
            
        }else if segment.selectedSegmentIndex ==  1 {
        
            fetchRequest.sortDescriptors = [priceSort]
            
        }else if segment.selectedSegmentIndex == 2 {
        
            fetchRequest.sortDescriptors = [titleSort]
        
        }else if segment.selectedSegmentIndex == 3 {
        
            fetchRequest.sortDescriptors = [typeSort]
        
        }
        
        
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        controller.delegate = self
        
        self.fetchedResultsController = controller
        
        do {
            
            try controller.performFetch()
        
        }catch{
            
            let error = error as NSError
            print("\(error)")
        
        }
    
    }
    
    @IBAction func segmentChange(_ sender: Any) {
        
        attemptFetch()
        tableView.reloadData()
        
    }
    
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }
    
    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        
        switch type {
        case.insert:
            if let indexPath = newIndexPath {
            
                tableView.insertRows(at: [indexPath], with: .fade)
                
            }
            break
        case.delete:
            if let indexPath = indexPath {
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
            break
        case.update:
            if let indexPath = indexPath {
                
                let cell = tableView.cellForRow(at: indexPath) as! ItemCell
                configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
                
            }
            break
        case.move:
            if let indexPath = indexPath {
                
                tableView.deleteRows(at: [indexPath], with: .fade)
                
            }
            if let indexPath = newIndexPath {
                
                tableView.insertRows(at: [indexPath], with: .fade)
                
            }
            break
        }
        
    }
    
    func generateTestData(){
        
        let item = Item(context: context)
        item.title = "iMac 5K"
        item.price = 2500
        item.details = "i want it now!"
        
        ad.saveContext()
    
    }
    
}
