//
//  ProfileImageView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/17.
//

import Foundation
import SwiftUI

struct ProfileImageView: View {
    var photoName: String?
    var frameWidth: CGFloat = 100
    var frameHeight: CGFloat = 133

    var body: some View {
        ZStack {
            if let photoName = photoName, let image = PhotoUtility.loadImageFromLocalStorage(named: photoName) {
                Image(uiImage: image)
                    .resizable()
                    .frame(width: frameWidth, height: frameHeight)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
            } else {
                // Default placeholder image
                Image(systemName: "person.crop.circle.fill")
                    .resizable()
                    .frame(width: frameWidth, height: frameHeight)
                    .foregroundColor(.gray)
                    .clipShape(Circle())
                    .overlay(Circle().stroke(Color.white, lineWidth: 4))
                    .shadow(radius: 10)
            }
        }
    }
}
