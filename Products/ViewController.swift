//
//  ViewController.swift
//  Products
//
//  Created by otet_tud on 1/24/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate {
    
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var idlbl: UILabel!
    @IBOutlet weak var desclbl: UILabel!
    @IBOutlet weak var pricelbl: UILabel!
    
    var productList = [Product]()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        // Load the products
        loadCoreData()
        
        if productList.count <= 0 {
            // This means we have not save the initial data yet into core
            // Create initial data
            createInitialData()
            saveCoreData()
        }
        
        // Configure the View
        configureView(idx: 0)
    }
    
    func configureView(idx: Int) {
        namelbl!.text = productList[idx].getName()
        idlbl!.text = String(productList[idx].getID())
        desclbl!.text = productList[idx].getDesc()
        pricelbl!.text = String(productList[idx].getPrice())
        
    }
    
    
    func createInitialData() {
        productList.append(Product(name: "Ferrero Rocher", id: 1, desc: "Hazelnut Chocolate", price: 16.50))
        productList.append(Product(name: "M&M", id: 2, desc: "Candy Coated Chocolate", price: 9.10))
        productList.append(Product(name: "Oreo", id: 3, desc: "Chocolate Cream Sandwich", price: 3.00))
        productList.append(Product(name: "KitKat", id: 4, desc: "Chocolate Coated Wafer Sticks", price: 2.47))
        productList.append(Product(name: "Mars", id: 5, desc: "Chocolate Caramel Bar", price: 2.00))
        productList.append(Product(name: "Reese", id: 6, desc: "Chocolate Coated Peanut Cups", price: 2.00))
        productList.append(Product(name: "Baby Ruth", id: 7, desc: "Caramel, Nuts and Chocolate Bar", price: 3.50))
        productList.append(Product(name: "Hershey", id: 8, desc: "Old School Chocolate Bar", price: 1.50))
        productList.append(Product(name: "Raisinets", id: 9, desc: "Chocolate Coated Raisins", price: 1.99))
        productList.append(Product(name: "Kinder", id: 10, desc: "Cream Filled Wafer Chocolate", price: 2.50))
    }
    
    
    func loadCoreData() {
        productList = [Product]()

        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        //Load the folders
        var fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductEntity")
        do {
            let results = try managedContext.fetch(fetchRequest)
            if results is [NSManagedObject] {
                for result in results as! [NSManagedObject] {
                    let name = result.value(forKey: "name") as! String
                    let desc = result.value(forKey: "desc") as! String
                    let id = result.value(forKey: "id") as! Int
                    let price = result.value(forKey: "price") as! Double
                    
                    productList.append(Product(name: name, id: id, desc: desc, price: price))
                }
            }
        } catch { print(error) }
    }

    func saveCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        
        // Just to be sure, clearing it first
        clearCoreData()
        for product in productList {
            let proEntity = NSEntityDescription.insertNewObject(forEntityName: "ProductEntity", into: managedContext)
                    
            proEntity.setValue(product.getName(), forKey: "name")
            proEntity.setValue(product.getDesc(), forKey: "desc")
            proEntity.setValue(product.getID(), forKey: "id")
            proEntity.setValue(product.getPrice(), forKey: "price")
            do {
                try managedContext.save()
            } catch { print(error) }
        }
    }
        
    func clearCoreData() {
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        let managedContext = appDelegate.persistentContainer.viewContext
        // Create a fetch request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "ProductEntity")
        fetchRequest.returnsObjectsAsFaults = false
        do {
            let results = try managedContext.fetch(fetchRequest)
            for managedObjects in results {
                if let managedObjectData = managedObjects as? NSManagedObject {
                    managedContext.delete(managedObjectData)
                }
            }
        } catch{ print(error)  }
    }
}

