//
//  APIManager.swift
//  APITestApp
//
//  Created by Дмитрий Пономаренко on 24.09.23.
//

import UIKit


class APIManager {
    
    
    func fetchData(URL url: String, complition: @escaping (Page) -> Void) {
        
        guard let url = URL(string: url) else {
            return
        }
        
        let session = URLSession.shared
        let task = session.dataTask(with: url) { data, response, error in
            
            if let data = data {
                do {
                    let json =  try JSONDecoder().decode(Page.self , from: data)
                    complition(json)
                } catch {
                    print(error)
                }
            }
            
        }
        task.resume()
        
        
        
    }
    
    func postData(name: String, image: UIImage, id: Int) {
        guard let url = URL(string: "https://junior.balinasoft.com/api/v2/photo") else { return }

        let parameters: [String: Any] = ["id": id, "name": name, "photo": image]
        var request = URLRequest(url: url)
        request.addValue(("application/json"), forHTTPHeaderField: "Content-Type")
        request.httpMethod = "POST"
        
        guard let httpBody = try? JSONSerialization.data(withJSONObject: parameters) else { return }
        request.httpBody = httpBody
        
        let session = URLSession.shared
        session.dataTask(with: request) { data, response, error in
            if let response = response {
                print(response)
        }
            guard let data = data else { return }
            do {
                let json = try  JSONSerialization.jsonObject(with: data)
            } catch {
                print(error)
            }
        }.resume()
    }
}
