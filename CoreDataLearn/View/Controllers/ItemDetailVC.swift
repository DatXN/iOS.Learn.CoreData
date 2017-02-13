//
//  ItemDetailVC.swift
//  CoreDataLearn
//
//  Created by Nguyễn Xuân Đạt on 2/13/17.
//  Copyright © 2017 Nguyễn Xuân Đạt. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    var stores = [Store]()


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Remove previous navbar name
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        storePicker.delegate = self
        storePicker.dataSource = self
        //createStoreData()
        getStores()
    }

    func createStoreData() {
        let store = Store(context: context)
        store.name = "Best Buy"
        let store1 = Store(context: context)
        store1.name = "Tesla Dealer"
        let store2 = Store(context: context)
        store2.name = "Amazon"
        let store3 = Store(context: context)
        store3.name = "Kroger"
        let store4 = Store(context: context)
        store4.name = "Walmart"
        let store5 = Store(context: context)
        store5.name = "K-Mart"
        // Save to app database
        ad.saveContext()
    }

    func getStores() {
        let fetchRequest: NSFetchRequest<Store> = Store.fetchRequest()
        do {
            self.stores = try context.fetch(fetchRequest)
            if(self.stores.count <= 0){
                createStoreData()
                getStores()
            }
            
            self.storePicker.reloadAllComponents()

        } catch {

        }
    }

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        let store = stores[row]
        return store.name
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return stores.count
    }
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        // How many column
        return 1
    }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        // update when selected
    }
    @IBAction func btnSaveItem_OnPressed(_ sender: Any) {
        let newItem = Item(context: context)
        if let title = titleField.text {
            newItem.title = title
        }
        if let desc = detailsField.text {
            newItem.details = desc
        }
        if let price = priceField.text {
            newItem.price = (price as NSString).doubleValue
        }
        
        newItem.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        ad.saveContext()
        // Take back to main view controller
        
        navigationController?.popViewController(animated: true)
    }
}
