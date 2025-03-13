//
//  PhishingChecker.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/22.
//

import Foundation

struct PhishingChecker {
    // 這是呼叫雲端函式的 Endpoint
    private static let checkUrlEndpoint = "https://us-central1-swiftidate-cdff0.cloudfunctions.net/checkUrl"
    
    /// 偵測訊息中是否包含任何惡意網址 (遠端檢查版)
    static func hasPhishingDomain(
        _ message: String,
        completion: @escaping (Bool) -> Void
    ) {
        let pattern = #"(https?:\/\/[^\s]+)|(www\.[^\s]+)"#
        guard let regex = try? NSRegularExpression(pattern: pattern, options: [.caseInsensitive]) else {
            completion(false)
            return
        }
        
        let text = message.trimmingCharacters(in: .whitespacesAndNewlines)
        let range = NSRange(location: 0, length: text.utf16.count)
        
        // 找第一個符合的 URL
        guard let match = regex.firstMatch(in: text, options: [], range: range),
              let urlRange = Range(match.range, in: text) else {
            // 若整段訊息沒抓到任何 URL，就直接回傳 false
            completion(false)
            return
        }
        
        // 擷取出來的字串，可能缺 http:// 協定 → 可視情況自動補
        var urlString = String(text[urlRange])
        if !urlString.lowercased().hasPrefix("http://") &&
           !urlString.lowercased().hasPrefix("https://") {
            urlString = "https://" + urlString
        }
        
        // 呼叫遠端 checkUrl，丟過去檢查
        callCheckUrlCloudFunction(urlString) { isMalicious in
            completion(isMalicious)
        }
    }
    
    /// 呼叫雲端函式 checkUrl (onCall) 進行惡意檢查
    private static func callCheckUrlCloudFunction(
        _ urlString: String,
        completion: @escaping (Bool) -> Void
    ) {
        // 1. 建立要呼叫的 URLRequest
        guard let url = URL(string: checkUrlEndpoint) else {
            completion(false)
            return
        }
        
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        // onCall 預設要用 JSON 傳參數
        request.setValue("application/json", forHTTPHeaderField: "Content-Type")
        
        // 對應雲端函式的 onCall 格式 => {"data": {"url": "<要檢查的URL>"}}
        let body: [String: Any] = [
            "data": [
                "url": urlString
            ]
        ]
        
        guard let jsonData = try? JSONSerialization.data(withJSONObject: body, options: []) else {
            completion(false)
            return
        }
        request.httpBody = jsonData
        
        // 2. 發送請求
        URLSession.shared.dataTask(with: request) { data, response, error in
            // 若連線失敗，直接回傳 false
            if let error = error {
                print("callCheckUrlCloudFunction error:", error)
                completion(false)
                return
            }
            
            guard let data = data else {
                completion(false)
                return
            }
            
            // 3. 分析雲端函式回傳的 JSON
            // 雲端若成功執行(無 throw)，大概會回 {"result": {"isMalicious": Bool, "raw": ...}}
            // 若失敗(有 throw)，則會回 {"error": {"status":"UNKNOWN","message":"some error message", ...}}
            do {
                if let jsonObject = try JSONSerialization.jsonObject(with: data) as? [String: Any] {
                    // 先檢查有沒有 error
                    if let errorObj = jsonObject["error"] as? [String: Any] {
                        print("checkUrl returned error:", errorObj)
                        completion(false)
                        return
                    }
                    // 沒錯誤就查看 result
                    if let resultObj = jsonObject["result"] as? [String: Any],
                       let isMalicious = resultObj["isMalicious"] as? Bool {
                        completion(isMalicious)
                    } else {
                        completion(false)
                    }
                } else {
                    completion(false)
                }
            } catch {
                print("JSON parse error:", error)
                completion(false)
            }
        }
        .resume()
    }
}
