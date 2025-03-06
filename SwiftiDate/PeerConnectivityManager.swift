//
//  PeerConnectivityManager.swift
//  SwiftiDate
//
//  Created by 游哲維 on 2025/3/5.
//

import Foundation
import MultipeerConnectivity
import SwiftUI

@objcMembers
class PeerConnectivityManager: NSObject, ObservableObject, MCSessionDelegate, MCBrowserViewControllerDelegate, MCNearbyServiceAdvertiserDelegate {
    // MCNearbyServiceAdvertiserDelegate 也需要實作
    func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didNotStartAdvertisingPeer error: Error) {
        print("[DEBUG] Failed to start advertising: \(error.localizedDescription)")
    }
    
    @objc func advertiser(_ advertiser: MCNearbyServiceAdvertiser, didReceiveInvitationFromPeer peerID: MCPeerID, withContext context: Data?, invitationHandler: @escaping (Bool, MCSession?) -> Void) {
        // 當接收到邀請時，自動接受邀請
        print("[DEBUG] Received invitation from \(peerID.displayName)")
        invitationHandler(true, self.session)
    }
    
    private let serviceType = "app-download"
    private let peerID = MCPeerID(displayName: UIDevice.current.name)
    private var session: MCSession!
    private var advertiser: MCNearbyServiceAdvertiser!
    @Published var receivedURL: URL?
    
    override init() {
        super.init()
        session = MCSession(peer: peerID, securityIdentity: nil, encryptionPreference: .required)
        session.delegate = self
        
        advertiser = MCNearbyServiceAdvertiser(peer: peerID, discoveryInfo: nil, serviceType: serviceType)
        advertiser.delegate = self
        advertiser.startAdvertisingPeer()
    }
    
    // 发送数据
    func sendDownloadLink(_ url: URL) {
        guard !session.connectedPeers.isEmpty else { return }
        if let data = url.absoluteString.data(using: .utf8) {
            do {
                try session.send(data, toPeers: session.connectedPeers, with: .reliable)
            } catch {
                print("Failed to send link: \(error.localizedDescription)")
            }
        }
    }
    
    // MARK: - MCSessionDelegate methods
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        DispatchQueue.main.async {
            print("[DEBUG] Peer \(peerID.displayName) changed state: \(state.rawValue)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        if let urlString = String(data: data, encoding: .utf8),
           let url = URL(string: urlString) {
            DispatchQueue.main.async {
                print("[DEBUG] Received download link from \(peerID.displayName): \(urlString)")
                self.receivedURL = url
            }
        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        // 這裡我們不處理 stream
        print("[DEBUG] Did receive stream '\(streamName)' from \(peerID.displayName)")
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        // 這裡我們不處理資源接收
        print("[DEBUG] Started receiving resource '\(resourceName)' from \(peerID.displayName)")
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL?, withError error: Error?) {
        // 這裡我們不處理資源接收完成
        if let error = error {
            print("[DEBUG] Failed to receive resource '\(resourceName)' from \(peerID.displayName): \(error.localizedDescription)")
        } else {
            print("[DEBUG] Finished receiving resource '\(resourceName)' from \(peerID.displayName)")
        }
    }

    // MARK: - MCBrowserViewControllerDelegate methods
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
        // 當瀏覽器完成後，關閉它
        browserViewController.dismiss(animated: true)
        print("[DEBUG] Browser view controller did finish")
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
        // 當使用者取消瀏覽器後，關閉它
        browserViewController.dismiss(animated: true)
        print("[DEBUG] Browser view controller was cancelled")
    }
}

// SwiftUI View 示例
struct DownloadLinkView: View {
    @StateObject var connectivityManager = PeerConnectivityManager()
    
    var body: some View {
        VStack {
            if let url = connectivityManager.receivedURL {
                Text("收到下載連結: \(url.absoluteString)")
                Button("打開連結") {
                    UIApplication.shared.open(url)
                }
            } else {
                Text("等待接收下載連結...")
            }
        }
    }
}
