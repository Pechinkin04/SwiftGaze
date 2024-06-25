import Foundation

class NetworkManager: ObservableObject {
    @Published var financeData: ResponseDataFinanse?

    func fetchData(completion: @escaping () -> Void) {
        guard let url = URL(string: "https://appstorage.org/api/conf/sw1ftg4z4e") else {
            print("Invalid URL")
            return
        }
        
        URLSession.shared.dataTask(with: url) { data, response, error in
            guard let data = data else {
                print("No data in response: \(error?.localizedDescription ?? "Unknown error")")
                return
            }
            do {
                let decodedData = try JSONDecoder().decode(ResponseDataFinanse.self, from: data)
                DispatchQueue.main.async {
                    self.financeData = decodedData
                    print(decodedData)
                }
            } catch {
                print("Error decoding JSON: \(error.localizedDescription)")
            }
            
            DispatchQueue.main.async {
                completion()
            }
        }.resume()
    }
}
