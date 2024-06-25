//
//  Extensions.swift
//  Swift Gaze
//
//  Created by Александр Печинкин on 19.06.2024.
//

import Foundation
import SwiftUI

extension List {
    @available(iOS 14, *)
    func backgroundList(_ color: Color = .clear) -> some View {
        UITableView.appearance().backgroundColor = UIColor(color)
        return self
    }
}

extension UIApplication {
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}


extension UserDefaults {
    func getShedule(forKey key: String)  -> [Record] {
        if let data = data(forKey: key), let shedule = try? JSONDecoder().decode([Record].self, from: data) {
            return shedule
        }
        return []
    }
    
    func setShedule(_ shedule: [Record], forKey key: String) {
        if let encoded = try? JSONEncoder().encode(shedule) {
            set(encoded, forKey: key)
        }
    }
    
    func getCategoryRecords(forKey key: String)  -> [CategoryRecord] {
        if let data = data(forKey: key), let categoryRecords = try? JSONDecoder().decode([CategoryRecord].self, from: data) {
            return categoryRecords
        }
        return []
    }
    
    func setCategoryRecords(_ categoryRecords: [CategoryRecord], forKey key: String) {
        if let encoded = try? JSONEncoder().encode(categoryRecords) {
            set(encoded, forKey: key)
        }
    }
    
}
