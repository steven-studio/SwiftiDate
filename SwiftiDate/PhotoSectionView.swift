//
//  PhotoSectionView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/8/18.
//

import Foundation
import SwiftUI
import FirebaseStorage

enum PhotoState {
    case empty
    case loading
    case success(UIImage)
    case failure
}

struct PhotoSectionView: View {
    @AppStorage("loadedPhotos") var loadedPhotosString: String = "" // 使用字符串保存照片 URL
    @Binding var photos: [String] // Change to @Binding
    @State private var showImagePicker = false // 控制顯示照片選擇器
    @State private var selectedImage: UIImage? // 保存選中的圖片
    
    var body: some View {
        VStack {
            // 上排照片
            HStack(spacing: 10) {
                ForEach(Array(photos.prefix(3).enumerated()), id: \.element) { index, photo in
                    loadImage(photoURL: photo, index: index)
                }
            }

            // 下排照片
            HStack(spacing: 10) {
                let bottomPhotos = photos.suffix(min(max(photos.count - 3, 0), 3))
                ForEach(Array(bottomPhotos.enumerated()), id: \.element) { index, photo in
                    loadImage(photoURL: photo, index: index + 3)
                }
            }
        }
        .onAppear {
            loadPhotosFromAppStorage()
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
        if let localImage = loadImageFromLocalStorage(named: photoURL) {
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
                                saveImageToLocalStorage(image: uiImage, withName: photoURL)
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
            removePhoto(photo: photoURL)
        }) {
            Image(systemName: "xmark.circle.fill")
                .foregroundColor(.white)
                .background(Color.red)
                .clipShape(Circle())
        }
        .offset(x: -5, y: -5)
    }
    
    // 加載已保存的照片 URL 列表
    func loadPhotosFromAppStorage() {
        if !loadedPhotosString.isEmpty {
            print("Loaded cached photos from AppStorage: \(loadedPhotosString)")
            photos = loadedPhotosString.components(separatedBy: ",")
        } else {
            fetchPhotosFromFirebase()
        }
    }
    
    func loadPhotos() {
        if !loadedPhotosString.isEmpty {
            print("Loaded cached photos from AppStorage: \(loadedPhotosString)")
            photos = loadedPhotosString.components(separatedBy: ",") // 將字符串轉換回數組
        } else {
            print("No cached photos found in AppStorage, fetching from Firebase.")
            fetchPhotosFromFirebase() // 如果沒有已加載的照片，則加載
        }
    }
    
    // Button to add photos
    func AddPhotoButton() -> some View {
        Button(action: {
            showImagePicker = true
        }) {
            VStack {
                Image(systemName: "plus.circle")
                    .resizable()
                    .frame(width: 50, height: 50)
                    .foregroundColor(.gray)
                Text("添加照片")
                    .font(.caption)
                    .foregroundColor(.gray)
            }
        }
        .frame(width: 100, height: 133)
        .background(Color.gray.opacity(0.2))
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
    
    // Fetch photos from Firebase Storage
    func fetchPhotosFromFirebase() {
        print("Fetching photos from Firebase started")
        photos.removeAll() // Clear existing photos before fetching
        
        let storage = Storage.storage()
        let userID = globalUserID // Replace this with the current user ID
        let storageRef = storage.reference().child("user_photos/\(userID)")
        
        storageRef.listAll { (result, error) in
            if let error = error {
                print("Error fetching photos: \(error)")
                return
            }
            
            // Safely unwrap the result
            guard let result = result else {
                print("Failed to fetch the result")
                return
            }
            
            var fetchedPhotoURLs: [(url: String, photoNumber: Int)] = []
            
            for item in result.items {
                item.downloadURL { (url, error) in
                    if let error = error {
                        print("Error getting download URL: \(error)")
                        return
                    }
                    
                    if let url = url {
                        let urlString = url.absoluteString
                        
                        // Extract the number from the photo name
                        if let photoNumber = extractPhotoNumber(from: urlString) {
                            fetchedPhotoURLs.append((urlString, photoNumber))
                        }
                        
                        // Once all URLs are fetched, sort by photo number
                        if fetchedPhotoURLs.count == result.items.count {
                            fetchedPhotoURLs.sort { $0.photoNumber < $1.photoNumber }
                            DispatchQueue.main.async {
                                self.photos = fetchedPhotoURLs.map { $0.url }
                                self.loadedPhotosString = self.photos.joined(separator: ",") // 將數組轉換為字符串存儲
                                print("Sorted photo URLs: \(self.photos)")
                            }
                        }
                    }
                }
            }
        }
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
    
    // 添加圖片到照片列表
    func addImageToPhotos(image: UIImage) {
        let imageName = UUID().uuidString
        saveImageToLocalStorage(image: image, withName: imageName)
        photos.append(imageName)
        loadedPhotosString = photos.joined(separator: ",")
    }
    
    // 儲存圖片到本地
    func saveImageToLocalStorage(image: UIImage, withName imageName: String) {
        if let data = image.jpegData(compressionQuality: 0.8) {
            let url = getDocumentsDirectory().appendingPathComponent(imageName)
            try? data.write(to: url)
            print("Image saved to local storage at \(url.path)")
        }
    }

    // 從本地加載圖片
    func loadImageFromLocalStorage(named imageName: String) -> UIImage? {
        let url = getDocumentsDirectory().appendingPathComponent(imageName)
        if let data = try? Data(contentsOf: url) {
            return UIImage(data: data)
        }
        return nil
    }
    
    // 移除本地圖片
    func deleteImageFromLocalStorage(named imageName: String) {
        let url = getDocumentsDirectory().appendingPathComponent(imageName)
        try? FileManager.default.removeItem(at: url)
    }
    
    // 獲取文件目錄
    func getDocumentsDirectory() -> URL {
        return FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    // 移除照片的函數
    func removePhoto(photo: String) {
        if let index = photos.firstIndex(of: photo) {
            photos.remove(at: index)
            loadedPhotosString = photos.joined(separator: ",") // 更新已加載的照片
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

// ImagePicker: 用於選擇照片
struct ImagePicker: UIViewControllerRepresentable {
    var sourceType: UIImagePickerController.SourceType
    @Binding var selectedImage: UIImage?

    func makeUIViewController(context: Context) -> UIImagePickerController {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = sourceType
        imagePicker.delegate = context.coordinator
        return imagePicker
    }

    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker

        init(_ parent: ImagePicker) {
            self.parent = parent
        }

        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            picker.dismiss(animated: true)
        }

        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            picker.dismiss(animated: true)
        }
    }
}

// PreviewProvider for PhotoSectionView
struct PhotoSectionView_Previews: PreviewProvider {
    @State static var samplePhotos = [
        "photo1", "photo2", "photo3", "photo4", "photo5", "photo6"
    ] // Example photo names (replace with actual image names)

    static var previews: some View {
        PhotoSectionView(photos: $samplePhotos)
            .previewLayout(.sizeThatFits)
            .padding()
            .background(Color.gray.opacity(0.1))
    }
}
