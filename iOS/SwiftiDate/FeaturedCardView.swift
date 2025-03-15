//
//  FeaturedCardView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/9/23.
//

import Foundation
import SwiftUI

struct FeaturedCardView: View {
    var body: some View {
        HStack {
            Image("profile_image") // Replace with your image name
                .resizable()
                .frame(width: 50, height: 50)
                .clipShape(Circle())
                .padding(.leading, 8)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text("AI每日精選")
                        .font(.headline)
                        .foregroundColor(.white)
                    Image(systemName: "star.fill")
                        .foregroundColor(.yellow)
                        .font(.system(size: 12))
                    Text("5")
                        .font(.subheadline)
                        .foregroundColor(.white)
                }
                
                Text("每天為你精心挑選5位優質用戶")
                    .font(.subheadline)
                    .foregroundColor(.white)
            }
            
            Spacer()
            
            Image(systemName: "chevron.right")
                .foregroundColor(.white)
                .padding(.trailing, 10)
        }
        .padding()
        .background(Color.yellow)
        .cornerRadius(10)
        .padding(.horizontal)
    }
}
