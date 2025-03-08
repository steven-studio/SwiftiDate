//
//  WebRTCManager.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/11.
//

import Foundation
import WebRTC
import AVFoundation

class WebRTCManager: ObservableObject {
    // Video Renderer
    @Published var remoteRenderer: RTCVideoRenderer?
    @Published var localRenderer: RTCVideoRenderer?
    
    private var peerConnection: RTCPeerConnection?
    private var factory: RTCPeerConnectionFactory
    
    // 新增 AVAudioRecorder 屬性
    private var audioRecorder: AVAudioRecorder?
    
    init() {
        // 初始化 WebRTC
        RTCInitializeSSL()
        let encoderFactory = RTCDefaultVideoEncoderFactory()
        let decoderFactory = RTCDefaultVideoDecoderFactory()
        factory = RTCPeerConnectionFactory(encoderFactory: encoderFactory, decoderFactory: decoderFactory)
        
        // 或初始化 localRenderer, remoteRenderer
        self.localRenderer = RTCMTLVideoView(frame: .zero)
        self.remoteRenderer = RTCMTLVideoView(frame: .zero)
        
        // 初始化並設定錄音器
        setupAudioRecorder()
    }
    
    private func setupAudioRecorder() {
        let session = AVAudioSession.sharedInstance()
        do {
            // 設定錄音類型
            try session.setCategory(.record, mode: .default, options: [])
            try session.setActive(true)
        } catch {
            print("AVAudioSession 設定失敗: \(error)")
        }
        
        // 錄音設定
        let settings: [String: Any] = [
            AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
            AVSampleRateKey: 44100,
            AVNumberOfChannelsKey: 1,
            AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
        ]
        
        // 儲存路徑：儲存在 Documents 目錄下
        let fileName = getUniqueRecordingFileName()
        let fileURL = getDocumentsDirectory().appendingPathComponent(fileName)
        
        do {
            audioRecorder = try AVAudioRecorder(url: fileURL, settings: settings)
            audioRecorder?.prepareToRecord()
        } catch {
            print("初始化 AVAudioRecorder 失敗: \(error)")
        }
    }
    
    private func getUniqueRecordingFileName() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyyMMdd_HHmmss"
        let dateString = formatter.string(from: Date())
        return "webrtc_audio_recording_\(dateString).m4a"
    }
    
    private func getDocumentsDirectory() -> URL {
        FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
    }
    
    func startCall() {
        // 在這裡做： create PeerConnection, add local media track, create offer, etc.
        // 也可能需要 signaling
        print("startCall triggered")
    }
    
    func hangup() {
        // 結束通話
        peerConnection?.close()
        peerConnection = nil
        print("hangup call")
    }
}
