//
//  NLPChecker.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/22.
//

import Foundation

struct NLPChecker {
    // 假設我們儲存一些「詐騙/銷售」範例句的 embedding
    static let scamSaleEmbeddings: [[Double]] = [
        // 假設已事先取得 embedding vector
        // ...
    ]
    
    // 這裡當然要換成你實際計算出的 embedding
    static let ballsInHerHandEmbeddings: [[Double]] = [
        // 例如一系列 reference vectors
        // [0.0032, -0.0153, 0.0123, ...], // embedding for "妳說什麼我都聽"
        // [0.0021, -0.0345, 0.0284, ...], // "求妳了"
        // ...
    ]
    
    // === 新增 NSFW Embeddings ===
    static let nsfwEmbeddings: [[Double]] = [
        // 一系列 NSFW 參考向量
        // 例: [0.0001, 0.0032, 0.1283, ...]
        // ...
    ]
    
    // =======================================
    // =  原本的 scam / sale
    // =======================================
    static func isScamOrSale(_ message: String, completion: @escaping (Bool) -> Void) {
        // 1. 呼叫 getEmbedding API (OpenAI)
        getEmbeddingForText(message) { vector in
            guard let vector = vector else {
                completion(false)
                return
            }
            // 2. 與 scamSaleEmbeddings 計算最高相似度
            var maxSim = 0.0
            for ref in scamSaleEmbeddings {
                let sim = cosineSimilarity(vector, ref)
                if sim > maxSim {
                    maxSim = sim
                }
            }
            // 3. 比對閾值 (假設 0.85)
            completion(maxSim >= 0.85)
        }
    }
    
    // =======================================
    // =  BallsInHerHand
    // =======================================
    static func isBallsInHerHandNLP(_ message: String, completion: @escaping (Bool) -> Void) {
        getEmbeddingForText(message) { vector in
            guard let vector = vector else {
                completion(false)
                return
            }
            // 和 ballsInHerHandEmbeddings 裡的每個向量比對
            var maxSim = 0.0
            for refVec in ballsInHerHandEmbeddings {
                let sim = cosineSimilarity(vector, refVec)
                if sim > maxSim {
                    maxSim = sim
                }
            }
            // 你可以依照實際測試調整閾值，假設 0.85
            completion(maxSim >= 0.85)
        }
    }
    
    // =======================================
    // =  新增 NSFW
    // =======================================
    static func isNSFW(_ message: String, completion: @escaping (Bool) -> Void) {
        getEmbeddingForText(message) { vector in
            guard let vector = vector else {
                completion(false)
                return
            }
            var maxSim = 0.0
            for refVec in nsfwEmbeddings {
                let sim = cosineSimilarity(vector, refVec)
                if sim > maxSim {
                    maxSim = sim
                }
            }
            // 同樣閾值 (0.85) 可依實際測試調整
            completion(maxSim >= 0.85)
        }
    }
    
    static func getEmbeddingForText(_ text: String, completion: @escaping ([Double]?) -> Void) {
        // 這裡要呼叫 OpenAI / Cohere / 其他 API
        // 回傳 embedding vector
        // ... HTTP POST ...
        // completion(embedding) or completion(nil) if error
    }
    
    static func cosineSimilarity(_ a: [Double], _ b: [Double]) -> Double {
        let dot = zip(a, b).map(*).reduce(0, +)
        let normA = sqrt(a.map { $0 * $0 }.reduce(0, +))
        let normB = sqrt(b.map { $0 * $0 }.reduce(0, +))
        return (normA != 0 && normB != 0) ? dot / (normA * normB) : 0
    }
}
