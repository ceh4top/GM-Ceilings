//
//  LearningViewController.swift
//  GM Ceilings
//
//  Created by GM on 27.04.18.
//  Copyright © 2018 GM. All rights reserved.
//

import UIKit

class LearningViewController: UIViewController {
    @IBOutlet weak var Image: UIImageView!
    @IBOutlet weak var ButtonNext: UIButton!
    
    var page = 0
    var maxpage = 0
    
    @IBAction func nextPage(_ sender: UIButton) {
        if self.page >= self.maxpage {
            self.Start()
        }
        else {
            self.nextPageCode()
        }
    }
    
    func nextPageCode() {
        if self.page == self.maxpage - 1 {
            self.ButtonNext.setTitle("Начать", for: .normal)
        }
        
        if self.page < self.maxpage {
            self.page += 1
            self.Image.image = ImagesLoader.images[self.page]
        }
    }
    
    func predPageCode() {
        if self.page > 0 {
            self.page -= 1
            self.Image.image = ImagesLoader.images[self.page]
        }
        
        if self.page == self.maxpage - 1 {
            self.ButtonNext.setTitle("Понятно", for: .normal)
        }
    }
    
    func swipe(gesture: UISwipeGestureRecognizer) {
        switch gesture.direction {
        case UISwipeGestureRecognizerDirection.left:
            self.nextPageCode()
        case UISwipeGestureRecognizerDirection.right:
            self.predPageCode()
        default:
            print("default")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.maxpage = ImagesLoader.images.count - 1
        self.Image.image = ImagesLoader.images[self.page]
        
        let swipeLeft = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe))
        swipeLeft.direction = UISwipeGestureRecognizerDirection.left
        
        let swipeRight = UISwipeGestureRecognizer(target: self, action: #selector(self.swipe))
        swipeRight.direction = UISwipeGestureRecognizerDirection.right
        
        self.view.addGestureRecognizer(swipeLeft)
        self.view.addGestureRecognizer(swipeRight)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func Start() {
        let user = UserDefaults.getUser()
        user.firstLoad = false
        UserDefaults.setUser(user)
        
        ImagesLoader.clearImages()
        dismiss(animated: true, completion: nil)
    }

}
