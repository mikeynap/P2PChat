//
//  AppDelegate.swift
//  P2PChat
//
//  Created by Mike Napolitano on 2/13/17.
//  Copyright © 2017 Mike Napolitano (micmoo.com). All rights reserved.
//  Icon made by http://www.flaticon.com/authors/roundicons from http://www.flaticon.com. 
//  Icon Licensed by http://creativecommons.org/licenses/by/3.0/ CC 3.0 BY
//  This project and all code contained is licensed under the MIT License. Go Nuts. 
//  Also, this code is trash, I would not use it. The way I hacked the Connection Browser
//  Stuff is enough to give anyone nightmares.

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
            let id = Host.current().localizedName ?? "iHasNoHostName"
            self._chatManager = ChatManager(id: id)
            self._chatManager?.advertiseMe()
        }
        return _chatManager!
    }


}

