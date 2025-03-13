// AsyncImageView.swift
// SwiftiDate
//
// Created by 游哲維 on 2024/9/21.
//

import SwiftUI
import Combine

struct AsyncImageView: View {
    @StateObject private var loader: ImageLoader
    var placeholder: Image
    
    init(url: URL, placeholder: Image = Image(systemName: "photo")) {
        _loader = StateObject(wrappedValue: ImageLoader(url: url))
        self.placeholder = placeholder
    }
    
    var body: some View {
        if let image = loader.image {
            Image(uiImage: image)
                .resizable()
                .scaledToFill()
        } else {
            placeholder
                .resizable()
                .scaledToFill()
        }
    }
}

class ImageLoader: ObservableObject {
    @Published var image: UIImage?
    private var cancellable: AnyCancellable?

    init(url: URL) {
        load(url: url)
    }
    
    deinit {
        cancellable?.cancel()
    }
    
    private func load(url: URL) {
        cancellable = URLSession.shared.dataTaskPublisher(for: url)
            .map { UIImage(data: $0.data) }
            .replaceError(with: nil)
            .receive(on: DispatchQueue.main)
            .assign(to: \.image, on: self)
    }
}
