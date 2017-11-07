//
//  MemesTableViewController.swift
//  MemeExperiment
//
//  Created by Jason Hsu on 2/27/17.
//  Copyright © 2017 Jason Hsu. All rights reserved.
//

import Foundation
import UIKit

class MemesTableViewController: UITableViewController{
    
    var memes: [Meme]!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    
        
    tabBarController?.tabBar.isHidden = false
    
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
        memes = appDelegate.memes
        self.tableView?.reloadData()
    }
     override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
     override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int{
        return self.memes.count
    }
    
     override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cellReuseIdentifier")!
        let savedMemes = memes[(indexPath as NSIndexPath).row]
        cell.textLabel?.text = savedMemes.topText
        cell.imageView?.image = savedMemes.memedImage
        cell.isUserInteractionEnabled = true
        return cell
    }
   
     override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let detailController = self.storyboard?.instantiateViewController(withIdentifier: "MemeDetailViewController") as! MemeDetailViewController
        detailController.meme = memes[(indexPath as NSIndexPath).row].memedImage
        self.navigationController!.pushViewController(detailController, animated: true)
        
    }
}
