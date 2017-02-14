//
//  ItemDetailVC.swift
//  CoreDataLearn
//
//  Created by Nguyễn Xuân Đạt on 2/13/17.
//  Copyright © 2017 Nguyễn Xuân Đạt. All rights reserved.
//

import UIKit
import CoreData

class ItemDetailVC: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    @IBOutlet weak var storePicker: UIPickerView!
    @IBOutlet weak var titleField: CustomTextField!
    @IBOutlet weak var priceField: CustomTextField!
    @IBOutlet weak var detailsField: CustomTextField!
    @IBOutlet weak var thumbImg: UIImageView!
    var stores = [Store]()
    var itemToEdit: Item?
    var imagePicker: UIImagePickerController!
    //


    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        // Remove previous navbar name
        if let topItem = self.navigationController?.navigationBar.topItem {
            topItem.backBarButtonItem = UIBarButtonItem(title: "", style: .plain, target: nil, action: nil)
        }
        storePicker.delegate = self
        storePicker.dataSource = self
        //
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        //createStoreData()
        getStores()
        //
        if(itemToEdit != nil) {
            loadItemData()
        }

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
            if(self.stores.count <= 0) {
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
        var item: Item!
        
        if itemToEdit == nil {
            item = Item(context: context)
        } else {
            item = itemToEdit

        }
        
        let picture = Image(context: context)
        picture.image = thumbImg.image
        item.toImage = picture

        if let title = titleField.text {
            item.title = title
        }
        if let desc = detailsField.text {
            item.details = desc
        }
        if let price = priceField.text {
            item.price = (price as NSString).doubleValue
        }

        item.toStore = stores[storePicker.selectedRow(inComponent: 0)]
        ad.saveContext()
        // Take back to main view controller

        navigationController?.popViewController(animated: true)
    }

    func loadItemData() {

        if let item = itemToEdit {
            titleField.text = item.title
            priceField.text = String(item.price)
            detailsField.text = item.details
            thumbImg.image = item.toImage?.image as? UIImage
            if let store = item.toStore {
                var index = 0
                repeat {
                    let s = stores[index]
                    if s.name == store.name {
                        storePicker.selectRow(index, inComponent: 0, animated: false)
                        break;
                    }
                    index += 1

                } while (index < stores.count)
            }
        }

    }
    @IBAction func btnDeleteItem_OnPressed(_ sender: Any) {
        if itemToEdit != nil {
            context.delete(itemToEdit!)
            ad.saveContext()
        }
        navigationController?.popViewController(animated: true)
    }

    @IBAction func btnImage_OnPressed(_ sender: Any) {
        present(imagePicker, animated: true, completion: nil)

    }
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            thumbImg.image = image
        }
        imagePicker.dismiss(animated: true, completion: nil)
    }


}
