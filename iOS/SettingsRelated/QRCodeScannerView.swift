//
//  QRCodeScannerView.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2024/10/3.
//

import Foundation
import SwiftUI
import AVFoundation
// 加入 Firebase Functions
import FirebaseFunctions

struct QRCodeScannerView: UIViewControllerRepresentable {
    var didFindCode: (String) -> Void
    var dismissView: () -> Void // Add this to handle dismiss action
    
    class Coordinator: NSObject, AVCaptureMetadataOutputObjectsDelegate {

        private let functions = Functions.functions()
        var parent: QRCodeScannerView

        init(parent: QRCodeScannerView) {
            self.parent = parent
        }

        func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
            if let metadataObject = metadataObjects.first {
                guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }
                guard let stringValue = readableObject.stringValue else { return }

                AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))
                // 記錄掃描到 QRCode 事件
                AnalyticsManager.shared.trackEvent("QRCodeScannerView_CodeFound", parameters: ["code": stringValue])
                parent.didFindCode(stringValue)
            }
        }
        
        private func matchUsers(tokenId: String) {
            let matchFunction = functions.httpsCallable("matchUsers")
            matchFunction.call(["tokenId": tokenId]) { result, error in
                if let error = error {
                    print("matchUsers error: \(error)")
                    // 也可彈 Alert
                    return
                }
                if let data = result?.data as? [String: Any],
                   let success = data["success"] as? Bool, success {
                    print("成功 match! aUid: \(data["aUid"] ?? ""), bUid: \(data["bUid"] ?? "")")
                    
                    // 更新 UI, e.g. Toast / Alert
                    // 也可以 callback 給 parent, e.g. parent.didFindCode(tokenId)
                }
            }
        }
        
        // Function to dismiss the QRCodeScannerView when the back button is tapped
        @objc func dismissScanner() {
            AnalyticsManager.shared.trackEvent("QRCodeScannerView_Dismissed", parameters: nil)
            parent.dismissView()
        }
        
        // Function to handle the "顯示行動條碼" button action
        @objc func showBarcode() {
            AnalyticsManager.shared.trackEvent("QRCodeScannerView_ShowBarcodeTapped", parameters: nil)
            print("顯示行動條碼按鈕被點擊")
        }
    }

    func makeCoordinator() -> Coordinator {
        return Coordinator(parent: self)
    }

    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        let captureSession = AVCaptureSession()

        guard let videoCaptureDevice = AVCaptureDevice.default(for: .video) else { return viewController }
        let videoInput: AVCaptureDeviceInput

        do {
            videoInput = try AVCaptureDeviceInput(device: videoCaptureDevice)
        } catch {
            return viewController
        }

        if captureSession.canAddInput(videoInput) {
            captureSession.addInput(videoInput)
        } else {
            return viewController
        }

        let metadataOutput = AVCaptureMetadataOutput()

        if captureSession.canAddOutput(metadataOutput) {
            captureSession.addOutput(metadataOutput)

            metadataOutput.setMetadataObjectsDelegate(context.coordinator, queue: DispatchQueue.main)
            metadataOutput.metadataObjectTypes = [.qr]
        } else {
            return viewController
        }

        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = viewController.view.layer.bounds
        previewLayer.videoGravity = .resizeAspectFill
        viewController.view.layer.addSublayer(previewLayer)

        captureSession.startRunning()
        // 記錄掃描器畫面出現事件
        AnalyticsManager.shared.trackEvent("QRCodeScannerView_Appeared", parameters: nil)
        
        // Add a square frame overlay to guide the user
        let overlayView = UIView(frame: viewController.view.bounds)
        overlayView.backgroundColor = UIColor.black.withAlphaComponent(0.5)
        viewController.view.addSubview(overlayView)

        // Create a square hole in the overlay
        let scanFrame = CGRect(x: viewController.view.bounds.width * 0.2, y: viewController.view.bounds.height * 0.3, width: viewController.view.bounds.width * 0.6, height: viewController.view.bounds.width * 0.6)

        let path = UIBezierPath(rect: overlayView.bounds)
        let scanPath = UIBezierPath(rect: scanFrame)
        path.append(scanPath.reversing())

        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        overlayView.layer.mask = maskLayer
        
        // Add white border around the scanning area
        let borderLayer = CAShapeLayer()
        borderLayer.path = UIBezierPath(rect: scanFrame).cgPath
        borderLayer.strokeColor = UIColor.white.cgColor
        borderLayer.lineWidth = 2.0 // Adjust the thickness of the border here
        borderLayer.fillColor = UIColor.clear.cgColor
        viewController.view.layer.addSublayer(borderLayer)

        // Add the back button (chevron.left)
        let backButton = UIButton(type: .system)
        backButton.setImage(UIImage(systemName: "chevron.left"), for: .normal)
        backButton.tintColor = .white
        backButton.frame = CGRect(x: 20, y: 50, width: 40, height: 40) // Adjust position and size as needed
        backButton.addTarget(context.coordinator, action: #selector(Coordinator.dismissScanner), for: .touchUpInside)
        viewController.view.addSubview(backButton)
        
        // Add the "掃碼" label to the center at the top
        let titleLabel = UILabel()
        titleLabel.text = "掃碼"
        titleLabel.textColor = .white
        titleLabel.textAlignment = .center
        titleLabel.font = UIFont.systemFont(ofSize: 20, weight: .bold)
        titleLabel.frame = CGRect(x: 0, y: 50, width: viewController.view.bounds.width, height: 40) // Adjust the y-position if necessary
        viewController.view.addSubview(titleLabel)
        
        // Add instruction label above the scan frame
        let instructionLabel = UILabel()
        instructionLabel.text = "將二維碼保持在框框內"
        instructionLabel.textColor = .white
        instructionLabel.textAlignment = .center
        instructionLabel.font = UIFont.systemFont(ofSize: 16, weight: .medium)
        instructionLabel.frame = CGRect(x: 0, y: scanFrame.minY - 40, width: viewController.view.bounds.width, height: 30) // Position it just above the scan frame
        viewController.view.addSubview(instructionLabel)
        
        // Add the "顯示行動條碼" button with icon below the scan frame
        let actionButton = UIButton(type: .system)
        let imageAttachment = NSTextAttachment()

        // 將 qrcode 圖標設置為白色
        if let qrCodeImage = UIImage(systemName: "qrcode")?.withTintColor(.white, renderingMode: .alwaysOriginal) {
            imageAttachment.image = qrCodeImage
        }

        let fullString = NSMutableAttributedString()
        fullString.append(NSAttributedString(attachment: imageAttachment))
        fullString.append(NSAttributedString(string: " 顯示行動條碼"))
        
        actionButton.setAttributedTitle(fullString, for: .normal)
        actionButton.setTitleColor(.white, for: .normal)
        actionButton.backgroundColor = UIColor.black.withAlphaComponent(0.6)
        actionButton.layer.cornerRadius = 15
        actionButton.frame = CGRect(x: (viewController.view.bounds.width - 200) / 2, y: scanFrame.maxY + 20, width: 200, height: 40)
        actionButton.addTarget(context.coordinator, action: #selector(Coordinator.showBarcode), for: .touchUpInside)
        viewController.view.addSubview(actionButton)

        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {}
}
