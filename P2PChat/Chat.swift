//
//  Chat.swift
//  P2PChat
//
//  Created by mnapolit on 2/13/17.
//  Copyright © 2017 micmoo. All rights reserved.
//

import Foundation
import MultipeerConnectivity

protocol ChatManagerDelegate {
    func chatManager(_ cm: ChatManager, didReceive data: Data, fromPeer peer: String)
}

class ChatManager : NSObject, MCSessionDelegate {
    var peerID: MCPeerID
    var session: MCSession
    var browser: MCBrowserViewController
    var advertiser: MCAdvertiserAssistant
    var peers: [MCPeerID] = Array()
    var delegate: ChatManagerDelegate?
    let SERVICEID: String = "chat-files"
    init(id: String){
        self.peerID = MCPeerID(displayName: id)
        self.session = MCSession(peer: self.peerID,securityIdentity: nil, encryptionPreference: MCEncryptionPreference.optional)
    
        self.browser = MCBrowserViewController(serviceType: SERVICEID, session: self.session)
        self.advertiser = MCAdvertiserAssistant(serviceType: SERVICEID, discoveryInfo: nil, session: self.session)
        super.init()
        self.session.delegate = self
        self.browser.maximumNumberOfPeers = 50
    }
    
    func sendToAll(string: String) {
        sendToAll(data: string.data(using: .utf8)!)
    }
    
    func sendToAll(data: Data){
        do {
            try self.session.send(data, toPeers: self.peers, with: MCSessionSendDataMode.reliable)
        }
        catch  {
            print("Couldn't send... \(error)")
        }
    }
    
    func session(_ session: MCSession, didReceive data: Data, fromPeer peerID: MCPeerID) {
        self.delegate?.chatManager(self, didReceive: data, fromPeer: peerID.displayName)
    }
    
    func session(_ session: MCSession, peer peerID: MCPeerID, didChange state: MCSessionState) {
        print("peerDidChangeState", peerID, state)
        if state == MCSessionState.connected {
            var replaced = false
            for i in 0 ..< self.peers.count {
                if self.peers[i].displayName == peerID.displayName {
                    self.peers[i] = peerID
                    replaced = true
                    break
                }
            }
            if !replaced {
                self.peers.append(peerID)
            }
        } else if state == MCSessionState.notConnected {
            for i in 0 ..< self.peers.count {
                if self.peers[i].displayName == peerID.displayName {
                    self.peers.remove(at: i)
                    break
                }
            }

        }
    }
    
    func session(_ session: MCSession, didReceive stream: InputStream, withName streamName: String, fromPeer peerID: MCPeerID) {
        print("didReceiveStream", stream, streamName, peerID)
        
    }
    
    func session(_ session: MCSession, didStartReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, with progress: Progress) {
        print("didStartReceiving", peerID, progress, resourceName)
    }
    
    func session(_ session: MCSession, didReceiveCertificate certificate: [Any]?, fromPeer peerID: MCPeerID, certificateHandler: @escaping (Bool) -> Void) {
        print("didReceiveCert", peerID, certificate, certificateHandler(true))
        
    }
    
    func session(_ session: MCSession, didFinishReceivingResourceWithName resourceName: String, fromPeer peerID: MCPeerID, at localURL: URL, withError error: Error?) {
        print("didFinishReceiving", error, localURL, peerID, resourceName)
        
    }
    
    func advertiseMe() {
        advertiser.start()
    }
    
}
