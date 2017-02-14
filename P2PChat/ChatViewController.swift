//
//  ChatViewController.swift
//  P2PChat
//
//  Created by mnapolit on 2/13/17.
//  Copyright © 2017 micmoo. All rights reserved.
//

import Foundation
import Cocoa
import MultipeerConnectivity
class ChatViewController: NSViewController, ChatManagerDelegate,MCBrowserViewControllerDelegate{
    @IBOutlet var chatView: NSTextView!
    @IBOutlet var connectionView: NSView!
    @IBOutlet var innerChatBox: NSTextView!
    @IBOutlet var userTextBox: NSTextField!
    
    func fromString(_ from: String, color: NSColor = NSColor.black) -> NSAttributedString{
        var attr = NSMutableAttributedString(string: "\(from):  ")
        let size = from.characters.count + 3
        attr.addAttribute(NSForegroundColorAttributeName, value: color, range: NSRange(location: 0, length: size))
        attr.applyFontTraits(NSFontTraitMask.boldFontMask, range: NSRange(location: 0, length: size))
        return attr
    }
    
    @IBAction func send(sender: AnyObject) {
        let del: AppDelegate = NSApplication.shared().delegate! as! AppDelegate
        let cm = del.chatManager()
        DispatchQueue.main.async {
            self.chatView.textStorage?.append(self.fromString(cm.peerID.displayName))
            let attr = NSAttributedString(string: "\(self.userTextBox.stringValue)\n")
            self.chatView.textStorage?.append(attr)
            self.setParagraphStyleAndScroll()
            cm.sendToAll(string: self.userTextBox.stringValue)
            self.userTextBox.stringValue = ""
        }
    }
    
    func setParagraphStyleAndScroll() {
        var mutattr  = self.chatView.attributedString().mutableCopy() as! NSMutableAttributedString
        let style = NSMutableParagraphStyle()
        let len = self.chatView.string!.characters.count
        style.lineSpacing = 5.00
        mutattr.addAttribute(NSParagraphStyleAttributeName, value: style, range: NSMakeRange(0, len))
        self.chatView.textStorage?.setAttributedString(mutattr)
        self.chatView.scrollRangeToVisible(NSMakeRange(len,0))


    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        let del: AppDelegate = NSApplication.shared().delegate! as! AppDelegate
        del.chatManager().delegate = self
        del.chatManager().browser.delegate = self
        var subView = del.chatManager().browser.view
        subView.isHidden = false

        for v in subView.subviews {
            if !(v is NSScrollView) {
                v.isHidden = true
            } else {
                var sv = v as! NSScrollView
                sv.frame = connectionView.frame
            }
        }
        subView.frame = connectionView.frame
        subView.display()


        self.connectionView.addSubview(subView)
    }
    
    func browserViewControllerDidFinish(_ browserViewController: MCBrowserViewController) {
       // self.dismissViewController(getBrowser() as NSViewController)
    }
    
    func browserViewControllerWasCancelled(_ browserViewController: MCBrowserViewController) {
       // self.dismissViewController(getBrowser() as NSViewController)
    }

    
    @IBAction func textFieldAction(sender: NSTextField) {
        self.send(sender: sender)
    }
    

    
    func chatManager(_ cm: ChatManager, didReceive data: Data, fromPeer peer: String){
        DispatchQueue.main.async {
            var s = String(data: data, encoding: .utf8)
            if s == nil {
                print("Bad Data???")
                return
            }
            self.chatView.textStorage?.append(self.fromString(peer, color: NSColor.red))
            let attr = NSAttributedString(string: "\(s!)\n")
            self.chatView.textStorage?.append(attr)
            self.setParagraphStyleAndScroll()
        }
    }
}
