//
//  ViewController.swift
//  Products
//
//  Created by otet_tud on 1/24/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import UIKit
import Foundation
import CoreData

class ViewController: UIViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    @IBOutlet weak var namelbl: UILabel!
    @IBOutlet weak var idlbl: UILabel!
    @IBOutlet weak var desclbl: UILabel!
    @IBOutlet weak var pricelbl: UILabel!
    @IBOutlet weak var instruction: UILabel!
    
    var currProduct : Int = 0
    var productList = [Product]()
    
    //For the search
    //For the searchbar
    var resultSearchController : UISearchController!
    var filteredTableData = [Product]()
    
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
        
        // Set searchbar
        resultSearchController = ({
            let controller = UISearchController(searchResultsController: nil)
            controller.searchResultsUpdater = self
            controller.definesPresentationContext = true
            controller.searchBar.placeholder = "Search"
            controller.obscuresBackgroundDuringPresentation = false
            controller.searchBar.sizeToFit()
            controller.searchBar.autocapitalizationType = .none
            return controller
        })()
        navigationItem.searchController = resultSearchController
        
        // Configure the View
        configureView(idx: 0)
        
        // Add these gestures to navigate products
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.right
        view.addGestureRecognizer(swipeRight)
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(swiped))
        swipeRight.direction = UISwipeGestureRecognizer.Direction.left
        view.addGestureRecognizer(swipeLeft)
        
    }
    
    func configureView(idx: Int) {
        
        namelbl!.text = resultSearchController.isActive ?  filteredTableData[idx].getName() : productList[idx].getName()
        idlbl!.text = resultSearchController.isActive ?  String(filteredTableData[idx].getID()) : String(productList[idx].getID())
        desclbl!.text = resultSearchController.isActive ?  filteredTableData[idx].getDesc() : productList[idx].getDesc()
        pricelbl!.text = resultSearchController.isActive ?  String(filteredTableData[idx].getPrice()) : String(productList[idx].getPrice())

        instruction!.text = resultSearchController.isActive ? "Swipe Left/Right To Navigate SEARCH RESULTS" : "Swipe Left/Right To Navigate ALL Products" 
        
//        namelbl!.text = productList[idx].getName()
//        idlbl!.text = String(productList[idx].getID())
//        desclbl!.text = productList[idx].getDesc()
//        pricelbl!.text = String(productList[idx].getPrice())
//
//        instruction!.text = "Swipe Left/Right To Navigate All Products"
        
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
    
    @objc func swiped (gesture: UISwipeGestureRecognizer) {
        let swipeGesture = gesture as UISwipeGestureRecognizer
        var dbCount = resultSearchController.isActive ? filteredTableData.count : productList.count
        if dbCount == 0 {
            dbCount = productList.count
        }
        
            switch swipeGesture.direction {
            case UISwipeGestureRecognizer.Direction.right:
                currProduct += 1
                currProduct = currProduct <= dbCount-1 ? currProduct : dbCount-1
                configureView(idx: currProduct)
            case UISwipeGestureRecognizer.Direction.left:
                currProduct = currProduct == 0 ? dbCount-1 : currProduct - 1
                configureView(idx: currProduct)
            default:
                break
            }
    }
    
    func updateSearchResults(for searchController: UISearchController) {
        filteredTableData.removeAll(keepingCapacity: false)
        print("DEBUG: This is updated, the searchbar")
        for idx in productList  {
            if idx.getName().localizedCaseInsensitiveContains(searchController.searchBar.text!) || idx.getDesc().localizedCaseInsensitiveContains(searchController.searchBar.text!) {
                filteredTableData.append(idx)
            }
        }
        if filteredTableData.count > 0 {
            configureView(idx: 0) }
    }
    
    @IBAction func addButtonPressed(_ sender: UIBarButtonItem) {
        let alertController = UIAlertController(title: "New Product", message: "Enter details for this new product.", preferredStyle: .alert)
        var nName : UITextField?
        var nId : UITextField?
        var nDesc: UITextField?
        var nPrice : UITextField?
        
//        alertController.addTextField { (nName) in
//            nName.placeholder = "Name"
//        }
            
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        
        let addItemAction = UIAlertAction(title: "Add Product", style: .default) { (action) in
            let textField = alertController.textFields![0]
            print("DEBUG: Will be adding folder \(textField.text!)")
            if (alertController.textFields![0].text!.isEmpty || alertController.textFields![1].text!.isEmpty || alertController.textFields![2].text!.isEmpty || alertController.textFields![3].text!.isEmpty) {
                print("This cannot be added")
            } else {
                self.productList.append(Product(name: alertController.textFields![0].text!, id: Int(alertController.textFields![1].text!)!, desc: alertController.textFields![2].text!, price: Double(alertController.textFields![3].text!)!))
            }
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(addItemAction)
            
        self.present(alertController, animated: true, completion: nil)
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let prodDelegate = segue.destination as? ProductsTableViewController {
                   prodDelegate.delegate = self
               }
    }
}

