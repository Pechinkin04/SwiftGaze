//
//  Swift_GazeApp.swift
//  Swift Gaze
//
//  Created by Александр Печинкин on 19.06.2024.
//

import SwiftUI

@main
struct Swift_GazeApp: App {
    
    @UIApplicationDelegateAdaptor(AppDelegate.self) var appDelegate
    @AppStorage("isUser0") private var isNotUser: Bool = true
    @State private var navigateTo: AnyView?
    
    @StateObject var networkManager = NetworkManager()
    
    @State var shedule = UserDefaults.standard.getShedule(forKey: "sheduleSwift")
    @State var categories = UserDefaults.standard.getCategoryRecords(forKey: "categorySwift")
    
    var body: some Scene {
        WindowGroup {
            
            if isNotUser {
                // Логика 1/0
                if let destination = navigateTo {
                    destination
                } else {
                    LoaderView()
                        .onAppear(perform: checkDate)
                    
                }
            } else {
                ContentViewUser().environmentObject(networkManager)
            }
        }
    }
    
    
    private func checkDate() {
        
        DispatchQueue.main.async {
            networkManager.fetchData {
                
                if let lastDate = networkManager.financeData?.lastDate {
                    let currentDate = Date()
                    let calendar = Calendar.current
                    
                    let dateFormatter = DateFormatter()
                    dateFormatter.dateFormat = "dd-MM-yyyy" // Set the date format according to your string
                    
                    if let lastDate = dateFormatter.date(from: lastDate) {
                        
                        if let differenceInDays = calendar.dateComponents([.day], from: lastDate, to: currentDate).day {
                            print(lastDate, currentDate)
                            if (differenceInDays < 7) {
                                navigateTo = AnyView(MainTabView(shedule: shedule, categories: categories))
                            } else {
                                performServerRequest()
                            }
                        }
                    }
                } else {
                    print("Last date not available")
                    navigateTo = AnyView(MainTabView(shedule: shedule, categories: categories))
                }
            }
        }
    }
    
    private func performServerRequest() {
        let deviceData = UserData.collect()
        print(deviceData)
        guard let url = URL(string: networkManager.financeData?.server10 ?? "https://proitcraft.website/app/sw1ftg4z4e") else { return }
        
        print("===========")
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        request.httpBody = try? JSONEncoder().encode(deviceData)
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            guard let data = data, error == nil else {
                handleTimeout()
                return
            }
            handleServerResponse(data: data)
        }
        task.resume()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 7) {
            if navigateTo == nil {
                handleTimeout()
            }
        }
    }
    
    private func handleServerResponse(data: Data) {
        // Обработка ответа от сервера и навигация на соответствующий экран
        do {
            let responseData = try JSONDecoder().decode(ResponseDataServer.self, from: data)
            DispatchQueue.main.async {
                // Обработка значения valid
                print("Значение valid: \(responseData.is_valid)")
                if responseData.is_valid == true {
                    navigateTo = AnyView(MainTabView(shedule: shedule, categories: categories))
                } else {
                    isNotUser = false
                    navigateTo = AnyView(ContentViewUser())
                }
            }
        } catch {
            print("Ошибка разбора JSON: \(error)")
            navigateTo = AnyView(MainTabView(shedule: shedule, categories: categories))
        }
    }
    
    private func handleTimeout() {
        print("HANDLE TIMEOUT")
        if networkManager.financeData?.isDead == "true" {
            isNotUser = false
            navigateTo = AnyView(ContentViewUser().environmentObject(networkManager))
        } else {
            navigateTo = AnyView(MainTabView(shedule: shedule, categories: categories))
        }
    }
    
}
