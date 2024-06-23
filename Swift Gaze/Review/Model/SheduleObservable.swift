//
//  SheduleObservable.swift
//  Swift Gaze
//
//  Created by Александр Печинкин on 19.06.2024.
//

import Foundation
import SwiftUI

final class SheduleObservable: ObservableObject {
    @Published var shedule: [Record] = MockData.shedule
}
