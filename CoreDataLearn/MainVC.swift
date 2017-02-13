//
//  ViewController.swift
//  CoreDataLearn
//
//  Created by Nguyễn Xuân Đạt on 2/13/17.
//  Copyright © 2017 Nguyễn Xuân Đạt. All rights reserved.
//

import UIKit
import CoreData

class MainVC: UIViewController, UITableViewDelegate, UITableViewDataSource, NSFetchedResultsControllerDelegate {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var segment: UISegmentedControl!
    var controller: NSFetchedResultsController<Item>!


    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        tableView.delegate = self
        tableView.dataSource = self
        //
        //generateTestData()
        attempFetch()
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ItemCell", for: indexPath) as! ItemCell
        configureCell(cell: cell, indexPath: indexPath as NSIndexPath)
        return cell

    }
    func configureCell(cell: ItemCell, indexPath: NSIndexPath) {
        let item = controller.object(at: indexPath as IndexPath)
        cell.configureCell(item: item)
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let sections = controller.sections {
            let sectionInfo = sections[section]
            return sectionInfo.numberOfObjects
        }
        return 0
    }
    func numberOfSections(in tableView: UITableView) -> Int {
        if let sections = controller.sections {
            return sections.count
        }
        return 0
    }
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 150
    }
    func attempFetch() {
        let fetchRequest: NSFetchRequest<Item> = Item.fetchRequest()
        let dateSort = NSSortDescriptor(key: "create", ascending: false) // Sort by "timestamp" field
        fetchRequest.sortDescriptors = [dateSort]
        // context is a "shortcut" variable inside AppDelegate.swift which we defined
        let controller = NSFetchedResultsController(fetchRequest: fetchRequest, managedObjectContext: context, sectionNameKeyPath: nil, cacheName: nil)
        // Set outside controller to inside controller
        controller.delegate = self
        self.controller = controller
        do {
            try controller.performFetch()

        } catch {
            let error = error as NSError
            print("\(error)")
        }
    }
    //
    func controllerWillChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.beginUpdates()
    }
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        tableView.endUpdates()
    }

    func controller(_ controller: NSFetchedResultsController<NSFetchRequestResult>, didChange anObject: Any, at indexPath: IndexPath?, for type: NSFetchedResultsChangeType, newIndexPath: IndexPath?) {
        switch (type) {
        case.insert:
            if let newIndexPath = indexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break
        case.delete:
            if let delIndexPath = indexPath {
                tableView.deleteRows(at: [delIndexPath], with: .fade)
            }
            break
        case.update:
            if let updateIndexPath = indexPath {
                let cell = tableView.cellForRow(at: updateIndexPath) as! ItemCell

                configureCell(cell: cell, indexPath: updateIndexPath as NSIndexPath)
            }
            break
        case.move:
            if let delIndexPath = indexPath {
                tableView.deleteRows(at: [delIndexPath], with: .fade)
            }
            if let newIndexPath = indexPath {
                tableView.insertRows(at: [newIndexPath], with: .fade)
            }
            break

        }
    }
    func generateTestData(){
        let item = Item(context: context)
        item.title = "A Home"
        item.price = 300000
        item.details = "Biggest dream."
        let item2 = Item(context: context)
        item2.title = "NAS"
        item2.price = 1000
        item2.details = "I like movie."
        let item3 = Item(context: context)
        item3.title = "A next gen xbox"
        item3.price = 600
        item3.details = "I sometime want to play game. I love my wife but I need sometime for myself."
    }
    
    
    
    
    
}

