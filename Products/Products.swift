//
//  Products.swift
//  Products
//
//  Created by otet_tud on 1/24/20.
//  Copyright © 2020 otet_tud. All rights reserved.
//

import Foundation

class Product {
    internal init(name: String, id: Int, desc: String, price: Double) {
        self.name = name
        self.id = id
        self.desc = desc
        self.price = price
    }
    
    var name : String
    var id : Int
    var desc : String
    var price : Double
    
    func getName() -> String { return self.name }
    func getDesc() -> String { return self.desc }
    func getPrice() -> Double { return self.price }
    func getID() -> Int { return self.id }
    
    
}
