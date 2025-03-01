//
//  PhotoSectionView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/18.
//

import Foundation
import SwiftUI

enum PhotoState {
    case empty
    case loading
    case success(UIImage)
    case failure
}

struct PhotoSectionView: View {
    @Binding var photos: [String] // Change to @Binding
    @Binding var deletedPhotos: [String] // Use @Binding to track deleted photos
    @EnvironmentObject var userSettings: UserSettings // Access global user data
    
    @State private var showImagePicker = false // 控制顯示照片選擇器
    @State private var selectedImage: UIImage? // 保存選中的圖片
    
    var body: some View {
        VStack {
            // 上排照片
            HStack(spacing: 10) {
                let topPhotos = photos.prefix(3)
                ForEach(Array(topPhotos.enumerated()), id: \.element) { index, photo in
                    loadImage(photoURL: photo, index: index)
                }
                // 如果上排照片少於 3 張，顯示 PlaceHolderView
                if topPhotos.count < 3 {
                    ForEach(topPhotos.count..<3, id: \.self) { index in
                        PlaceholderView(index: index, showImagePicker: $showImagePicker)
                    }
                }
            }

            // 下排照片
            HStack(spacing: 10) {
                let bottomPhotos = photos.suffix(from: min(photos.count, 3))
                ForEach(Array(bottomPhotos.enumerated()), id: \.element) { index, photo in
                    loadImage(photoURL: photo, index: index + 3)
                }
                // 如果下排照片少於 3 張，顯示 PlaceHolderView
                if bottomPhotos.count < 3 {
                    ForEach(bottomPhotos.count..<3, id: \.self) { index in
                        PlaceholderView(index: index + 3, showImagePicker: $showImagePicker)
                    }
                }
            }
        }
        .sheet(isPresented: $showImagePicker) {
            ImagePicker(sourceType: .photoLibrary, selectedImage: $selectedImage)
                .onChange(of: selectedImage) { newImage in
                    if let image = newImage {
                        addImageToPhotos(image: image)
                    }
                }
        }
    }
    
    // 加載圖片：如果本地有緩存則加載本地，否則下載
    func loadImage(photoURL: String, index: Int) -> some View {
        if let localImage = PhotoUtility.loadImageFromLocalStorage(named: photoURL) {
            return Image(uiImage: localImage)
                .resizable()
                .frame(width: 100, height: 133)
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .overlay(removePhotoButton(photoURL: photoURL), alignment: .topTrailing) // 對齊至右上角
                .eraseToAnyView()
        } else {
            return AsyncImage(url: URL(string: photoURL)) { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .frame(width: 100, height: 133)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                        .onAppear {
                            // 將 Image 轉換為 UIImage 並保存
                            if let uiImage = image.asUIImage() {
                                PhotoUtility.saveImageToLocalStorage(image: uiImage, withName: photoURL)
                            }
                        }
                case .failure:
                    PlaceholderView(index: index, showImagePicker: $showImagePicker)
                @unknown default:
                    EmptyView()
                }
            }
            .overlay(removePhotoButton(photoURL: photoURL), alignment: .topTrailing) // 對齊至右上角
            .eraseToAnyView()
        }
    }
    
    // 移除照片按鈕
    func removePhotoButton(photoURL: String) -> some View {
        Button(action: {
            print("Attempting to remove photo: \(photoURL)")
            removePhoto(photo: photoURL)
            deletedPhotos.append(photoURL) // 將刪除的照片 URL 加入到 deletedPhotos 中
            print("Photo \(photoURL) added to deletedPhotos.")
        }) {
            Image(systemName: "xmark.circle.fill")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 30, height: 30) // 這裡可以調整你想要的大小
                .foregroundColor(.white)
                .background(Color.red)
                .clipShape(Circle())
        }
        .offset(x: 5, y: -5)
    }
    
    // 添加圖片到照片列表
    func addImageToPhotos(image: UIImage) {
        let imageName = UUID().uuidString
        PhotoUtility.saveImageToLocalStorage(image: image, withName: imageName)
        photos.append(imageName)
        userSettings.loadedPhotosString = photos.joined(separator: ",")
        // 埋點：記錄照片新增事件，傳入照片名稱或ID
        AnalyticsManager.shared.trackEvent("photo_added", parameters: ["photo_name": imageName])
    }
    
    // 移除照片的函數
    func removePhoto(photo: String) {
        if let index = photos.firstIndex(of: photo) {
            photos.remove(at: index)
            userSettings.loadedPhotosString = photos.joined(separator: ",") // 更新已加載的照片
            // 埋點：記錄照片移除事件
            AnalyticsManager.shared.trackEvent("photo_removed", parameters: ["photo_name": photo])
        }
    }
}

extension View {
    func eraseToAnyView() -> AnyView {
        return AnyView(self)
    }
    
    func asUIImage() -> UIImage? {
        let controller = UIHostingController(rootView: self)
        let view = controller.view

        let targetSize = controller.view.intrinsicContentSize
        let size = CGSize(width: targetSize.width, height: targetSize.height)

        let format = UIGraphicsImageRendererFormat()
        format.scale = UIScreen.main.scale
        let renderer = UIGraphicsImageRenderer(size: size, format: format)

        return renderer.image { _ in
            view?.drawHierarchy(in: view!.bounds, afterScreenUpdates: true)
        }
    }
}

// View to display an image from URL
struct PhotoView: View {
    var photoURL: URL?

    var body: some View {
        if let url = photoURL {
            AsyncImage(url: url) { phase in
                switch phase {
                case .empty:
                    ProgressView() // Loading indicator
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    Image(systemName: "exclamationmark.triangle")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .foregroundColor(.gray)
                @unknown default:
                    EmptyView() // Provide an explicit view for @unknown default case
                }
            }
            .frame(width: 100, height: 133) // Ensure the frame is set for AsyncImage
        } else {
            Color.gray.opacity(0.2)
                .frame(width: 100, height: 133) // Ensure consistent sizing
        }
    }
}

// 占位符號的View
struct PlaceholderView: View {
    var index: Int // 傳遞進來的參數，表示第幾張占位符號
    @Binding var showImagePicker: Bool // 新增 showImagePicker binding

    var body: some View {
        VStack {
            switch index {
            case 5:
                // 當 index 等於 5 時顯示 book.fill 和 "生活"
                Image(systemName: "book.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                Text("生活")
                    .font(.caption)
                    .foregroundColor(.gray)
            case 4:
                // 當 index 等於 4 時顯示 pet 和 "寵物"
                Image(systemName: "pawprint.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                Text("寵物")
                    .font(.caption)
                    .foregroundColor(.gray)
            case 3:
                // 當 index 等於 3 時顯示 "旅行"
                Image(systemName: "airplane")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                Text("旅行")
                    .font(.caption)
                    .foregroundColor(.gray)
            case 2:
                // 當 index 等於 2 時顯示 "運動"
                Image(systemName: "sportscourt.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                Text("運動")
                    .font(.caption)
                    .foregroundColor(.gray)
            case 1:
                // 當 index 等於 1 時顯示 "自拍"
                Image(systemName: "camera.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                Text("自拍")
                    .font(.caption)
                    .foregroundColor(.gray)
            default:
                // 否則顯示空白占位符
                Image(systemName: "photo.fill")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                Text("占位符 \(index)")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 100, height: 133)
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
        .onTapGesture {
            // 點擊時顯示相簿
            showImagePicker = true
        }
    }
}

// PreviewProvider for PhotoSectionView
struct PhotoSectionView_Previews: PreviewProvider {
    @State static var samplePhotos = [
        "photo1", "photo2", "photo3", "photo4", "photo5", "photo6"
    ] // Example photo names (replace with actual image names)
    
    @State static var sampleDeletedPhotos = [String]() // Add a sample deletedPhotos array

    static var previews: some View {
        PhotoSectionView(photos: $samplePhotos, deletedPhotos: $sampleDeletedPhotos) // Pass deletedPhotos
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray.opacity(0.1))
    }
}
