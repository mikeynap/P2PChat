//
//  AppDelegate.swift
//  P2PChat
//
//  Created by mnapolit on 2/13/17.
//  Copyright © 2017 micmoo. All rights reserved.
//

import Cocoa
@NSApplicationMain
class AppDelegate: NSObject, NSApplicationDelegate {


    var _chatManager: ChatManager?
    func applicationDidFinishLaunching(_ aNotification: Notification) {
        print("Did Finish Launching")

        // Insert code here to initialize your application
    }

    func applicationWillTerminate(_ aNotification: Notification) {
        // Insert code here to tear down your application
    }
    
    func chatManager() -> ChatManager {
        if _chatManager == nil {
            let id = Host.current().localizedName ?? "wtfisyourhostname"
            self._chatManager = ChatManager(id: id)
            self._chatManager?.advertiseMe()
        }
        return _chatManager!
    }


}

