//
//  ShoppingManager.swift
//  ArbuzApp
//
//  Created by Balausa on 23.05.2023.
//

import UIKit

class ShoppingManager {
    static let shared = ShoppingManager()

    private var items: [Product] = []

    private init() {}

    func addItem(_ item: Product) {
        items.append(item)
    }

    func removeItem(at index: Int) {
        guard index >= 0 && index < items.count else {
            return
        }
        items.remove(at: index)
    }

    func removeAllItems() {
        items.removeAll()
    }

    func getIndexById(id: Int) -> Int? {
        if let index = items.firstIndex(where: { item in
            item.id == id
        }) {
            return index
        }
        
        return nil
    }
    
    func changeQuantity(index: Int, quantity: Int) {
        items[index].quantity = quantity
    }
    
    func getItems() -> [Product] {
        return items
    }

    func getTotalPrice() -> Double {
        return items.reduce(0) { $0 + ($1.price * Double($1.quantity)) }
    }

    func getTotalQuantity() -> Int {
        return items.reduce(0) { $0 + $1.quantity }
    }
}
