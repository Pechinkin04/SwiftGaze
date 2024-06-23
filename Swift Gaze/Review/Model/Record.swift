//
//  Record.swift
//  Swift Gaze
//
//  Created by Александр Печинкин on 19.06.2024.
//

import Foundation

struct Record: Identifiable, Codable {
    var id = UUID()
    
    var category: CategoryRecord
    var text: String
    var date: Date
    var completed: Bool
    
    var tasks: [TaskRecord]
    
}

struct CategoryRecord: Identifiable, Codable {
    var id = UUID()
    
    var img: ImageCategory
    var text: String
}

enum ImageCategory: String, CaseIterable, Codable {
    case clap = "hands.sparkles.fill"
    case star = "star.fill"
    case bolt = "bolt.fill"
    case fire = "flame.fill"
    case hand = "hand.draw.fill"
    case heart = "heart.fill"
}

struct TaskRecord: Identifiable, Codable, Hashable {
    var id = UUID()
    
    var text: String
    var done: Bool
    var group: TaskGroup

    func hash(into hasher: inout Hasher) {
        hasher.combine(id)
    }
}

enum TaskGroup: String, CaseIterable, Codable {
    case urgently = "Urgently"
    case secondary = "Secondary"
    case notUrgent = "Not urgent"
}


struct MockData {
    
    static var categories = [
        CategoryRecord(img: .fire, text: "Online"),
        CategoryRecord(img: .bolt, text: "Offline")
    ]
    
    static var shedule = [
        Record(category: MockData.categories[0],
               text: "Online lesson0",
               date: Date(),
               completed: true,
              tasks: [
                TaskRecord(text: "Record a lecture0",
                           done: false,
                           group: .urgently),
                TaskRecord(text: "Prepare the material0",
                           done: false,
                           group: .urgently),
                TaskRecord(text: "Record a lecture00",
                           done: true,
                           group: .urgently),
                TaskRecord(text: "Prepare the material0",
                           done: false,
                           group: .urgently),
                TaskRecord(text: "Record a lecture00",
                           done: true,
                           group: .urgently),
                TaskRecord(text: "Record a video0",
                           done: false,
                           group: .secondary)
              ]),
        
        Record(category: MockData.categories[1],
               text: "Online lesson1",
               date: Date(),
               completed: false,
               tasks: [
                 TaskRecord(text: "Record a lecture1",
                            done: false,
                            group: .urgently),
                 TaskRecord(text: "Prepare the material1",
                            done: false,
                            group: .urgently),
                 TaskRecord(text: "Record a lecture1",
                            done: true,
                            group: .urgently),
                 TaskRecord(text: "Record a video1",
                            done: false,
                            group: .secondary)
               ]),
        
        Record(category: MockData.categories[0],
               text: "Online lesson2",
               date: Date(),
               completed: false,
               tasks: [
                 TaskRecord(text: "Record a lecture2",
                            done: false,
                            group: .urgently),
                 TaskRecord(text: "Prepare the material2",
                            done: false,
                            group: .urgently),
                 TaskRecord(text: "Record a lecture2",
                            done: true,
                            group: .urgently),
                 TaskRecord(text: "Record a video2",
                            done: false,
                            group: .secondary)
               ]),
        
        Record(category: MockData.categories[0],
               text: "Online lesson3",
               date: Date(),
               completed: false,
               tasks: [
                 TaskRecord(text: "Record a lecture3",
                            done: false,
                            group: .urgently),
                 TaskRecord(text: "Prepare the material3",
                            done: false,
                            group: .urgently),
                 TaskRecord(text: "Record a lectur3e",
                            done: true,
                            group: .urgently),
                 TaskRecord(text: "Record a vide3o",
                            done: false,
                            group: .secondary)
               ]),
        
        Record(category: MockData.categories[0],
               text: "Online lesson4",
               date: Date(),
               completed: false,
               tasks: [
                 TaskRecord(text: "Record a lecture4",
                            done: false,
                            group: .urgently),
                 TaskRecord(text: "Prepare the material4",
                            done: false,
                            group: .urgently),
                 TaskRecord(text: "Record a lecture4",
                            done: true,
                            group: .urgently),
                 TaskRecord(text: "Record a video4",
                            done: false,
                            group: .secondary)
               ])
        
    ]
    
}
