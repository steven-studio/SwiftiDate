//
//  RuleChecker.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/22.
//

import Foundation

struct RuleChecker {
    static let suspiciousDomains: Set<String> = [
        "bit.ly", "tinyurl.com", "freegift.com", "malicious-domain.com"
        // ... 你可隨時加更多
    ]
    
    /// 主要檢查函式：根據多條規則，回傳檢查結果
    static func checkMessage(
        message: String,
        messagesSoFar: [Message],
        currentUserGender: Gender,
        completion: @escaping (SuspiciousCheckResult) -> Void
    ) {
        let trimmedText = message.trimmingCharacters(in: .whitespaces)
        guard !trimmedText.isEmpty else { return }
        
        // 1) 先做「男性用戶第一句就約砲」的規則
        if currentUserGender == .male {
            // 如果目前訊息是第一句 (messagesSoFar.isEmpty)
            if messagesSoFar.isEmpty {
                // 先把所有空白去掉(或視需求)，再用正規表示式檢查
                if isFirstMessageHookupRegex(message) {
                    completion(.block(.firstMessageHookup))
                    return
                }
            }
            
            // 2) 男性用戶第一階段就告白
            // 假設只要出現「我喜歡你」就提醒
            if isExactConfession(message) {
                completion(.warn(.tooFastConfession))
                return
            }
        }
        
        // 1) 在 checkMessage(...) 中，插入一段邏輯：
        //    若使用者性別為女性，且訊息包含「我們來點刺激的」，就視為詐騙。
        if currentUserGender == .female {
            let loweredMsg = message.lowercased()
            // 這裡可依需求：完整相等、或只要包含關鍵字
            if loweredMsg == "我們來點刺激的" || loweredMsg == "要不要來點刺激的" || loweredMsg == "要不來點刺激的" {
                completion(.block(.scamKeyword)) // 或你想用別的 reason
                return
            }
        }
        
        // 2) 檢查 scamKeywords
        let scamKeywords = ["ATM", "匯款", "投資保證", "娛樂城", "金大發", "老子有錢", "借錢", "借我錢"]
        let loweredMessage = message.lowercased()
        for keyword in scamKeywords {
            if loweredMessage.contains(keyword.lowercased()) {
                completion(.block(.scamKeyword))
                return
            }
        }
        
        // 3) 呼叫遠端的 PhishingChecker 檢查是否有可疑/惡意網址 (非同步)
        PhishingChecker.hasPhishingDomain(message) { isPhishing in
            if isPhishing {
                // 如果雲端判定有惡意網址 → 直接 Block
                completion(.block(.phishingLink))
                return
            }
        }
        
        NLPChecker.isScamOrSale(message) { isScamSale in
            if isScamSale {
                completion(.block(.scamKeyword)) // 或另外定義 reason
                return
            }
        }
        
        // 在 checkMessage(...) 裡
        NLPChecker.isBallsInHerHandNLP(message) { isBalls in
            if isBalls {
                completion(.warn(.ballsInHerHand))
                return
            }
        }
        
        NLPChecker.isNSFW(message) { isNSFW in
            if isNSFW {
                // 執行你的攔截或提示邏輯
                completion(.block(.NSFWKeyword))
                return
            }
        }
        
        // 如果沒有任何非同步，也沒有被攔截 => 最終
        completion(.allow)
    }
    
    static func isFirstMessageHookupRegex(_ message: String) -> Bool {
        // 先去除空白等
        let trimmed = message.trimmingCharacters(in: .whitespacesAndNewlines)
        
        // 定義一個 pattern，把所有可疑關鍵詞用 (xxx|yyy|zzz) 形式
        // 注意要 escape 特殊符號
        let pattern = #"^(約嗎|要不要約|要不約|約砲|約\？|約嗎？)$"#
        
        // 建立正規表示式
        guard let regex = try? NSRegularExpression(pattern: pattern, options: .caseInsensitive) else {
            return false
        }
        
        // 在整個字串裡找匹配
        let range = NSRange(location: 0, length: trimmed.utf16.count)
        // 如果有符合，返回 true
        if let match = regex.firstMatch(in: trimmed, options: [], range: range) {
            return match.range.location != NSNotFound
        }
        return false
    }
    
    static func isExactConfession(_ message: String) -> Bool {
        let lowered = message.trimmingCharacters(in: .whitespacesAndNewlines).lowercased()
        
        // 這個 pattern 表示「整句」必須是 "我喜歡(你|妳)" 或 "我想和(你|妳)睡"
        // 可以加入更多 | (或) 分支
        let pattern = #"^(我喜歡(你|妳)|我想和(你|妳)睡)$"#
        
        guard let regex = try? NSRegularExpression(pattern: pattern) else {
            return false
        }
        let range = NSRange(location: 0, length: lowered.utf16.count)
        if let match = regex.firstMatch(in: lowered, options: [], range: range) {
            return match.range.location != NSNotFound
        }
        return false
    }
}
