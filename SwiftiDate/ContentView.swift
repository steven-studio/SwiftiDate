//
//  ContentView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/18.
//

import SwiftUI
import FirebaseStorage
import WebRTC

struct ContentView: View {
    @EnvironmentObject var appState: AppState
    @EnvironmentObject var userSettings: UserSettings
    
    var body: some View {
        if appState.isLoggedIn {
            MainView()
                .environmentObject(appState) // 傳遞 appState
                .environmentObject(userSettings)
                .onAppear {
                    loadPhotosFromAppStorage()
                }
        } else {
            LoginView()
                .environmentObject(appState)
                .environmentObject(userSettings)
                .onAppear {
                    loadPhotosFromAppStorage()
                }
        }
    }
    
    // 加載照片
    func loadPhotosFromAppStorage() {
        if !userSettings.loadedPhotosString.isEmpty {
            print("Loaded cached photos from AppStorage: \(userSettings.loadedPhotosString)")
            userSettings.photos = userSettings.loadedPhotosString.components(separatedBy: ",")
        } else {
            print("No cached photos found in AppStorage, fetching from Firebase.")
            fetchPhotosFromFirebase()
        }
    }
    
    // Fetch photos from Firebase Storage
    func fetchPhotosFromFirebase() {
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
//                 註解：以前的代碼可以編譯通過，但是在新的 Firebase SDK 或 Swift 編譯器更新之後，
//                 回調函式的參數型別或 API 使用方式發生了變更，導致舊的寫法不再適用。
//                 現在需要使用 Result<URL, Error> 來處理下載 URL 的結果。
//                item.downloadURL { (url, error) in
//                    if let error = error {
//                        print("Error getting download URL: \(error)")
//                        return
//                    }
//
//                    if let url = url {
//                        let urlString = url.absoluteString
//
//                        // Extract the number from the photo name
//                        if let photoNumber = extractPhotoNumber(from: urlString) {
//                            fetchedPhotoURLs.append((urlString, photoNumber))
//                        }
//
//                        // Once all URLs are fetched, sort by photo number
//                        if fetchedPhotoURLs.count == result.items.count {
//                            fetchedPhotoURLs.sort { $0.photoNumber < $1.photoNumber }
//
//                            // Download each photo and save it to local storage
//                            for (urlString, _) in fetchedPhotoURLs {
//                                downloadAndSavePhoto(from: urlString) { imageName in
//                                    if let imageName = imageName {
//                                        downloadedPhotos.append((url: urlString, imageName: imageName))
//                                    }
//
//                                    // If all photos are downloaded, update the photos array
//                                    if downloadedPhotos.count == fetchedPhotoURLs.count {
//                                        // Sort the downloaded photos according to fetchedPhotoURLs order
//                                        downloadedPhotos.sort { lhs, rhs in
//                                            fetchedPhotoURLs.firstIndex(where: { $0.url == lhs.url })! < fetchedPhotoURLs.firstIndex(where: { $0.url == rhs.url })!
//                                        }
//
//                                        DispatchQueue.main.async {
//                                            // Update the photos array and AppStorage
//                                            userSettings.photos = downloadedPhotos.map { $0.imageName }
//                                            userSettings.loadedPhotosString = userSettings.photos.joined(separator: ",")
//                                            print("Updated photos array after download: \(self.photos)")
//                                        }
//                                    }
//                                }
//                            }
//                        }
//                    }
//                }
//                print("Processing item \(index + 1) of \(listResult.items.count): \(item.name)")
                
                item.downloadURL { result in
                    processedItemCount += 1
//                    print("Download URL callback for item \(item.name), result: \(result)")
                    
                    switch result {
                    case .success(let url):
                        let urlString = url.absoluteString
                        
                        // Extract the number from the photo name
                        if let photoNumber = extractPhotoNumber(from: urlString) {
                            fetchedPhotoURLs.append((urlString, photoNumber))
                        }
                        
                        // Once all URLs are fetched, sort by photo number
                        if processedItemCount == listResult.items.count {
                            fetchedPhotoURLs.sort { $0.photoNumber < $1.photoNumber }
                            
                            // Download each photo and save it to local storage
                            for (urlString, _) in fetchedPhotoURLs {
                                downloadAndSavePhoto(from: urlString) { imageName in
                                    if let imageName = imageName {
                                        downloadedPhotos.append((url: urlString, imageName: imageName))
                                    }
                                    
                                    // If all photos are downloaded, update the photos array
                                    if downloadedPhotos.count == fetchedPhotoURLs.count {
                                        // Sort the downloaded photos according to fetchedPhotoURLs order
                                        downloadedPhotos.sort { lhs, rhs in
                                            fetchedPhotoURLs.firstIndex(where: { $0.url == lhs.url })! < fetchedPhotoURLs.firstIndex(where: { $0.url == rhs.url })!
                                        }
                                        
                                        DispatchQueue.main.async {
                                            // Update the photos array and AppStorage
                                            userSettings.photos = downloadedPhotos.map { $0.imageName }
                                            userSettings.loadedPhotosString = userSettings.photos.joined(separator: ",")
                                            print("Updated photos array after download: \(userSettings.photos)")
                                            // 檢查
                                            if userSettings.loadedPhotosString.isEmpty {
                                                print("下載結束，但 loadedPhotosString 依然是空的，表示沒有照片")
                                            } else {
                                                print("下載結束，成功存入 loadedPhotosString = \(userSettings.loadedPhotosString)")
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    case .failure(let error):
                        print("Error getting download URL: \(error)")
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
            .environmentObject(AppState())
            .environmentObject(UserSettings()) // 確保預覽時的環境變量
            .previewDevice("iPhone 15 Pro")  // 这里您可以选择想要预览的设备
    }
}
