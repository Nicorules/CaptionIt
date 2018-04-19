//
//  Group.swift
//  CaptionIt
//
//  Created by Mukesh Muteja on 15/04/18.
//  Copyright © 2018 Tower Org. All rights reserved.
//

import UIKit
import Firebase

let errorOccured = "errorOccured"

class Group: NSObject {
  
  static let singleton = Group()
  var curPin = "0"
  var totalUser = 0
  var handle: UInt = 0
  var playersRef: DatabaseReference?
  var gameTimer: Timer!
  var users = [Any]()
  var token = ""
  var url = ""
  
  func observeAnyoneLeftGame(_ groupPin: String) {
    curPin = groupPin
    playersRef = ref.child("rooms").child(groupPin).child("players")
    handle = playersRef!.observe(.childRemoved, with: { (snapshot) in
      let allPlayers = snapshot.children
      
      if let players  = allPlayers.allObjects as? [DataSnapshot]{
        print("observer notification sent")
        self.deleteMediaForGroup()
        NotificationCenter.default.post(name: NSNotification.Name(rawValue: errorOccured), object: nil)
        self.playersRef?.removeObserver(withHandle: self.handle)
        ref.child("rooms").child(groupPin).removeValue()
      }
    })
  }
  
  func startTime() {
    gameTimer = Timer.scheduledTimer(timeInterval: 500, target: self, selector: #selector(runTimedCode), userInfo: nil, repeats: false)
  }
  
  func stopTimer() {
    gameTimer.invalidate()
  }
  
  func runTimedCode() {
    stopTimer()
    NotificationCenter.default.post(name: NSNotification.Name(rawValue: errorOccured), object: nil)
    let currentId = Auth.auth().currentUser?.uid
    ref.child("rooms").child(curPin).child("players").child(currentId!).removeValue()
  }
  
  func removeErrorObservers() {
    self.playersRef?.removeObserver(withHandle: self.handle)
    if gameTimer != nil {
      gameTimer.invalidate()
    }
  }
  
  func sendNotification(_ message: String) {
    for user in users {
      if let userDic = user as? [String : Any] {
        let id = userDic["ID"] as! String
        if id != getUserId() {
          ref.child("Users").child(id).child("token").observeSingleEvent(of: .value, with: { (snapshot) in
            if let token = snapshot.value as? String {
              PushNotificationManager.sendNotificationToDevice(deviceToken: token, gameID: self.curPin, taskMessage: message)
            }
          })
        }
      }
    }
  }
  
  func sendNotificationToJudge(_ judgeId: String, _ message: String) {
    ref.child("Users").child(judgeId).child("token").observeSingleEvent(of: .value, with: { (snapshot) in
      if let token = snapshot.value as? String {
        PushNotificationManager.sendNotificationToDevice(deviceToken: token, gameID: self.curPin, taskMessage: message)
      }
    })
  }
  
 private func firebaseDeleteMedia(_ url : String) {
    let storage = Storage.storage()
    let storageRef = storage.reference(forURL: url)
    //Removes image from storage
    storageRef.delete { error in
      if let error = error {
        print(error)
      } else {
        // File deleted successfully
        
      }
    }
  }
  
  func deleteMediaForGroup() {
    for user in users {
      if let userDic = user as? [String : Any] {
        if let url = userDic["memeURL"] as? String {
        firebaseDeleteMedia(url)
        }
      }
    }
  }
  
  func deleteCurrentUserMedia() {
    if url.count > 0 {
      firebaseDeleteMedia(url)
    }
  }
  
  
}
