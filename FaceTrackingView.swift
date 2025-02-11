//
//  FaceTrackingView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/2/3.
//

import Foundation
import SwiftUI
import ARKit
import RealityKit

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

    init(isVerified: Binding<Bool>, message: Binding<String>) {
        self._isVerified = isVerified
        self._message = message
        super.init(nibName: nil, bundle: nil)
    }

    required init?(coder: NSCoder) { fatalError("init(coder:) has not been implemented") }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupARSession()
        setupCameraSession() // ✅ 啟動相機串流
    }

    func setupARSession() {
        guard ARFaceTrackingConfiguration.isSupported else {
            message = "⚠️ 此設備不支援臉部追蹤"
            return
        }

        let configuration = ARFaceTrackingConfiguration()
        arView.session.delegate = self
        arView.session.run(configuration, options: [.resetTracking, .removeExistingAnchors])
        view.addSubview(arView)
    }
    
    func setupCameraSession() {
        captureSession = AVCaptureSession()
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front),
              let videoInput = try? AVCaptureDeviceInput(device: videoDevice) else {
            print("❌ 無法找到前鏡頭")
            return
        }

        captureSession.addInput(videoInput)

        videoOutput = AVCaptureVideoDataOutput()
        videoOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "videoQueue"))
        captureSession.addOutput(videoOutput)

        captureSession.startRunning()
    }
    
    // ✅ 這裡會每幀收到相機影像
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        if let imageData = convertSampleBufferToJPEG(sampleBuffer) {
            sendImageToServer(imageData: imageData) // ✅ 傳到後端
        }
    }
    
    func convertSampleBufferToJPEG(_ sampleBuffer: CMSampleBuffer) -> Data? {
        guard let imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else { return nil }
        let ciImage = CIImage(cvImageBuffer: imageBuffer)
        let context = CIContext()
        if let cgImage = context.createCGImage(ciImage, from: ciImage.extent) {
            let uiImage = UIImage(cgImage: cgImage)
            return uiImage.jpegData(compressionQuality: 0.5) // ✅ 壓縮成 JPEG
        }
        return nil
    }

    func sendImageToServer(imageData: Data) {
        let url = URL(string: "https://your-api.com/upload-face")! // ✅ 替換為你的後端 API
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
                print("❌ 影像傳輸失敗: \(error.localizedDescription)")
            } else {
                print("✅ 影像成功傳輸到後端！")
            }
        }.resume()
    }

    func session(_ session: ARSession, didUpdate anchors: [ARAnchor]) {
        guard let faceAnchor = anchors.first as? ARFaceAnchor else { return }

        let yaw = faceAnchor.transform.columns.2.x // 頭部水平旋轉角度
        DispatchQueue.main.async {
            if yaw > 0.3 {  // 向右轉超過閾值
                self.message = "✅ 向右轉成功！請向左轉"
            } else if yaw < -0.3 {  // 向左轉超過閾值
                self.message = "✅ 向左轉成功！驗證完成"
                self.isVerified = true  // ✅ 驗證成功
            } else {
                self.message = "請依指示轉頭"
            }
        }
    }
}
