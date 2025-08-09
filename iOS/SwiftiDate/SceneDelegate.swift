//
//  SceneDelegate.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/8/8.
//

import UIKit
import FirebaseAuth

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    func scene(_ scene: UIScene,
               openURLContexts URLContexts: Set<UIOpenURLContext>) {
        guard let url = URLContexts.first?.url else { return }
        if Auth.auth().canHandle(url) { return } // 交給 FirebaseAuth 處理
        // 其它自訂的 URL 邏輯…
    }
}
