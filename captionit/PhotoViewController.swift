/*Copyright (c) 2016, Andrew Walz.

Redistribution and use in source and binary forms, with or without modification,are permitted provided that the following conditions are met:

1. Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.

2. Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the
documentation and/or other materials provided with the distribution.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO,
THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS
BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE
GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE. */

import UIKit
import FirebaseDatabase

class PhotoViewController: UIViewController {
     var ref:DatabaseReference! = Database.database().reference()
	override var prefersStatusBarHidden: Bool {
		return true
	}
    var backgroundImage: UIImage?
    var curPin:String?
    @IBAction func unwindToSwifty(segue: UIStoryboardSegue){}

	override func viewDidLoad() {
		super.viewDidLoad()
		self.view.backgroundColor = UIColor.gray
		let backgroundImageView = UIImageView(frame: view.frame)
		backgroundImageView.contentMode = UIViewContentMode.scaleAspectFit
		backgroundImageView.image = backgroundImage
		view.addSubview(backgroundImageView)
        let cancelButton = UIButton(frame: CGRect(x: 20.0, y: 20.0, width: 30.0, height: 30.0))
        cancelButton.setImage(#imageLiteral(resourceName: "close-button"), for: UIControlState())
        cancelButton.addTarget(self, action: #selector(cancel), for: .touchUpInside)
        view.addSubview(cancelButton)
        
        let useIcon = UIButton(frame: CGRect(x: view.frame.size.width - 90, y: view.frame.size.height - 90 , width: 80.0, height: 80.0))
        useIcon.setImage(#imageLiteral(resourceName: "selected"), for: UIControlState())
        useIcon.addTarget(self, action: #selector(saveImage), for: .touchUpInside)
        view.addSubview(useIcon)
        
	}
    func cancel() {        //need to segue now
//        performSegue(withIdentifier: "returnToSwifty", sender: self)
      self.navigationController?.popViewController(animated: true)
    }
  
	func saveImage() {		//need to segue now
        performSegue(withIdentifier: "SavedImageSegue", sender: self)
	}
//    func useImage(){
//        if let currentPlayer = getCurrentPlayer(){
//            currentPlayer.memePhoto = true//not sure what case does
//        self.ref.child("rooms").child(curPin!).child("players").child(currentPlayer.username).updateChildValues(["meme Photo":currentPlayer.memePhoto])
//            saveImage()//go to upload meme
//
//
//        }
//    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SavedImageSegue" {
            let controller = segue.destination as! RoomViewController
            controller.curPin = curPin //should I keep on passing the current pin
            controller.previewImage = backgroundImage
            controller.mediaType = 1
          controller.pickerGallery = false
          //  controller.pickMeme.setTitle("Change Meme?", for: .normal)
        }
    }
}
