//
//  MessageBubbleView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/4.
//

import Foundation
import SwiftUI
import AVFoundation

var audioPlayer: AVAudioPlayer?

// Custom view for message bubbles
struct MessageBubbleView: View {
    var message: Message
    var isCurrentUser: Bool
    var showTime: Bool // Add this new parameter
    @State private var isLiked: Bool = false // State variable to track if the message is liked

    var body: some View {
        VStack {
            if showTime {
                // Display the time when `showTime` is true
                Text(message.time)
                    .font(.caption)
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center) // Center the time
            }
            
            HStack {
                if isCurrentUser {
                    Spacer()
                }
                
                switch message.content {
                case .text(let text):
                    Text(text)
                        .padding()
                        .background(isCurrentUser ? (message.isCompliment ? Color.black : Color.green) : Color.gray.opacity(0.3))
                        .foregroundColor(isCurrentUser ? .white : .black)
                        .cornerRadius(10)
                    // Add context menu for long-press options
                        .contextMenu {
                            Button(action: {
                                // Copy action
                                UIPasteboard.general.string = text
                            }) {
                                Label("拷貝", systemImage: "doc.on.doc")
                            }
                            
                            Button(action: {
                                // Like action
                                isLiked.toggle()
                                print("按讚")
                            }) {
                                Label("按讚", systemImage: "hand.thumbsup.fill")
                            }
                            
                            Button(action: {
                                // Reply action
                                print("回覆")
                            }) {
                                Label("回覆", systemImage: "arrowshape.turn.up.left.fill")
                            }
                        }
                    
                case .image(let imageData):
                    if let uiImage = UIImage(data: imageData) {
                        Image(uiImage: uiImage)
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 200, maxHeight: 200)
                            .cornerRadius(10)
                            .padding()
                            .contextMenu {
                                Button(action: {
                                    UIImageWriteToSavedPhotosAlbum(uiImage, nil, nil, nil)
                                }) {
                                    Label("保存圖片", systemImage: "square.and.arrow.down")
                                }
                            }
                    }

                case .audio(let audioPath):
                    Button(action: {
                        playAudio(from: audioPath)
                    }) {
                        HStack {
                            Image(systemName: "waveform")
                            Text("播放語音")
                        }
                    }
                    .padding()
                    .background(Color.blue.opacity(0.2))
                    .cornerRadius(10)
                }

                if !isCurrentUser {
                    // Add a heart icon for non-current users
                    Button(action: {
                        isLiked.toggle()
                    }) {
                        Image(systemName: isLiked ? "heart.fill" : "heart")
                            .resizable()  // Make the image resizable
                            .aspectRatio(contentMode: .fit)  // Maintain aspect ratio
                            .frame(width: 24, height: 24)  // Set desired width and height
                            .foregroundColor(isLiked ? .red : .gray.opacity(0.4))
                    }
                    .padding(.leading, 5)
                    
                    Spacer()
                }
            }
            .padding(isCurrentUser ? .leading : .trailing, 50)
        }
    }
    
    func playAudio(from path: String) {
        guard let url = URL(string: path) else {
            print("無效的音頻路徑")
            return
        }
        
        do {
            audioPlayer = try AVAudioPlayer(contentsOf: url)
            audioPlayer?.play()
            print("正在播放音頻")
        } catch {
            print("播放音頻失敗: \(error.localizedDescription)")
        }
    }
}
