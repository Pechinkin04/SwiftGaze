//
//  Swift_GazeApp.swift
//  Swift Gaze
//
//  Created by Александр Печинкин on 19.06.2024.
//

import SwiftUI

@main
struct Swift_GazeApp: App {
    
//    var shedule = SheduleObservable()
    @State var shedule = MockData.shedule
    @State var categories = MockData.categories
    
    var body: some Scene {
        WindowGroup {
            MainTabView(shedule: shedule, categories: categories)
        }
    }
}
