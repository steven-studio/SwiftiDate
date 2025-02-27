//
//  PhotoUtility.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/17.
//

import Foundation
import UIKit

struct PhotoUtility {
    static func loadImageFromLocalStorage(named imageName: String) -> UIImage? {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageName)
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }

    static func saveImageToLocalStorage(image: UIImage, withName imageName: String) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageName)
            try? data.write(to: url)
        }
    }

    static func deleteImageFromLocalStorage(named imageName: String) {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(imageName)
        try? FileManager.default.removeItem(at: url)
    }
    
    // 加載照片
    static func loadPhotosFromAppStorage() {
        if !userSettings.loadedPhotosString.isEmpty {
            print("Loaded cached photos from AppStorage: \(userSettings.loadedPhotosString)")
            userSettings.photos = userSettings.loadedPhotosString.components(separatedBy: ",")
        } else {
            print("No cached photos found in AppStorage, fetching from Firebase.")
            FirebasePhotoManager.shared.fetchPhotosFromFirebase {
                
            }
        }
    }
    
    static func addImageToPhotos(_ image: UIImage, to userSettings: UserSettings) {
        let imageName = UUID().uuidString
        PhotoUtility.saveImageToLocalStorage(image: image, withName: imageName)
        userSettings.photos.append(imageName)
        userSettings.loadedPhotosString = userSettings.photos.joined(separator: ",")
    }
    
    static func removePhoto(_ photoName: String, from userSettings: UserSettings) {
        if let index = userSettings.photos.firstIndex(of: photoName) {
            userSettings.photos.remove(at: index)
            userSettings.loadedPhotosString = userSettings.photos.joined(separator: ",")
        }
        PhotoUtility.deleteImageFromLocalStorage(named: photoName)
    }
}
