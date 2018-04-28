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
    
    @IBAction func nextPage(_ sender: Any) {
        if page == maxpage - 1 {
            self.ButtonNext.titleLabel?.text = "Начать"
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if UserDefaults.isFirstLoad() {
            self.maxpage = ImagesLoader.images.count - 1
            self.Image.image = ImagesLoader.images[self.page]
        } else {
            Start()
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func Start() {
        
    }

}
