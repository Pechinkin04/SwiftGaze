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
