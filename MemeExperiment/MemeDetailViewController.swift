//
//  MemeDetailViewController.swift
//  MemeExperiment
//
//  Created by Jason Hsu on 3/2/17.
//  Copyright © 2017 Jason Hsu. All rights reserved.
//

import Foundation
import UIKit

class MemeDetailViewController: UIViewController{
    
    @IBOutlet weak var memedImageView: UIImageView!
    var meme: UIImage!
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        memedImageView.image = meme
        self.tabBarController?.tabBar.isHidden = true
    }
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
}
