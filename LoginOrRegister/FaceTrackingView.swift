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

class FaceTrackingViewController: UIViewController, ARSessionDelegate {
    var arView = ARView(frame: .zero)
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
