//
//  IPManager.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/11.
//

import Foundation

class IPManager {
    // 採用單例模式，方便在 App 中隨時調用
    static let shared = IPManager()
    
    private init() {}
    
    // 這個方法會呼叫外部 API 來取得對外 IP
    func fetchPublicIP(completion: @escaping (String?) -> Void) {
        guard let url = URL(string: "https://api.ipify.org?format=json") else {
            completion(nil)
            return
        }
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            guard
                let data = data,
                error == nil,
                let jsonObject = try? JSONSerialization.jsonObject(with: data, options: []),
                let json = jsonObject as? [String: Any],
                let ip = json["ip"] as? String
            else {
                completion(nil)
                return
            }
            completion(ip)
        }
        task.resume()
    }
}
