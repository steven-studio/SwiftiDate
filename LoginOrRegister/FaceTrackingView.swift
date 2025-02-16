//
//  FaceTrackingView.swift
//  Test
//
//  Created by 游哲維 on 2025/2/16.
//

import Foundation
import SwiftUI
import ARKit
import RealityKit
import AVFoundation   // 為了使用 AVAssetWriter, AVAssetWriterInput 等

enum TurnDirection {
    case left
    case right
}

struct FaceTrackingView: UIViewControllerRepresentable {
    @Binding var isVerified: Bool  // ✅ 用來通知驗證成功
    @Binding var message: String   // ✅ 用來顯示指示（向左轉、向右轉）

    func makeUIViewController(context: Context) -> FaceTrackingViewController {
        return FaceTrackingViewController(isVerified: $isVerified, message: $message)
    }

    func updateUIViewController(_ uiViewController: FaceTrackingViewController, context: Context) {}
}

class FaceTrackingViewController: UIViewController, ARSessionDelegate, AVCaptureVideoDataOutputSampleBufferDelegate {
    var arView = ARView(frame: .zero)
    var captureSession: AVCaptureSession!
    var videoOutput: AVCaptureVideoDataOutput!
    
    @Binding var isVerified: Bool
    @Binding var message: String
    
    // 用來記錄下一個指令要用戶轉哪邊
    var nextDirection: TurnDirection = Bool.random() ? .left : .right
    
    // 轉頭檢測控制
    var count: Int = 0
    var canDetectRightTurn = true
    var canDetectLeftTurn = true
    
    // MARK: - Video Writing Properties
    var assetWriter: AVAssetWriter?
    var writerInput: AVAssetWriterInput?
    var adaptor: AVAssetWriterInputPixelBufferAdaptor?
    var isRecording = false
    var currentFrameCount: Int64 = 0  // 用來計算影片時間

    init(isVerified: Binding<Bool>, message: Binding<String>) {
        self._isVerified = isVerified
        self._message = message
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupARSession()
        
        // 如果想立即開始錄製，就在這裡設定
        setupVideoWriter()
        startRecording()
    }

    /// 設定 ARKit 臉部追蹤
    func setupARSession() {
        guard ARFaceTrackingConfiguration.isSupported else {
            message = "⚠️ 此設備不支援臉部追蹤"
            return
        }

        let configuration = ARFaceTrackingConfiguration()
        arView.session.delegate = self
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        arView.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(arView)
        NSLayoutConstraint.activate([
            arView.topAnchor.constraint(equalTo: view.topAnchor),
            arView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            arView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            arView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])
    }

    /// 每當 ARKit 更新 anchors 時，就會呼叫這裡，可用來判斷頭部旋轉
    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let faceAnchor = anchors.first as? ARFaceAnchor else { return }

        let yaw = faceAnchor.transform.columns.2.x // 頭部水平旋轉角度
        DispatchQueue.main.async {
            switch self.nextDirection {
            case .right:
                // 指示用戶向右轉
                if yaw > 0.4 && self.canDetectRightTurn {
                    // 完成一次右轉
                    self.canDetectRightTurn = false
                    
                    if self.count == 1 {
                        self.message = "✅ 向右轉成功！驗證完成"
                        self.isVerified = true
                        self.stopRecordingIfNeeded()
                    } else {
                        // 尚未到達最後一次轉頭
                        self.nextDirection = Bool.random() ? .left : .right
                        if self.nextDirection == .left {
                            self.message = "✅ 向右轉成功！接下來請向左轉"
                            self.count += 1
                        } else {
                            self.message = "✅ 向右轉成功！接下來請向右轉"
                            self.count += 1
                        }
                    }
                    // 接下來若想要用戶轉左，就把 nextDirection 改成 .left
                } else {
                    // 只有當 abs(yaw) < 0.1，才允許再偵測下一次右轉
                    if abs(yaw) < 0.1 {
                        self.canDetectRightTurn = true
                    }
                    if self.count == 0 {
                        self.message = "請先向右轉"
                    }
                }
                
            case .left:
                // 指示用戶向左轉
                
                if yaw < -0.4 && self.canDetectLeftTurn {
                    self.canDetectLeftTurn = false
                    
                    if self.count == 1 {
                        self.message = "✅ 向左轉成功！驗證完成"
                        self.isVerified = true
                        self.stopRecordingIfNeeded()
                    } else {
                        // 尚未到達最後一次轉頭
                        self.nextDirection = Bool.random() ? .left : .right
                        if self.nextDirection == .left {
                            self.message = "✅ 向左轉成功！接下來請向左轉"
                            self.count += 1
                        } else {
                            self.message = "✅ 向左轉成功！接下來請向右轉"
                            self.count += 1
                        }
                    }
                } else {
                    // 只有當 abs(yaw) > -0.1，才允許再偵測下一次左轉
                    if abs(yaw) > -0.1 {
                        self.canDetectLeftTurn = true
                    }
                    if self.count == 0 {
                        self.message = "請先向左轉"
                    }
                }
            }
        }
    }
    
    /// **關鍵：** 每幀影像更新都會進到這裡，可用來上傳到後端
    func session(_ session: ARSession, didUpdate frame: ARFrame) {
        // 這就是 ARKit 從前鏡頭抓到的當前影像 (CVPixelBuffer)
        let pixelBuffer = frame.capturedImage
        // 1. 寫到 mp4 (如果正在錄影)
        appendPixelBufferToWriter(pixelBuffer, timestamp: frame.timestamp)
        // 轉成 JPEG
//        if let imageData = convertPixelBufferToJPEG(pixelBuffer) {
//            // 上傳到後端
//            sendImageToServer(imageData: imageData)
//        }
    }

    /// 將 ARKit 的 CVPixelBuffer 轉成 JPEG Data
    func convertPixelBufferToJPEG(_ pixelBuffer: CVPixelBuffer) -> Data? {
        let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
        let context = CIContext()
        guard let cgImage = context.createCGImage(ciImage, from: ciImage.extent) else { return nil }

        let uiImage = UIImage(cgImage: cgImage)
        return uiImage.jpegData(compressionQuality: 0.5)
    }

    /// 將 JPEG Data 上傳至後端
    func sendImageToServer(imageData: Data) {
        // 這裡只是示範用
        let url = URL(string: "https://your-api.com/upload-face")!
        var request = URLRequest(url: url)
        request.httpMethod = "POST"

        let boundary = UUID().uuidString
        request.setValue("multipart/form-data; boundary=\(boundary)", forHTTPHeaderField: "Content-Type")

        var body = Data()
        body.append("--\(boundary)\r\n".data(using: .utf8)!)
        body.append("Content-Disposition: form-data; name=\"file\"; filename=\"face.jpg\"\r\n".data(using: .utf8)!)
        body.append("Content-Type: image/jpeg\r\n\r\n".data(using: .utf8)!)
        body.append(imageData)
        body.append("\r\n--\(boundary)--\r\n".data(using: .utf8)!)

        request.httpBody = body

        URLSession.shared.dataTask(with: request) { data, response, error in
            if let error = error {
//                print("❌ 影像傳輸失敗: \(error.localizedDescription)")
            } else {
//                print("✅ 影像成功傳輸到後端！")
            }
        }.resume()
    }
}

// MARK: - MP4 錄影相關邏輯 (AVAssetWriter)
extension FaceTrackingViewController {

    /// 設定 AVAssetWriter、AVAssetWriterInput、PixelBufferAdaptor
    func setupVideoWriter() {
        // 1. 設定輸出檔案路徑（這裡放暫存目錄）
        let outputURL = FileManager.default.temporaryDirectory.appendingPathComponent("faceVideo.mp4")
        // 若已存在同名檔案，先刪掉
        try? FileManager.default.removeItem(at: outputURL)

        do {
            assetWriter = try AVAssetWriter(outputURL: outputURL, fileType: .mp4)
        } catch {
            print("❌ 無法建立 AVAssetWriter: \(error)")
            return
        }

        // 2. 設定影像輸出參數 (H.264, 640x480 只是一個示例)
        let videoSettings: [String: Any] = [
            AVVideoCodecKey: AVVideoCodecType.h264,
            AVVideoWidthKey: 640,
            AVVideoHeightKey: 480
        ]
        writerInput = AVAssetWriterInput(mediaType: .video, outputSettings: videoSettings)
        writerInput?.expectsMediaDataInRealTime = true

        // 3. 建立 PixelBuffer Adaptor (假設 32BGRA)
        adaptor = AVAssetWriterInputPixelBufferAdaptor(
            assetWriterInput: writerInput!,
            sourcePixelBufferAttributes: [
                kCVPixelBufferPixelFormatTypeKey as String: kCVPixelFormatType_32BGRA
            ]
        )

        // 4. 加入到 writer
        if let writer = assetWriter, let input = writerInput, writer.canAdd(input) {
            writer.add(input)
        }
    }

    /// 開始錄製
    func startRecording() {
        guard let writer = assetWriter else { return }
        // 開始寫
        writer.startWriting()
        writer.startSession(atSourceTime: .zero)
        currentFrameCount = 0
        isRecording = true
        print("🎬 開始錄影: \(writer.outputURL)")
    }

    /// 停止錄製
    func stopRecordingIfNeeded() {
        guard isVerified, isRecording else { return } // 若已驗證或正在錄影才停止
        stopRecording()
    }

    func stopRecording() {
        guard isRecording else { return }
        isRecording = false

        writerInput?.markAsFinished()
        assetWriter?.finishWriting { [weak self] in
            if let writer = self?.assetWriter {
                print("✅ 錄影完成，檔案位置: \(writer.outputURL)")
            }
        }
    }

    /// 將 ARKit 每幀的 pixelBuffer 寫入 .mp4
    func appendPixelBufferToWriter(_ pixelBuffer: CVPixelBuffer, timestamp: TimeInterval) {
        guard isRecording,
              let writer = assetWriter,
              let input = writerInput,
              let adaptor = adaptor else { return }

        // 檢查是否可以寫
        if input.isReadyForMoreMediaData {
            // 轉成 .bgra
            var tempBuffer: CVPixelBuffer? = nil
            let status = CVPixelBufferCreate(nil,
                                             CVPixelBufferGetWidth(pixelBuffer),
                                             CVPixelBufferGetHeight(pixelBuffer),
                                             kCVPixelFormatType_32BGRA,
                                             nil,
                                             &tempBuffer)
            if status == kCVReturnSuccess, let dstBuffer = tempBuffer {
                // 將 pixelBuffer (可能是 IR 格式) 轉成 BGRA
                // 這裡用一個簡單 CIContext 轉換
                let ciImage = CIImage(cvPixelBuffer: pixelBuffer)
                let context = CIContext()
                context.render(ciImage, to: dstBuffer)

                // 計算當前幀的 presentationTime
                // 用 timestamp 當秒數, timescale=600 只是範例
                let frameTime = CMTimeMakeWithSeconds(timestamp, preferredTimescale: 600)

                // append
                adaptor.append(dstBuffer, withPresentationTime: frameTime)
                currentFrameCount += 1
            }
        }
    }
}
