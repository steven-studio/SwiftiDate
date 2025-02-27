//
//  FirebasePhotoManager.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/16.
//

import Foundation
import FirebaseCore
import FirebaseFirestore
import FirebaseCrashlytics
import FirebaseAppCheck
import FirebaseStorage

class FirebasePhotoManager {
    // 建立一個全域可用的單例
    static let shared = FirebasePhotoManager()

    // 若需要使用 FirebaseManager 的話
    private let firebaseManager: FirebaseManager

    /// 用來追蹤「是否正在上傳」的狀態
    private var isUploading = false
    
    init(firebaseManager: FirebaseManager = .shared) {
        self.firebaseManager = firebaseManager
    }

    // Fetch photos from Firebase Storage
    func fetchPhotosFromFirebase(completion: @escaping () -> Void) {
        print("Fetching photos from Firebase started")
        userSettings.photos.removeAll() // Clear existing photos before fetching
        
        let storage = Storage.storage()
        let userID = userSettings.globalUserID // Access user ID from UserSettings
        let storageRef = storage.reference().child("user_photos/\(userID)")
        
        storageRef.listAll { (listResult, error) in
            if let error = error {
                print("Error fetching photos: \(error)")
                return
            }
                        
            // Safely unwrap the listResult
            guard let listResult = listResult else {
                print("Failed to fetch the result")
                return
            }
            
            var fetchedPhotoURLs: [(url: String, photoNumber: Int)] = []
            var downloadedPhotos: [(url: String, imageName: String)] = [] // Temporary array to store downloaded photos
            var processedItemCount = 0 // Track the number of processed items
            
            for (index, item) in listResult.items.enumerated() {
                
                item.downloadURL { result in
                    processedItemCount += 1
//                    print("Download URL callback for item \(item.name), result: \(result)")
                    
                    switch result {
                    case .success(let url):
                        let urlString = url.absoluteString
                        
                        // Extract the number from the photo name
                        if let photoNumber = self.extractPhotoNumber(from: urlString) {
                            fetchedPhotoURLs.append((urlString, photoNumber))
                        }
                    case .failure(let error):
                        print("Error getting download URL: \(error)")
                    }
                    
                    // Once all URLs are fetched, sort by photo number
                    if processedItemCount == listResult.items.count {
                        fetchedPhotoURLs.sort { $0.photoNumber < $1.photoNumber }
                        self.downloadAllPhotos(
                            fetchedPhotoURLs: fetchedPhotoURLs,
                            downloadedPhotos: downloadedPhotos
                        ) {
                            // 這是所有下載 & 更新完 userSettings.photos 的最後時機
                            completion()
                        }
                    }
                }
            }
        }
    }
    
    /// 這個 method 專門下載 & 更新 userSettings.photos
    private func downloadAllPhotos(
        fetchedPhotoURLs: [(url: String, photoNumber: Int)],
        downloadedPhotos: [(url: String, imageName: String)],
        completion: @escaping () -> Void
    ) {
        var downloadedPhotos = downloadedPhotos
        if fetchedPhotoURLs.isEmpty {
            // 若根本沒任何 URL
            completion()
            return
        }

        var completedCount = 0
        for (urlString, _) in fetchedPhotoURLs {
            self.downloadAndSavePhoto(from: urlString) { imageName in
                if let imageName = imageName {
                    downloadedPhotos.append((url: urlString, imageName: imageName))
                }
                completedCount += 1

                // 全部下載完畢
                if completedCount == fetchedPhotoURLs.count {
                    // 按照 sorted URL 順序排
                    downloadedPhotos.sort { lhs, rhs in
                        fetchedPhotoURLs.firstIndex { $0.url == lhs.url }!
                            < fetchedPhotoURLs.firstIndex { $0.url == rhs.url }!
                    }
                    
                    DispatchQueue.main.async {
                        // Update userSettings
                        userSettings.photos = downloadedPhotos.map { $0.imageName }
                        userSettings.loadedPhotosString = userSettings.photos.joined(separator: ",")
                        print("Updated photos array after download: \(userSettings.photos)")
                        
                        if userSettings.loadedPhotosString.isEmpty {
                            print("下載結束，但 loadedPhotosString 依然是空的，表示沒有照片")
                        } else {
                            print("下載結束，成功存入 loadedPhotosString = \(userSettings.loadedPhotosString)")
                        }
                        
                        // 告知外部：所有流程都完成
                        completion()
                    }
                }
            }
        }
    }
    
    // Download photo from a URL and save it to local storage
    func downloadAndSavePhoto(from urlString: String, completion: @escaping (String?) -> Void) {
        guard let url = URL(string: urlString) else {
            completion(nil)
            return
        }
        
        print("Starting download for photo: \(urlString)")
        
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error downloading photo: \(error)")
                completion(nil)
                return
            }
            
            guard let data = data, let image = UIImage(data: data) else {
                print("Failed to convert data to image for URL: \(urlString)")
                completion(nil)
                return
            }
            
            // Generate a unique name for the image and save it locally
            let imageName = UUID().uuidString
            PhotoUtility.saveImageToLocalStorage(image: image, withName: imageName)
            print("Photo downloaded and saved as \(imageName)")
            
            // 使用回調返回照片名稱
            completion(imageName)
        }
        
        task.resume()
    }
    
    func extractPhotoNumber(from urlString: String) -> Int? {
        // Extracts the number from "photoX" in the URL
        let pattern = "photo(\\d+)" // Regular expression to capture the number
        if let regex = try? NSRegularExpression(pattern: pattern),
           let match = regex.firstMatch(in: urlString, range: NSRange(urlString.startIndex..., in: urlString)),
           let range = Range(match.range(at: 1), in: urlString) {
            return Int(urlString[range])
        }
        return nil
    }
    
    /// 一次上傳 userSettings.photos 中的所有照片
    func uploadAllPhotos() {
        let photoNames = userSettings.photos // e.g. ["someUUID1", "someUUID2"...]
        guard !photoNames.isEmpty else {
            print("❌ 沒有任何照片可上傳")
            return
        }
        
        isUploading = true
        
        // 1) 建立 Request
        let url = URL(string: "https://your-api.com/upload-multiple")! // 多檔上傳 API
        var request = URLRequest(url: url)
        request.httpMethod = "POST"
        
        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")
        
        // 2) 建立 multipart body
        var body = Data()
        
        // 3) 對 userSettings.photos 裡的每張照片做讀取 + append
        for (index, photoName) in photoNames.enumerated() {
            // 3.1) 從本地 Document 目錄拿到 UIImage
            guard let image = PhotoUtility.loadImageFromLocalStorage(named: photoName) else {
                print("❌ 讀取本地照片失敗: \(photoName)")
                continue
            }
            
            // 3.2) 轉成 jpeg Data
            guard let imageData = image.jpegData(compressionQuality: 0.8) else {
                print("❌ 圖片轉 Data 失敗: \(photoName)")
                continue
            }
            
            // 3.3) multipart 裡的 filename = "photo\(index+1).jpg"
            let fieldName = "file\(index+1)" // 後端對應的參數名
            let filename = "photo\(index+1).jpg"
            
            // append --boundary
            body.append("--\(boundary)\r\n".data(using: .utf8)!)
            // Content-Disposition: form-data; name="file1"; filename="photo1.jpg"
            body.append("Content-Disposition: form-data; name=\"\(fieldName)\"; filename=\"\(filename)\"\r\n".data(using: .utf8)!)
            // Content-Type: image/jpeg
            body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
            // 圖片檔案
            body.append(imageData)
            body.append("\r\n".data(using: .utf8)!)
        }
        
        // 3.4) 結尾
        body.append("--\(boundary)--\r\n".data(using: .utf8)!)
        
        request.httpBody = body
        
        // 4) 發送
        URLSession.shared.dataTask(with: request) { data, response, error in
            DispatchQueue.main.async {
                self.isUploading = false
            }
            
            if let error = error {
                print("❌ 多張照片上傳失敗: \(error.localizedDescription)")
                return
            }
            
            // 可檢查後端回應
            if let httpResponse = response as? HTTPURLResponse {
                print("伺服器回應狀態碼: \(httpResponse.statusCode)")
            }
            
            print("✅ 多張照片已成功上傳！")
        }.resume()
    }
}
